// Current bug: self doesn't work in cascade expressions.

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

    // Compilation is a whole-program operation.
    // We common up constants across the whole program, and
    // optimizations are planned that would be unsound if we didn't see
    // the whole program.
    function Compilation(classes) {
        // Classes is provided by the runtime, initially populated with
        // a few core classes and some primitive methods.
        this.classes = classes;

        // Constants
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
        this.unknownNames = [];

        // Per-class state
        this.currentClass = null;
    }

    
    var subclassKindToFlags = {
        "subclass": 0,
        "variableSubclass": 1,
        "weakSubclass": 2,
        "variableWordSubclass": 3,
        "variableByteSubclass": 4
    };

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

            function translateStmt(n, indent) {
                switch (n.type) {
                case "Nil":
                case "True":
                case "False":
                case "Self":
                case "ThisContext":
                case "Local":
                case "Identifier":
                case "Character":
                case "String":
                case "Symbol":
                case "Float":
                case "Integer":
                case "ConstantArray":
                case "Block":
                    console.warn("useless expression in " + className + "#" + selector);
                    return "";

                case "ArrayExpr":
                    console.warn("unused array expression in " + className + "#" + selector);
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
                    if (target === "ifTrue:" && msg.args[0].type === "Block") {
                        return indent + "if (" +
                            translateExpr(n.receiver, POSTFIX_PREC, indent + "    ") +
                            " === " + comp.true_ + ") {\n" +
                            translateBlockBodyInlineAsStmts(msg.args[0].body, indent + "    ") +
                            indent + "}\n";
                    } else if (msg.selector === "ifFalse:" && msg.args[0].type === "Block") {
                        return indent + "if (!(" +
                            translateExpr(n.receiver, POSTFIX_PREC, indent + "    ") +
                            " === " + comp.true_ + ")) {\n" +
                            translateBlockBodyInlineAsStmts(msg.args[0].body, indent + "    ") +
                            indent + "}\n";
                    } else if ((msg.selector === "ifTrue:ifFalse:" || msg.selector === "ifFalse:ifTrue:") &&
                               msg.args[0].type === "Block" && msg.args[1].type === "Block") {
                        var tf = msg.selector === "ifTrue:ifFalse:";
                        var ifTrueBlock = msg.args[tf ? 0 : 1];
                        var ifFalseBlock = msg.args[tf ? 1 : 0];
                        return indent + "if (" +
                            translateExpr(n.receiver, POSTFIX_PREC, indent + "    ") +
                            " === " + comp.true_ + ") {\n" +
                            translateBlockBodyInlineAsStmts(ifTrueBlock.body, indent + "    ") +
                            indent + "} else {\n" +
                            translateBlockBodyInlineAsStmts(ifFalseBlock.body, indent + "    ") +
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
                case "Nil": return comp.nil;
                case "True": return comp.true_;
                case "False": return comp.false_;
                case "Self": return thisObject();

                case "ThisContext":
                    return "__smalltalk.getThisContext()";

                case "Local":
                    return toJSName(n.id);

                case "Identifier":
                    for (var cls = comp.currentClass; cls; cls = comp.classes[cls.superclassName]) {
                        // Is this really the right order?
                        if (cls.instanceVariableNames.indexOf(n.id) !== -1)
                            return thisObject() + "._" + n.id;
                        else if (cls.classVariableNames.indexOf(n.id) !== -1)
                            return "_" + cls.name + "._" + n.id;
                    }
                    if (n.id in comp.classes)
                        return "_" + n.id;
                    if (comp.unknownNames.indexOf(n.id) === -1) {
                        comp.unknownNames.push(n.id);
                        console.warn("unknown name: " + n.id);
                    }
                    return "__smalltalk.getGlobal(" + comp.getSymbol(n.id) + ")";

                case "Primitive":
                    throw new Error("Unexpected <primitive:> in expression");

                case "Character": return comp.getCharacter(n.value);
                case "String":    return comp.getString(n.value);
                case "Symbol":    return comp.getSymbol(n.value);
                case "Float":     return comp.getFloat(n.value);
                case "Integer":   return comp.getInteger(n.value);

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
                            return translateExpr(n, prec, indent + "    ");
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
                            return "_" + comp.currentClass.superclassName +
                                   (isInstanceMethod ? ".__im" : "") +
                                   messageJSName(msg) + ".call(" + args + ")";
                        }

                        var target = msg.selector;
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
                        } else {
                            return translateExpr(rcv, POSTFIX_PREC, indent2) + translateMessage(msg, indent2);
                        }
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
                        if (/^__smalltalk.getGlobal/.test(lhs))
                            return "__smalltalk.setGlobal(" + comp.getSymbol(n.left.id) + ", " + rhs + ")";
                        else if (prec <= ASSIGN_PREC)
                            return lhs + " = " + rhs;
                        else
                            return "(" + lhs + " = " + rhs + ")";
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
            this.currentClass = cls;
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
        }

    };


    function translate(classes) {
/*
        // === Optimized methods

        var optimizedMethods = [
            ["ifTrue:", "True False", function (n, indent) {
                if (n.args[0].type === "Block")
                return "($b(" + translateExpr(n.receiver, POSTFIX_PREC, indent) +
                       ") ? " + translateExpr(n.args[0], ASSIGN_PREC, indent2) +
                       " : " + nil + ")";
            }],
            ["ifFalse:", "True False", function (n, indent) {
                return "($b(" + translateExpr(n.receiver, POSTFIX_PREC, indent) +
                       ") ? " + nil +
                       " : " + translateExpr(n.args[0], ASSIGN_PREC, indent2) + ")";
            }],
            ["ifTrue:ifFalse:", "True False", function (n, indent) {
                return "($b(" + translateExpr(n.receiver, POSTFIX_PREC, indent) +
                       ") ? " + translateExpr(n.args[0], ASSIGN_PREC, indent2) +
                       " : " + translateExpr(n.args[1], ASSIGN_PREC, indent2) + ")";
            }],
            ["ifFalse:ifTrue:", "True False", function (n, indent) {
                return "($b(" + translateExpr(n.receiver, POSTFIX_PREC, indent) +
                       ") ? " + translateExpr(n.args[1], ASSIGN_PREC, indent2) +
                       " : " + translateExpr(n.args[0], ASSIGN_PREC, indent2) + ")";
            }]
        ];

*/

        var c = new Compilation(classes);

        var classdefs = Object.create(null);
        for (var name in classes) {
            classdefs[name] = {superclassName: classes[name].superclassName,
                               code: c.translateClass(classes[name]),
                               mark: false};
        }

        // Sort the classes so that each class's superclass is defined
        // first.
        var classdef_code = [];
        var classinit_code = [];
        function write(name) {
            var cd = classdefs[name];
            if (!cd)
                throw new Error("No such class '" + name + "'");
            if (!cd.mark) {
                if (cd.superclassName)
                    write(cd.superclassName);
                classdef_code.push(cd.code);
                if ("initialize" in classes[name].classMethods)
                    classinit_code.push("    print('initializing " + name + "...'); _" + name + ".initialize();\n");
                cd.mark = true;
            }
        }
        function writeClasses(arr) {
            for (var i = 0; i < arr.length; i++) {
                var name = arr[i];
                if (name in classdefs)
                    write(name);
            }
        }
        writeClasses(['Object', 'Float', 'Character', 'String', 'Symbol']);
        classinit_code.push("\n    __smalltalk.init();\n\n");
        writeClasses([
            'Color',
            'AbstractSound',
            'SoundPlayer', // SoundMedia depends on this
            'SampledSound' // SoundMedia depends on this
        ]);
        for (var name in classdefs)
            write(name);

        return ("(function (__smalltalk) {\n" +
                "    var $B = __smalltalk.Block;\n" +
                (c.constantDecls.length === 0 ? "" : "    var\n" + c.constantDecls.join(",\n") + ";\n") +
                classdef_code.join("") +
                classinit_code.join("") +
                "});\n");
    }

    smalltalk.translate = translate;
})();
