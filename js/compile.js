// Emits JS code for Smalltalk methods.
//
// This module defines two methods:
//     smalltalk.compileImage(classes_ast, objects_ast)
//         Emit JS code for all the given classes and the given object graph.
//         This returns a string containing a single JS expression that
//         evaluates to a function. The function takes one argument,
//         SmalltalkRuntime, and populates it with classes and objects.
//
//     smalltalk.compileMethodLive(runtime, method_ast)
//         This is used by the repl to compile throw-away code at run time.
//         It returns a JS function of no arguments. Calling the function
//         executes the Smalltalk code of method_ast.
//
// JavaScript names (all of these are local to the JS function we emit):
//   _k24 (and other integers) - Constants.
//
//   __smalltalk, $B, $G - Runtime support.
//
//   _SmallInteger, _Array, _Symbol - Class objects or constant pools.
//          These names always match /^_[A-Z][A-Za-z0-9]*$/.
//          The ones that are constant pools are JS objects, not Smalltalk
//          Dictionary objects (for simpler JS code).
//
//   abc - Local variables and arguments always match /^[A-Za-z][A-Za-z0-9]*$/.
//
//   this_ - Local variables and arguments whose names happen to be JS keywords
//          (or 'arguments' or 'eval') are given a trailing underscore.  This
//          can't collide with anything since Smalltalk identifiers can't
//          contain underscores.
//
//   $a - A special name used by compiler-generated code to implement
//          return-from-block. The "a" is for "answer".
//
//   $$k - Variables used in primitives. Since primitives are just pasted into
//          the compiled code, they need to use variable names that won't
//          collide with anything else.  These always match
//          /^\$\$[A-Za-z0-9]+$/.

(function () {
    "use strict";

    function assert(b, msg) { if (!b) throw new Error("assertion failed: " + msg); }

    var ASSIGN_PREC = 1;
    var POSTFIX_PREC = 2;

    var jsReservedWords = {
        arguments: 1, break: 1, case: 1, catch: 1, class: 1, const: 1,
        continue: 1, debugger: 1, default: 1, delete: 1, do: 1, else: 1,
        enum: 1, eval: 1, export: 1, extends: 1, false: 1, finally: 1, for: 1,
        function: 1, if: 1, implements: 1, import: 1, in: 1, instanceof: 1,
        interface: 1, let: 1, new: 1, null: 1, package: 1, private: 1,
        protected: 1, public: 1, return: 1, static: 1, super: 1, switch: 1,
        this: 1, throw: 1, true: 1, try: 1, typeof: 1, var: 1, void: 1,
        while: 1, with: 1
    };

    function toJSName(id) {
        return jsReservedWords.hasOwnProperty(id) ? id + "_" : id;
    }

    function selectorToJSString(s) {
        return s.replace(/:/g, "_");
    }

    function selectorToPropertyTag(s) {
        return s.match(/^[A-Za-z]/)
               ? s.replace(/:/g, "_")
               : "'" + s.replace(/\\/g, "\\\\") + "'";  //);//
    }

    // squiggleNames and toJSFunctionName are used to compute the display name
    // of JS functions that implement methods. These names don't affect the
    // behavior of the program, but they appear in JS error stacks, where an
    // informative method name is invaluable.

    var squiggleNames = {
        "+": "plus",
        "-": "minus",
        "*": "star",
        "/": "slash",
        "\\": "backslash",
        "<": "lt",
        ">": "gt",
        "=": "eq",
        "@": "at",
        ",": "comma",
        "~": "tilde",
        "&": "amp",
        "^": "caret",
        "|": "bar",
        "%": "pct",  // does not occur
        "`": "tick", // does not occur
        "?": "qmark" // does not occur
    };

    function toJSFunctionName(className, selector) {
        var s;
        if (selector.match(/^[a-zA-Z]/)) {
            s = selector.replace(/:/g, "_");
        } else {
            s = "_";
            for (var i = 0; i < selector.length; i++)
                s += "_" + squiggleNames[selector[i]];
        }
        return className + "$" + s;
    }

    function messageJSName(n) {
        assert(n.type === "Message");
        return (n.selector.match(/^[A-Za-z]/)
                ? "." + n.selector.replace(/:/g, "_")
                : "['" + n.selector.replace(/\\/g, "\\\\") + "']");
    }

    function declareLocals(arr, indent) {
        if (arr.length === 0)
            return "";
        return indent + "var " + arr.map(toJSName).join(", ") + ";\n";
    }

    var inlineableTypes = {
        "Nil": true,
        "True": true,
        "False": true,
        "Character": true,
        "String": true,
        "Symbol": true,
        "Float": true,
        "Integer": true,
        "LargeInteger": true,
        "ConstantArray": true,
        "Block": true
    }

    function isInlineable(n) {
        if (n.method.args.length !== 0)
            return false;
        var seq = n.method.body.seq;
        if (seq.length !== 1 || seq[0].type !== "AnswerExpr")
            return false;
        var val = seq[0].expr;
        return val.type in inlineableTypes;
    }

    function inlineableMethods(classes_ast) {
        // A table of candidates for optimization. Each entry has a selector
        // for the key and either a method object or false for the value. A
        // method object means there is exactly one method (so far)
        // implementing that selector, and it is inlineable. false means either
        // there are multiple implementations or the single implementation is
        // not inlineable.
        var candidates = Object.create(null);

        for (var name in classes_ast) {
            var cls = classes_ast[name];
            for (var selector in cls.methods) {
                var method = cls.methods[selector];
                if (selector in candidates || !isInlineable(method)) {
                    // Multiple implementations have now been seen; or the method isn't inlineable
                    candidates[selector] = false;
                } else {
                    candidates[selector] = method;
                }
            }
        }

        return candidates;
    }

    var subclassKindToFlags = {
        "subclass": 0,
        "variableSubclass": 1,
        "weakSubclass": 2,
        "variableWordSubclass": 3,
        "variableByteSubclass": 4
    };

    function RuntimeClassInfo(runtime) {
        this.runtime = runtime;
    }
    RuntimeClassInfo.prototype = {
        hasGlobal: function hasGlobal(name) {
            return name in this.runtime.globals;
        },
        hasClass: function hasClass(cls) {
            var clsobj = this.runtime.globals[cls];
            return Object.prototype.isPrototypeOf.call(this.runtime.globals.Class.__im, clsobj);
        },
        isDefiningClass: function isDefiningClass(cls) {
            return false;
        },
        getSuperclass: function getSuperclass(cls) {
            var scls = this.runtime.globals[cls].superclass();
            return scls === this.runtime.nil ? null : scls._name.__str;
        },
        hasInstVar: function hasInstVar(cls, name) {
            var c = this.runtime.globals[cls];
            var sup = c.superclass();
            for (var i = (sup === this.runtime.nil ? 0 : sup.__iv.length); i <  c.__iv.length; i++)
                if (c.__iv[i] === name)
                    return true;
            return false;
        },
        hasClassVar: function hasClassVar(cls, name) {
            return Object.prototype.hasOwnProperty.call(this.runtime.globals[cls], name);
        },
        getAllInstVarNames: function getAllInstVarNames(cls) {
            return [].concat(this.runtime.globals[cls].__iv);
        },
        getClassKind: function getClassKind(cls) {
            var flags = this.runtime.globals[cls].__flags;
            for (var kind in subclassKindToFlags)
                if (subclassKindToFlags[kind] === flags)
                    return kind;
            throw new Error("Unknown class kind: " + cls);
        },
        getPoolDictionaryNames: function getPoolDictionaryNames(cls) {
            assert(cls === "UndefinedObject");
            return [];
        },
        poolDictionaryHasEntry: function poolDictionaryHasEntry(pool, name) {
            var rt = this.runtime;
            return rt.globals[pool].includesKey_(rt.Symbol(name)) === rt.true;
        }
    };

    function StaticClassInfo(classes_ast, objects_ast) {
        this.classes_ast = classes_ast;
        this.objectGraph = null; // Must be populated by user before bind phase.
        this.poolDictionaryCache = Object.create(null);
    }
    StaticClassInfo.prototype = {
        hasGlobal: function hasGlobal(name) {
            return this.hasClass(name) || name in this.objectGraph.globals;
        },
        hasClass: function hasClass(cls) {
            return cls in this.classes_ast;
        },
        isDefiningClass: function isDefiningClass(cls) {
            return this.hasClass(cls);
        },
        getSuperclass: function getSuperclass(cls) {
            return this.classes_ast[cls].superclassName;
        },
        hasInstVar: function hasInstVar(cls, name) {
            return this.classes_ast[cls].instanceVariableNames.indexOf(name) !== -1;
        },
        hasClassVar: function hasClassVar(cls, name) {
            return this.classes_ast[cls].classVariableNames.indexOf(name) !== -1;
        },
        getAllInstVarNames: function getAllInstVarNames(cls) {
            var scls = this.classes_ast[cls];
            var names = [];
            while (true) {
                names = scls.instanceVariableNames.concat(names);
                if (scls.superclassName === null)
                    break;
                scls = this.classes_ast[scls.superclassName];
            }
            return names;
        },
        getClassKind: function getClassKind(cls) {
            return this.classes_ast[cls].subclassKind;
        },
        getPoolDictionaryNames: function getPoolDictionaryNames(cls) {
            return this.classes_ast[cls].poolDictionaries;
        },
        getPoolDictionaryEntries: function getGlobalDictionaryEntries(name) {
            var entries = this.poolDictionaryCache[name];
            if (entries === undefined) {
                var graph = this.objectGraph;
                var pool_id = graph.globals[name];
                assertEq(typeof pool_id, "number");
                var pool_desc = graph.objects[pool_id];
                assertEq(pool_desc.type, "Object");

                var fieldOffset = this.getAllInstVarNames(pool_desc.cls).indexOf("array");
                assert(fieldOffset !== -1);
                var arr_id = pool_desc.iv[fieldOffset];
                assertEq(typeof arr_id, "number");
                var arr_desc = graph.objects[arr_id];
                assertEq(arr_desc.type, "Object");
                var table = arr_desc.vld;

                entries = {};
                for (var i = 0; i < table.length; i++) {
                    var assoc_id = table[i];
                    if (typeof assoc_id === "number") {
                        var assoc_desc = graph.objects[assoc_id];
                        assertEq(assoc_desc.cls, "Association");
                        assertEq(assoc_desc.iv.length, 2);
                        var key = assoc_desc.iv[0];
                        if (typeof key === "object" && key.type === "Symbol")
                            entries[key.value] = assoc_desc.iv[1];
                    }
                }
                this.poolDictionaryCache[name] = entries;
            }
            return entries;
        },
        poolDictionaryHasEntry: function poolDictionaryHasEntry(pool, name) {
            return name in this.getPoolDictionaryEntries(pool);
        }
    };

    // Compilation is a whole-program operation.
    // We common up constants across the whole program, and
    // optimizations are planned that would be unsound if we didn't see
    // the whole program.
    function Compilation(classInfo) {
        this.classInfo = classInfo;
        if (classInfo instanceof StaticClassInfo)
            this.inlineable = inlineableMethods(classInfo.classes_ast);
        else
            this.inlineable = Object.create(null);
        this.allPoolDictionaries = {};

        // Support for Smalltalk constants
        this.constantDecls = [];
        this.nil = this.addConstant("__smalltalk.nil");
        this.true_ = this.addConstant("__smalltalk.true");
        this.false_ = this.addConstant("__smalltalk.false");
        this.charCache = Object.create(null);
        this.symbolCache = Object.create(null);
        this.stringCache = Object.create(null);
        this.integerCache = Object.create(null);
        this.floatCache = Object.create(null);
        this.constantCache = Object.create(null);

        this._nextsym = 1;
        this.requiresGlobal = false;
        this.unknownNames = [];

        // Per-class state
        this.currentClass = null;
    }

    Compilation.prototype = {
        addConstant: function addConstant(jsexpr) {
            var i = this.constantDecls.length;
            var name = "_k" + i;
            this.constantDecls[i] = "        " + name + " = " + jsexpr;
            return name;
        },

        getCharacter: function getCharacter(c) {
            assert(c.length === 1);
            var name = this.charCache[c];
            if (name === undefined)
                name = this.charCache[c] = this.addConstant("__smalltalk.chars[" + c.charCodeAt(0) + "]");
            return name;
        },

        getSymbol: function getSymbol(s) {
            var name = this.symbolCache[s];
            if (name === undefined)
                name = this.symbolCache[s] = this.addConstant("__smalltalk.Symbol(" + uneval(s) + ")");
            return name;
        },

        getString: function getString(s) {
            var name = this.stringCache[s];
            if (name === undefined)
                name = this.stringCache[s] = this.addConstant("__smalltalk.String(" + uneval(s) + ")");
            return name;
        },

        getInteger: function getInteger(n) {
            var s = "" + n;
            var name = this.integerCache[s];
            if (name === undefined)
                name = this.integerCache[s] = this.addConstant("__smalltalk.SmallInteger(" + s + ")");
            return name;
        },

        getLargeInteger: function getLargeInteger(s) {
            var name = this.integerCache[s];
            if (name === undefined)
                name = this.integerCache[s] = this.addConstant("__smalltalk.LargeInteger('" + s + "')");
            return name;
        },

        getFloat: function getFloat(n) {
            var s;
            if (n === 1/0)
                s = "1/0";
            else if (n === -1/0)
                s = "-1/0";
            else if (n === 0 && 1 / n < 0)
                s = "-0";
            else
                s = "" + n;

            var name = this.floatCache[s];
            if (name === undefined)
                name = this.floatCache[s] = this.addConstant("__smalltalk.Float(" + s + ")");
            return name;
        },

        getConstant: function getConstant(code) {
            var name = this.constantCache[code];
            if (name === undefined)
                name = this.constantCache[code] = this.addConstant(code);
            return name;
        },

        gensym: function gensym() {
            return "$" + this._nextsym++;
        },

        translateConstant: function translateConstant(n) {
            switch (n.type) {
            case "Nil":           return this.nil;
            case "True":          return this.true_;
            case "False":         return this.false_;
            case "Character":     return this.getCharacter(n.value);
            case "String":        return this.getString(n.value);
            case "Symbol":        return this.getSymbol(n.value);
            case "Float":         return this.getFloat(n.value);
            case "Integer":       return this.getInteger(n.value);
            case "LargeInteger":  return this.getLargeInteger(n.value);
            default:
                throw new Error("not a constant: " + JSON.stringify(n));
            }
        },

        translateObjectGraph: function translateObjectGraph() {
            var comp = this;

            function translateValue(node) {
                if (typeof node === "number")
                    return "" + node;
                switch (node.type) {
                case "Identifier":
                    if (node.id === "NegativeInfinity")
                        return comp.getFloat(-1/0);
                    else if (node.id === "Infinity")
                        return comp.getFloat(1/0);
                    else if (node.id === "NaN")
                        return comp.getFloat(0/0);
                    throw new Error("unrecognized identifier: " + node.id);

                case "Nil": case "True": case "False":
                case "Integer": case "LargeInteger":
                case "Float":
                case "Character": case "String": case "Symbol":
                    return comp.translateConstant(node);

                default:
                    throw new Error("unrecognized value in object graph");
                }
            }

            var graph = comp.classInfo.objectGraph;

            var objectCode = [];
            for (var i = 0; i < graph.objects.length; i++) {
                var obj = graph.objects[i];
                if (obj === null) {
                    objectCode[i] = "null";
                } else if (obj.type === "Class") {
                    objectCode[i] = "_" + obj.name;
                } else {
                    assertEq(obj.type, "Object");
                    var s = "[_" + obj.cls + ", [" + obj.iv.map(translateValue).join(", ") + "]";

                    // Translate variable-length data, if any.
                    var vld = obj.vld;
                    if (vld !== null) {
                        if (typeof vld === "string") {
                            // Binary data.
                            s += ", '" + vld + "'";
                        } else {
                            s += ", [" + vld.map(translateValue).join(", ") + "]";
                        }
                    }
                    s += "]";

                    objectCode[i] = s;
                }
            }

            var refCode = [];
            for (var key in graph.globals) {
                var val = translateValue(graph.globals[key]);
                refCode.push("[\"S\", " + JSON.stringify(key) + ", " + val + "]");
            }
            for (var clsName in graph.classVars) {
                var cls = graph.classVars[clsName];
                for (var key in cls) {
                    var val = translateValue(cls[key]);
                    refCode.push("[_" + clsName + ", " + JSON.stringify(key) + ", " + val + "]");
                }
            }

            return ("__smalltalk.initObjectGraph(" +
                    "[\n        " + objectCode.join(",\n        ") + "\n    ], " +
                    "[\n        " + refCode.join(",\n        ") + "\n    ]" +
                    ");\n");
        },

        translateMethod: function translateMethod(className, n, isInstanceMethod) {
            var comp = this;

            var methodArgJSNames = n.method.args.map(toJSName);

            // translateBody will set methodRequiresSelf to true if
            // any block in this method (that is actually translated
            // as its own JS function) uses 'self'.
            var methodRequiresSelf = false;

            // translateBody will set methodRequiresAnswer to true if
            // any block in this method (that is actually translated
            // as its own JS function) returns.
            var methodRequiresAnswer = false;

            // This is nonzero if the innermost surrounding JS function is
            // a block or cascade lambda, not the method.
            var inLambda = 0;

            function translateBlockBodyInlineAsStmts(body, indent) {
                var seq = body.seq;
                var code = '';
                for (var i = 0; i < seq.length; i++)
                    code += translateStmt(seq[i], indent);
                return code;
            }

            // Return true if the given AST node is guaranteed to be effect-free.
            function isEffectFree(n) {
                switch (n.type) {
                case "Nil":
                case "True":
                case "False":
                case "Self":
                case "ThisContext":
                case "Identifier":
                case "Local":
                case "InstVar":
                case "ClassVar":
                case "PoolVar":
                case "Global":
                case "Character":
                case "String":
                case "Symbol":
                case "Float":
                case "Integer":
                case "LargeInteger":
                case "ConstantArray":
                case "Block":
                    return true;

                case "ArrayExpr":
                    return n.elements.every(isEffectFree);

                case "ExprSeq":
                    return n.seq.every(isEffectFree);
                }
                return false;
            }

            function translateStmt(n, indent) {
                if (isEffectFree(n)) {
                    console.warn("useless expression in " + className + ">>" + selector);
                    return "";
                }

                switch (n.type) {
                case "ArrayExpr":
                    console.warn("unused array expression in " + className + ">>" + selector);
                    break;

                case "AnswerExpr":
                    if (inLambda) {
                        methodRequiresAnswer = true;
                        return indent + "$a[0] = " + translateExpr(n.expr, ASSIGN_PREC, indent) + ";\n" +
                               indent + "throw $a;\n";
                    } else {
                        return indent + "return " + translateExpr(n.expr, ASSIGN_PREC, indent) + ";\n";
                    }
                    break;

                case "MessageExpr":
                    var msg = n.message;
                    assert(msg.type === "Message");
                    var target = msg.selector;
                    if (n.receiver.type === "Super")
                        break;
                    if (comp.inlineable[target]) {
                        var seq = comp.inlineable[target].method.body.seq;
                        assertEq(seq.length, 1);
                        assertEq(seq[0].type, "AnswerExpr");
                        if (isEffectFree(n.receiver)) {
                            console.warn("optimizing away useless call to " + n.receiver);
                            return "";
                        }
                    } else if (target === "ifTrue:" && msg.args[0].type === "Block") {
                        return indent + "if (" +
                            translateExpr(n.receiver, POSTFIX_PREC, indent + "    ") +
                            " === " + comp.true_ + ") {\n" +
                            translateBlockBodyInlineAsStmts(msg.args[0].body, indent + "    ") +
                            indent + "}\n";
                    } else if (target === "ifFalse:" && msg.args[0].type === "Block") {
                        return indent + "if (!(" +
                            translateExpr(n.receiver, POSTFIX_PREC, indent + "    ") +
                            " === " + comp.true_ + ")) {\n" +
                            translateBlockBodyInlineAsStmts(msg.args[0].body, indent + "    ") +
                            indent + "}\n";
                    } else if ((target === "ifTrue:ifFalse:" || target === "ifFalse:ifTrue:") &&
                               msg.args[0].type === "Block" && msg.args[1].type === "Block") {
                        var tf = target === "ifTrue:ifFalse:";
                        var ifTrueBlock = msg.args[tf ? 0 : 1];
                        var ifFalseBlock = msg.args[tf ? 1 : 0];
                        return indent + "if (" +
                            translateExpr(n.receiver, POSTFIX_PREC, indent + "    ") +
                            " === " + comp.true_ + ") {\n" +
                            translateBlockBodyInlineAsStmts(ifTrueBlock.body, indent + "    ") +
                            indent + "} else {\n" +
                            translateBlockBodyInlineAsStmts(ifFalseBlock.body, indent + "    ") +
                            indent + "}\n";
                    } else if ((target === "whileTrue:" || target === "whileFalse:") &&
                               n.receiver.type === "Block" &&
                               msg.args[0].type === "Block") {
                        var testexpr = translateExpr(n.receiver.body, POSTFIX_PREC, indent + "    ") + " === " + comp.true_;
                        if (target === "whileFalse:")
                            testexpr = "!(" + testexpr + ")";
                        return indent + "while (" + testexpr + ") {\n" +
                            translateBlockBodyInlineAsStmts(msg.args[0].body, indent + "    ") +
                            indent + "}\n";
                    }
                    break;
                }
                return indent + translateExpr(n, ASSIGN_PREC, indent) + ";\n";
            }

            function translateBody(b) {
                assert(b.type === "ExprSeq");
                b = b.seq;
                var hasPrimitive = (b.length > 0 && b[0].type === "Primitive");
                var hasAnswer = (b.length > 0 && b[b.length - 1].type === "AnswerExpr");

                var s = "";
                var indent = "            ";
                if (hasPrimitive) {
                    var p = b[0];
                    s = indent + "// " + JSON.stringify(p) + "\n";;
                    var ps = SmalltalkRuntime.getPrimitive(p.module, p.primitive);
                    if (ps === undefined) {
                        //console.warn("No such primitive: " + JSON.stringify(n));
                        s += indent + "// No such primitive.\n";
                    } else {
                        var replacement = function(s, n) {
                            return methodArgJSNames[parseInt(n)];
                        };
                        ps = ps.replace(/{([0-9]+)}/g, replacement);
                        ps = ps.replace(/\n$/, ''); // chomp trailing newline
                        ps = ps.replace(/^/mg, indent);
                        s += ps + "\n"; // re-add trailing newline
                    }
                    s += "\n";
                }

                var exprs = b.slice(0 + hasPrimitive, b.length - hasAnswer).map(function (x) {
                    return translateStmt(x, "            ");
                });
                s += exprs.join("");
                if (hasAnswer)
                    s += "            return " + translateExpr(b[b.length - 1].expr, ASSIGN_PREC, "                ") + ";\n";
                else
                    s += "            return this;\n";
                return s;
            }

            function thisObject() {
                if (inLambda) {
                    methodRequiresSelf = true;
                    return "_self";
                }
                return "this";
            }

            function jsIfExpr(testExpr, trueExpr, falseExpr) {
                return "(" + testExpr + " === " + comp.true_ + " ? " + trueExpr + " : " + falseExpr + ")";
            }

            function translateExpr(n, prec, indent) {
                switch (n.type) {
                case "Nil":
                case "True":
                case "False":
                case "Integer":
                case "LargeInteger":
                case "Float":
                case "Character":
                case "String":
                case "Symbol":
                    return comp.translateConstant(n);

                case "Self": return thisObject();

                case "ThisContext":
                    return "__smalltalk.getThisContext()";

                case "Identifier":
                    throw new Error("internal error: bind phase did not bind identifier");

                case "Local":
                    return toJSName(n.id);

                case "InstVar":
                    return translateExpr(n.obj, POSTFIX_PREC, indent) + "._" + n.id;

                case "ClassVar":
                    return "_" + n.className + "._" + n.id;

                case "PoolVar":
                    comp.allPoolDictionaries[n.poolName] = true;
                    return "_" + n.poolName + "." + n.id;

                case "Global":
                    if (comp.classInfo.isDefiningClass(n.id))
                        return "_" + n.id;

                    if (!comp.classInfo.hasGlobal(n.id)) {
                        if (comp.unknownNames.indexOf(n.id) === -1) {
                            comp.unknownNames.push(n.id);
                            console.warn("unknown name: " + n.id);
                        }
                    }
                    comp.requiresGlobal = true;
                    return "$G." + n.id;

                case "Primitive":
                    throw new Error("Unexpected <primitive:> in expression");

                case "ConstantArray":
                    {
                        var indent2 = indent + "    ";
                        var exprs = n.elements.map(function (n2) { return translateExpr(n2, ASSIGN_PREC, indent2); });
                        return comp.addConstant("__smalltalk.Array([" + exprs.join(", ") + "])");
                    }

                case "ArrayExpr":
                    {
                        var indent2 = indent + "    ";
                        var exprs = n.elements.map(function (n2) { return translateExpr(n2, ASSIGN_PREC, indent2); });
                        return "__smalltalk.Array([" + exprs.join(", ") + "])";
                    }

                case "Block":
                    assert(n.body.type === "ExprSeq");
                    inLambda++;
                    try {
                        var indent2 = indent + "    ";
                        var args = n.params.length === 0
                                   ? ""
                                   : n.params.map(toJSName).join(", ");
                        var vars = declareLocals(n.locals, indent2);
                        var seq = n.body.seq;
                        var stmts = '', last;
                        if (seq.length === 0) {
                            last = indent2 + "return " + comp.nil + ";\n";
                        } else {
                            for (var i = 0; i < seq.length - 1; i++)
                                stmts += indent2 + translateExpr(seq[i], ASSIGN_PREC, indent2) + ";\n";
                            var lastExpr = seq[seq.length - 1];
                            if (lastExpr.type === "AnswerExpr") {
                                methodRequiresAnswer = true;
                                last = indent2 + "$a[0] = " + translateExpr(lastExpr.expr, ASSIGN_PREC, indent2) + ";\n" +
                                       indent2 + "throw $a;\n";
                            } else {
                                last = indent2 + "return " + translateExpr(lastExpr, ASSIGN_PREC, indent2) + ";\n";
                            }
                        }
                        return "$B(function (" + args + ") {\n" + vars + stmts + last + indent + "})";
                    } finally {
                        inLambda--;
                    }

                case "ExprSeq":
                    // This can happen only if a block has been inlined.
                    if (n.seq.length === 0)
                        return comp.nil;
                    else if (n.seq.length === 1)
                        return translateExpr(n.seq[0], prec, indent);
                    else {
                        return "(" + n.seq.map(function (n) {
                            return translateExpr(n, ASSIGN_PREC, indent + "    ");
                        }).join(", ") + ")";
                    }
                    break;

                case "AnswerExpr":
                    // This can happen only if a block has been inlined.
                    methodRequiresAnswer = true;
                    return "__smalltalk.answer($a, " + translateExpr(n.expr, ASSIGN_PREC, indent + "    ") + ")";

                case "MessageExpr":
                    {
                        var indent2 = indent + "    ";
                        var rcv = n.receiver;
                        var msg = n.message;
                        assert(msg.type === "Message");
                        if (rcv.type === "Super") {
                            var args = messageJSArgsNoParens(msg, indent2);
                            if (args)
                                args = thisObject() + ", " + args;
                            else
                                args = thisObject();
                            var scls = comp.classInfo.getSuperclass(comp.currentClass);
                            if (scls === null)
                                throw new Error("super cannot be used in class Object");
                            return "_" + scls +
                                   (isInstanceMethod ? ".__im" : "") +
                                   messageJSName(msg) + ".call(" + args + ")";
                        }

                        var target = msg.selector;
                        if (comp.inlineable[target]) {
                            var seq = comp.inlineable[target].method.body.seq;
                            assertEq(seq.length, 1);
                            assertEq(seq[0].type, "AnswerExpr");
                            if (isEffectFree(n.receiver))
                                return translateExpr(seq[0].expr, ASSIGN_PREC, indent + "    ");
                        }

                        if (target === "ifTrue:" && msg.args[0].type === "Block") {
                            return jsIfExpr(translateExpr(rcv, POSTFIX_PREC, indent + "    "),
                                            translateExpr(msg.args[0].body, ASSIGN_PREC, indent + "    "),
                                            comp.nil);
                        } else if (msg.selector === "ifFalse:" && msg.args[0].type === "Block") {
                            return jsIfExpr(translateExpr(rcv, POSTFIX_PREC, indent + "    "),
                                            comp.nil,
                                            translateExpr(msg.args[0].body, ASSIGN_PREC, indent + "    "));
                        } else if ((msg.selector === "ifTrue:ifFalse:" || msg.selector === "ifFalse:ifTrue:") &&
                                   msg.args[0].type === "Block" && msg.args[1].type === "Block") {
                            var tf = msg.selector === "ifTrue:ifFalse:";
                            var ifTrueBlock = msg.args[tf ? 0 : 1];
                            var ifFalseBlock = msg.args[tf ? 1 : 0];
                            return jsIfExpr(translateExpr(n.receiver, POSTFIX_PREC, indent + "    "),
                                            translateExpr(ifTrueBlock.body, ASSIGN_PREC, indent + "    "),
                                            translateExpr(ifFalseBlock.body, ASSIGN_PREC, indent + "    "));
                        }

                        return translateExpr(rcv, POSTFIX_PREC, indent2) + translateMessage(msg, indent2);
                    }

                case "CascadeExpr":
                    {
                        var indent2 = indent + "    ";
                        var hd = n.head, msgs = n.messages;
                        if (hd.type !== "MessageExpr")
                            throw new Error("left-hand side of ';' must be a message expression");
                        if (hd.receiver.type === "SuperExpr")
                            throw new Error("cascading not allowed with super");
                        var rcvar = comp.gensym();
                        inLambda++;
                        try {
                            var s = "(function (" + rcvar + ") {\n";
                            s += indent2 + rcvar + translateMessage(hd.message, indent2) + ";\n";
                            for (var i = 0; i < msgs.length; i++) {
                                s += indent2;
                                if (i === msgs.length - 1)
                                    s += "return ";
                                s += rcvar + translateMessage(msgs[i], indent2) + ";\n";
                            }
                        } finally {
                            inLambda--;
                        }
                        return s + indent + "})(" + translateExpr(hd.receiver, ASSIGN_PREC, indent2) + ")";
                    }

                case "AssignExpr":
                    {
                        var lhs = translateExpr(n.left, POSTFIX_PREC, "");
                        var rhs = translateExpr(n.right, ASSIGN_PREC, indent + "    ");
                        var s = lhs + " = " + rhs;
                        if (prec > ASSIGN_PREC)
                            s = "(" + s + ")";
                        return s;
                    }

                default:
                    console.warn("unrecognized node type in translateExpr: " + n.type);
                    return JSON.stringify(n);
                }
            }

            function messageJSArgsNoParens(n, indent) {
                assert(n.type == "Message");
                var indent2 = indent + "    ";
                var argexprs = n.args.map(function (n2) { return translateExpr(n2, ASSIGN_PREC, indent2); });
                return argexprs.join(", ");
            }

            function messageJSArgs(n, indent) {
                return "(" + messageJSArgsNoParens(n, indent) + ")";
            }

            function translateMessage(n, indent) {
                return messageJSName(n) + messageJSArgs(n, indent);
            }

            var selector = n.method.selector;
            var propertyTag = selectorToPropertyTag(selector);
            var functionName = toJSFunctionName(className, selector);
            var body = translateBody(n.method.body, "            ");
            var selfDecl = methodRequiresSelf ? "            var _self = this;\n" : "";
            var answerBegin = methodRequiresAnswer ? "            var $a = [];\n            try {\n" : "";
            var answerEnd = methodRequiresAnswer ? "            } catch (exc) {\n                if (exc !== $a) throw exc;\n                return $a[0];\n            }\n" : "";

            // Glue the pieces together.
            return (propertyTag + ": function " + functionName + "(" +
                    methodArgJSNames.join(", ") + ") {\n" +
                    selfDecl +
                    declareLocals(n.method.locals, "            ") +
                    answerBegin +
                    body +
                    answerEnd +
                    "        }");
        },

        translateClass: function translateClass(cls) {
            this.currentClass = cls.name;
            try {
                var s = "    // " + cls.name + "\n";
                for (var i = 0; i < cls.weirdness.length; i++)
                    s += "    // " + JSON.stringify(cls.weirdness[i]) + "\n";

                s += "    var _" + cls.name + " = __smalltalk.defClass('" + cls.name + "', " +
                    (cls.superclassName === null ? "null" : "_" + cls.superclassName) + ", ";

                var a = [];
                for (var name in cls.methods) {
                    if (!SmalltalkRuntime.hasMethod(cls.name, selectorToJSString(name)))
                        a.push("        " + this.translateMethod(cls.name, cls.methods[name], true));
                }
                s += "{\n" + a.join(",\n") + "\n    }, {\n";

                a = [];
                for (var name in cls.classMethods) {
                    if (!SmalltalkRuntime.hasClassMethod(cls.name, selectorToJSString(name)))
                        a.push("        " + this.translateMethod(cls.name, cls.classMethods[name], false));
                }
                s += a.join(",\n") + "\n    },\n";

                var varNames = function (vn) {
                    if (vn.length === 0)
                        return "[]";
                    return "['_" + vn.join("', '_") + "']";
                };
                s += "    " + varNames(cls.instanceVariableNames) + ", ";
                s += varNames(cls.classVariableNames) + ", ";
                assert(subclassKindToFlags.hasOwnProperty(cls.subclassKind));
                s += subclassKindToFlags[cls.subclassKind] + ");\n\n";
            } finally {
                this.currentClass = null;
            }
            return s;
        },

        translatePoolDictionaries: function translatePoolDictionaries() {
            // Emit more code for pool dictionaries.
            var code = "\n";
            for (var pool in this.allPoolDictionaries) {
                var entries = this.classInfo.getPoolDictionaryEntries(pool);
                var entries_code = [];
                for (var name in entries) {
                    if (/^[A-Za-z][0-9A-Za-z]*$/.test(name)) {
                        var desc = entries[name];
                        if (typeof desc === "object")
                            entries_code.push(name + ": " + this.translateConstant(desc));
                    }
                }
                code += ("    var _" + pool + " = {\n        " +
                         entries_code.join(",\n        ") +
                         "\n    };\n");
            }
            return code;
        },

        wrapOutput: function wrapOutput(code) {
            return ("(function (__smalltalk) {\n" +
                    "    var $B = __smalltalk.Block;\n" +
                    (this.requiresGlobal ? "    var $G = __smalltalk.globals;\n" : "") +
                    (this.constantDecls.length === 0 ? "" : "    var\n" + this.constantDecls.join(",\n") + ";\n") +
                    code +
                    "});\n");
        }
    };

    function simplifyObjectGraph(classInfo, objects_ast) {
        function simplifyValue(node) {
            if (node.type === "MessageExpr") {
                assertEq(node.receiver.id, "U");
                assertEq(node.message.selector, "at:");
                assertEq(node.message.args[0].type, "Integer");
                return node.message.args[0].value - 1;
            } else {
                return node;
            }
        }

        assertEq(objects_ast.type, "MethodDefinition");
        var stmts = objects_ast.body.seq;
        assertEq(stmts.length, 2);

        var xexpr = stmts[0];
        assertEq(xexpr.type, "AssignExpr");
        assertEq(xexpr.left.type, "Identifier");
        assertEq(xexpr.left.id, "X");
        assertEq(xexpr.right.type, "ArrayExpr");
        var refDescs = xexpr.right.elements;

        var uexpr = stmts[1];
        assertEq(uexpr.type, "AssignExpr");
        assertEq(uexpr.left.type, "Identifier");
        assertEq(uexpr.left.id, "U");
        assertEq(uexpr.right.type, "ArrayExpr");
        var objectDescs = uexpr.right.elements;

        var objects = [];
        for (var i = 0; i < objectDescs.length; i++) {
            var objDescArr = objectDescs[i].elements;
            assert(objDescArr.length === 2 || objDescArr.length === 3);

            // Translate the class of the object.
            // cls will be the name of the class, if any; and null
            // if the class is a metaclass.
            var cls;
            var classId = objDescArr[0];
            var found;
            if (classId.type === "Identifier") {
                cls = classId.id;
                found = classInfo.hasClass(cls);
            } else if (classId.type === "MessageExpr") {
                assertEq(classId.receiver.type, "Identifier");
                assertEq(classId.message.selector, "class");
                found = classInfo.hasClass(classId.receiver.id);
                if (found) {
                    objects[i] = {type: "Class", name: classId.receiver.id};
                    continue;
                }
            } else {
                throw new Error("unrecognized class in object graph");
            }
            if (!found) {
                // This object is of a class that isn't in the source file.
                // This happens when loading the Scratch object dump with
                // the handmade-test.st source file.
                objects[i] = null;
                continue;
            }

            // Translate instance variable values.
            var ivValues = objDescArr[1];
            var ivNames = classInfo.getAllInstVarNames(classId.id);
            assertEq(ivValues.elements.length, ivNames.length,
                     "expected " + ivNames.length + " fields in " + classId.id + ": " +
                     ivNames.join(", "));
            var iv = ivValues.elements.map(simplifyValue);

            // Translate variable-length data, if any.
            var vld = null;
            if (objDescArr.length >= 3) {
                vld = objDescArr[2];

                if (cls !== null && classInfo.getClassKind(cls) === "variableByteSubclass") {
                    // Binary data.
                    var octet = function (n) {
                        assertEq(n.type, "Integer");
                        assert(n.value >= 0 && n.value < 256);
                        return (256 + n.value).toString(16).substring(1);
                    };
                    vld = vld.elements.map(octet).join("");
                } else if (cls != null && classInfo.getClassKind(cls) === "variableWordSubclass") {
                    // Word-sized binary data.
                    var word = function (n) {
                        var v;
                        if (n.type === "Integer") {
                            v = n.value;
                        } else {
                            assertEq(n.type, "LargeInteger");
                            v = parseInt(n.value, 16);
                        }
                        assert(v >= 0 && v <= 0xffffffff);
                        return (0x100000000 + v).toString(16).substring(1);
                    };
                    vld = vld.elements.map(word).join("");
                } else {
                    // Ordinary variable-length data.
                    vld = vld.elements.map(simplifyValue);
                }
            }

            objects[i] = {type: "Object", cls: cls, iv: iv, vld: vld};
        }

        var nil = smalltalk.ast.Nil();

        var globals = Object.create(null);
        var classVars = Object.create(null);
        for (var i = 0; i < refDescs.length; i++) {
            var refDescArr = refDescs[i].elements;
            assertEq(refDescArr.length, 3);
            assertEq(refDescArr[0].type, "Identifier");
            var objid = refDescArr[0].id;
            assertEq(refDescArr[1].type, "Symbol");
            var key = refDescArr[1].value;
            var val = simplifyValue(refDescArr[2]);

            if (objid === "Smalltalk") {
                assert(!(key in globals));
                globals[key] = val;
            } else if (classInfo.hasClass(objid)) {
                var cls = classVars[objid];
                if (cls === undefined)
                    cls = classVars[objid] = {};
                assert(!(key in cls));
                cls[key] = val;
            }
        }

        return {objects: objects, globals: globals, classVars: classVars};
    }

    function compileImage(classes_ast, objects_ast) {
        var c = new Compilation(new StaticClassInfo(classes_ast));

        c.classInfo.objectGraph = simplifyObjectGraph(c.classInfo, objects_ast);

        // Bind phase.
        smalltalk.bindNames(c.classInfo, classes_ast);

        // Compile all the classes.
        var classdefs = Object.create(null);
        for (var name in classes_ast) {
            classdefs[name] = {superclassName: classes_ast[name].superclassName,
                               code: c.translateClass(classes_ast[name]),
                               mark: false};
        }

        // Sort the classes so that each class's superclass is defined
        // first.
        var classdef_code = [];
        function write(name) {
            var cd = classdefs[name];
            if (!cd)
                throw new Error("No such class '" + name + "'");
            if (!cd.mark) {
                if (cd.superclassName)
                    write(cd.superclassName);
                classdef_code.push(cd.code);
                cd.mark = true;
            }
        }
        for (var name in classdefs)
            write(name);

        // Compile the object graph and pool dictionaries.
        var classinit_code = c.translateObjectGraph();
        var pd_code = c.translatePoolDictionaries();

        return c.wrapOutput(classdef_code.join("") +
                            "\n" +
                            classinit_code +
                            pd_code);
    }

    function compileMethodLive(runtime, ast) {
        var comp = new Compilation(new RuntimeClassInfo(runtime));
        smalltalk.bindNamesInMethod(comp.classInfo, "UndefinedObject", ast);
        var code = comp.translateMethod("UndefinedObject", {method: ast}, true);
        assert(/^'': function/.test(code));
        code = comp.wrapOutput("    var $code = {" + code + "};\n" +
                               "    return $code[''];\n");
        var geval = eval;
        var fn = geval(code);
        return fn(runtime).bind(runtime.nil);
    }

    smalltalk.compileImage = compileImage;
    smalltalk.compileMethodLive = compileMethodLive;
})();
