var smalltalk;

(function () {
    "use strict";

    function assert(b, msg) { if (!b) throw new Error("assertion failed: " + msg); }

    // Singleton AST nodes.
    var _nil = {type: "Nil"};
    var _true = {type: "True"};
    var _false = {type: "False"};
    var _self = {type: "Self"};
    var _super = {type: "Super"};
    var _thisContext = {type: "ThisContext"};

    // Depth-first deep map for AST nodes.
    //
    // First make a copy of node, in which each immediate subexpression x is
    // replaced with transform(fn, x). Then return fn(the copy).
    //
    function transform(fn, node) {
        var copy = {}, differ = false;
        for (var p in node) {
            var v = node[p];
            if (typeof v === "object" && v !== null) {
                if (Array.isArray(v)) {
                    var img = [], arr_differ = false;
                    for (var i = 0; i < v.length; i++) {
                        var e = v[i], e_ = transform(fn, e);
                        img[i] = e_;
                        arr_differ = arr_differ || e_ !== e;
                    }
                    if (arr_differ) {
                        differ = true;
                        v = img;
                    }
                } else {
                    assert(typeof v.type === "string");
                    var v_img = transform(fn, v);
                    if (v_img !== v) {
                        differ = true;
                        v = v_img;
                    }
                }
            }
            copy[p] = v;
        }
        return fn(differ ? copy : node);
    }

    // Return an object G such that G[s1][s2] is true if there is a
    // method with selector s1 which sends a message with selector s2
    // to anything.
    //
    function callGraph(classes_ast) {
        var messages = Object.create(null);
        function addVertex(s) {
            if (s in messages)
                return messages[s];
            return (messages[s] = Object.create(null));
        }

        function addEdge(s1, s2) {
            addVertex(s1)[s2] = true;
        }

        function process(methods, className) {
            function visit(n) {
                switch (n.type) {
                case "MessageExpr":
                    visit(n.receiver);
                    visit(n.message);
                    break;

                case "Message":
                    addEdge(name, n.selector);
                    for (var i = 0; i < n.args.length; i++)
                        visit(n.args[i]);
                    if (n.selector === "add:action:") {
		        //console.log(name + " calls add:action: " + JSON.stringify(n.args[1]));
                        if (n.args[1].type === "Symbol") {
                            addEdge(name, n.args[1].value);
			    if (n.args[1].value === "aboutScratch")
			        console.log(name + " calls add:action: #" + n.args[1].value);
			}
                    }
                    break;

                case "ArrayExpr":
                    for (var i = 0; i < n.elements.length; i++)
                        visit(n.elements[i]);
                    break;

                case "Block":
                    visit(n.body);
                    break;

                case "CascadeExpr":
                    visit(n.head.receiver);
                    visit(n.head.message);
                    for (var i = 0; i < n.messages.length; i++)
                        visit(n.messages[i]);
                    break;

                case "AssignExpr":
                    visit(n.left);
                    visit(n.right);
                    break;

                case "AnswerExpr":
                    visit(n.expr);
                    break;

                case "ExprSeq":
                    for (var i = 0; i < n.seq.length; i++)
                        visit(n.seq[i]);
                    break;

                case "Primitive":
                    if (typeof n.primitive === 'string')
                        addEdge(name, n.primitive);
                    break;
                }
            }
            var names = Object.keys(methods);
            for (var i = 0; i < names.length; i++) {
                var name = names[i], m = methods[name];
                addVertex(name);
                visit(m.method.body);
                if (name === "computeFunction:of:")
                    console.log("computeFunction:of: calls " + uneval(Object.keys(messages[name])));
            }
        }

        var classNames = Object.keys(classes_ast);
        for (var i = 0; i < classNames.length; i++) {
            var cls = classes_ast[classNames[i]];
            process(cls.methods, cls.name);
            process(cls.classMethods, cls.name + " class");
        }
        return messages;
    }

    if (smalltalk === undefined)
        smalltalk = {};
    smalltalk.ast = {
        Nil: function Nil() { return _nil; },
        True: function True() { return _true; },
        False: function False() { return _false; },
        Self: function Self() { return _self; },
        Super: function Super() { return _super; },
        ThisContext: function ThisContext() { return _thisContext; },

        Character: function Character(c) { return {type: "Character", value: c}; },
        String: function String(v) { return {type: "String", value: v}; },
        Symbol: function Symbol(v) { return {type: "Symbol", value: v}; },
        Integer: function Integer(v) { return {type: "Integer", value: v}; },
        LargeInteger: function LargeInteger(v) { return {type: "LargeInteger", value: v}; },
        Float: function Float(v) { return {type: "Float", value: v}; },

        ConstantArray: function ConstantArray(arr) { return {type: "ConstantArray", elements: arr}; },
        ArrayExpr: function ArrayExpr(arr) { return {type: "ArrayExpr", elements: arr}; },

        Identifier: function Identifier(id) { return {type: "Identifier", id: id}; },
        Local: function Local(id) { return {type: "Local", id: id}; },
        InstVar: function InstVar(obj, id) { return {type: "InstVar", obj: obj, id: id}; },
        ClassVar: function ClassVar(className, id) { return {type: "ClassVar", className: className, id: id}; },
        PoolVar: function PoolVar(poolName, id) { return {type: "PoolVar", poolName: poolName, id: id}; },
        Global: function Global(id) { return {type: "Global", id: id}; },

        Message: function Message(selector, args) { return {type: "Message", selector: selector, args: args}; },
        MessageExpr: function MessageExpr(rec, msg) { return {type: "MessageExpr", receiver: rec, message: msg}; },
        CascadeExpr: function CascadeExpr(head, msgs) {
            return {type: "CascadeExpr", head: head, messages: msgs};
        },
        AssignExpr: function AssignExpr(left, right) { return {type: "AssignExpr", left: left, right: right}; },
        Primitive: function Primitive(primitive, module) { return {type: "Primitive", primitive: primitive, module: module}; },
        AnswerExpr: function AnswerExpr(e) { return {type: "AnswerExpr", expr: e}; },
        Block: function Block(params, locals, body) {
            return {type: "Block", params: params, locals: locals, body: body};
        },
        ExprSeq: function ExprSeq(seq) { return {type: "ExprSeq", seq: seq}; },

        MethodDefinition: function MethodDefinition(selector, args, locals, body) {
            return {type: "MethodDefinition", selector: selector, args: args, locals: locals, body: body};
        },
        ClassDef: function ClassDef(subclassKind, name, superclassName, ivn, cvn, pd, cat) {
            return {type: "ClassDef",
                    subclassKind: subclassKind,
                    name: name,
                    superclassName: superclassName,
                    instanceVariableNames: ivn,
                    classVariableNames: cvn,
                    poolDictionaries: pd,
                    category: cat,
                    methods: Object.create(null),
                    classMethods: Object.create(null),
                    weirdness: []};
        },

        callGraph: callGraph,
        transform: transform
    };
})();
