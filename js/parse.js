// JavaScript names (all of these are local to the functionball):
//   _k24 - (and other integers) Constants.
//   __smalltalk, $B - Runtime support.
//   _SmallInteger - Class objects. These always match /^_[A-Z][A-Za-z0-9]*$/.
//   abc - Local variables and arguments always match /^[A-Za-z][A-Za-z0-9]*$/.
//   this_ - Local variables and arguments whose names happen to be JS keywords
//          (or 'arguments' or 'eval') are given a trailing underscore.  This
//          can't collide with anything since Smalltalk identifiers can't
//          contain underscores.
//   $a - A special name used by compiler-generated code to implement
//          return-from-block.
//   $$k - Variables used in primitives. Since primitives are just pasted into
//          the compiled code, they need to use variable names that won't
//          collide with anything else.  These always match
//          /^\$\$[A-Za-z0-9]+$/.
//
// Names of prototype object properties:
//   .banana() - The method "banana", which takes no arguments.
//   .name_(s) - The method "name:", which takes 1 argument.
//   ["+"](x) - The method "+". All such methods take 1 argument.
//   .at_put_(idx, val) - The method "at:put:", which takes 2 arguments.
//
// Object and class instance variables have names starting with an underscore.
// They are only used in contexts where we know the access will succeed.
//
// Classes have a top-secret property __im, which holds all the instance
// methods.  Objects inherit from that. Classes in turn inherit all their
// methods from the metaclass's __im object.  Each __im object has a __class
// property pointing back to the class; these are exactly like .prototype and
// .constructor.
//
// Behavior.__im.basicNew = function () {
//     var obj = Object.create(this.__im);
//     var iv = this.__iv;
//     for (var i = 0; i < iv.length; i++)
//         Object.defineProperty(obj, iv[i], {configurable: true, enumerable: true, writable: true, value: _nil});
//     return obj;
// };


// corners:
//     make a model of the class tree
//     track instance variables and locals when reading, scoping is so simple
//     thisContext needs to be implemented
//     #(-1 -2 -3) size ===> 3, but #(- 1 - 2 - 3) size ===> 6

// but seriously:
//     need to implement serious compilation
//     type inference (since the whole system really is, probably, static)

// Bug: should reject `3 ; +2`.
// tokenizer bug: `# x` with a space must evaluate to #x, as does `# "comment x`
// todo: evaluate numbers in the parser
// todo: "currentMethod" variable in translate
// todo: sane-ify selector name handling

//
// 2 + 2 factorial; + 2  ===> Cascade(2, [+ 2 factorial, + 2]) = 4
//                        not 2 + Cascade(2, [factorial, + 2]) = 6
//
// 6 gcd: 3 + 1; factorial ===> Cascade(6, [gcd: 3 + 1, factorial]) = 720
//                          not 6 gcd: Cascade(3, [+ 1, factorial]) = 6

var smalltalk;

(function () {
    "use strict";

    function assert(b, msg) { if (!b) throw new Error("assertion failed: " + msg); }

    // This parser first splits the whole body of a method into tokens, then
    // turns the tokens into an AST in a separate pass. But it seems very
    // unlikely now that Squeak actually tokenizes code like this (i.e. without
    // feedback from the parser). For example,
    //     #:a: ===> #':a:'
    //     # :a: ===> #':a:'
    //     #: asString ===> ':'
    //     #(:a:) ===> (#: #a:)
    // just seems impossible without using a different tokenization algorithm
    // either inside constant lists or after #.

    // pseudo ::= nil | true | false | self | super | thisContext
    // identifier ::= /:?[A-Za-z](?:[0-9A-Za-z]|:[A-Za-z])*:?/
    // comment ::= /"(?:[^"]|"")*"/
    // string ::= /'(?:[^']|'')*'/
    // number ::= /[0-9][0-9A-Zre.]*/
    //    --less buggy: [0-9]+r?[0-9A-Z]*(?:\.[0-9A-Z]+)?(?:e[+-]?[0-9]+)?
    //    --refining: (?:([0-9]*)r)?([0-9A-Z]*(?:\.[0-9A-Z]+)?(?:e([+-]?[0-9]+))
    // character ::= /\$(?:.|\r|\n)/
    // literal ::= number | character | string | symbol
    // operator ::= /[-+`\\/*\\\\~<=>@%|&?!,]+/    (at a guess)
    // punctuation ::= ":=" | /[_\[\]{}.:|#]/
    // paren ::=  "(" | ")"
    // token ::= pseudo | identifier | comment | literal | operator | punctuation | paren

    var token_re = new RegExp(
        "\\s*(" +
            '"(?:[^"]|"")*"|' +  // comment
            "#[ \\r\\n\\t]*:?[A-Za-z](?:[0-9A-Za-z]|:[A-Za-z])*:?|" +  // symbol
            "[A-Za-z][0-9A-Za-z]*:?|" + // identifier
            "[0-9]+r?[0-9A-Z]*(?:\\.[0-9A-Z]+)?(?:e[+-]?[0-9]+)?|" + // number literal
            "\\$(?:.|\\n|\\r)|" + // character literal
            "(?:#[ \\r\\n\\t]*)?'(?:[^']|'')*'|" + // string literal or symbol
            ":=|" + // special assignment token
            "[-+`\\/*\\\\~<=>@%|&?!,]+|" + // operator
            "$|" + // end of input
            "." + // any other single character, particularly _ ( ) [ ] { } . : #
        ")", 'gm');

    function tokenize(s) {
        var i = 0, a = [];
        token_re.lastIndex = 0;
        while (true) {
            var point = token_re.lastIndex;
            var match = token_re.exec(s);
            if (match === null || match.index !== point) {
                var lines = s.split(/\r\n?|\n/g);
                var lineno = 0, gas = point;
                while (gas > lines[lineno].length + 1) {
                    gas -= lines[lineno].length + 1;
                    lineno++;
                }
                var line = lines[lineno].substring(gas);
                throw new Error("Syntax error at line " + (lineno + 1) + ", column " + gas + ": " + uneval(line));
            }
            match = match[1];
            if (match.length === 0)
                break;

            if (match[0] !== '"')
                a[i++] = match;
        }
        return a;
    }

    function parse(s, mode) {
        // === basics

        function check(b, msg) {
            if (!b)
                fail(msg);
        }

        function fail(msg) {
            throw new Error(msg + " near `" + tokens.slice(p - 10, p + 10).join(" ") + "`");
        }

        function require(token, msg) {
            if (tokens[p] !== token)
                fail("expected '" + token + "', not '" + tokens[p] + "'" + (msg ? " " + msg : ""));
            p++;
        }


        // === Model

        var _nil = {type: "Nil"};
        function Nil() { return _nil; }
        var _true = {type: "True"};
        function True() { return _true; }
        var _false = {type: "False"};
        function False() { return _false; }
        var _self = {type: "Self"};
        function Self() { return _self; }
        var _super = {type: "Super"};
        function Super() { return _super; }
        var _thisContext = {type: "ThisContext"};
        function ThisContext() { return _thisContext; }
        function Local(id) { return {type: "Local", id: id}; }
        function Identifier(id) { return {type: "Identifier", id: id}; }
        function Message(selector, args) { return {type: "Message", selector: selector, args: args}; }
        function MessageExpr(rec, msg) { return {type: "MessageExpr", receiver: rec, message: msg}; }
        function Character(c) { return {type: "Character", value: c}; }
        function String(v) { return {type: "String", value: v}; }
        function Symbol(v) { return {type: "Symbol", value: v}; }
        function Integer(v) { return {type: "Integer", value: v}; }
        function LargeInteger(v) { return {type: "LargeInteger", value: v}; }
        function Float(v) { return {type: "Float", value: v}; }
        function ConstantArray(arr) { return {type: "ConstantArray", elements: arr}; }
        function ArrayExpr(arr) { return {type: "ArrayExpr", elements: arr}; }
        function CascadeExpr(head, msgs) {
            return {type: "CascadeExpr", head: head, messages: msgs};
        }
        function AssignExpr(left, right) { return {type: "AssignExpr", left: left, right: right}; }
        function Primitive(primitive, module) { return {type: "Primitive", primitive: primitive, module: module}; }
        function AnswerExpr(e) { return {type: "AnswerExpr", expr: e}; }
        function Block(params, locals, body) {
            return {type: "Block", params: params, locals: locals, body: body};
        }
        function ExprSeq(seq) { return {type: "ExprSeq", seq: seq}; }
        function MethodDefinition(selector, args, locals, body) {
            return {type: "MethodDefinition", selector: selector, args: args, locals: locals, body: body};
        }


        // === Lexical scope state

        var scopes = [];

        function withScope(names, fn) {
            scopes.push(names);
            try {
                return fn.apply(undefined, Array.prototype.slice.call(arguments, 2));
            } finally {
                scopes.pop(names);
            }
        }

        function haveLocal(id) {
            for (var i = scopes.length; i--;) {
                if (scopes[i].indexOf(id) !== -1)
                    return true;
            }
            return false;
        }


        // === Expression parsers

        function isId(t) { return t && /^[A-Za-z][0-9A-Za-z]*$/.test(t); }

        function isOperator(t) { return t && !!t.match(/^[-+`\/*\\~<=>@%|&?!,]+$/); }
        function isPunctuation(t) { return t && !!t.match(/[_\[\]{}.:]/); }
        function isKeyword(t) { return t && !!t.match(/^[A-Za-z][0-9A-Za-z]*:$/); }

        function idExpr(t) {
            switch (t) {
            case "nil":         return Nil();
            case "true":        return True();
            case "false":       return False();
            case "self":        return Self();
            case "super":       return Super();
            case "thisContext": return ThisContext();
            default:
                if (haveLocal(t))
                    return Local(t);
                else
                    return Identifier(t);
            }
        }

        var BigInt = {
            str2bigInt: str2bigInt,
            bigInt2str: bigInt2str,
            int2bigInt: int2bigInt,
            mult: mult
        };

        function number(s) {
            var m = /(-)?([0-9]+)(r[0-9A-Z]+)?(\.[0-9A-Z]+)?(?:e([+-]?[0-9]+))?/.exec(s);
            var sign = m[1] || '';

            check(m !== null, "wack number literal " + s);
            if (m[4] !== undefined || (m[5] !== undefined && Number(m[5]) < 0)) {
                // Decimal point or scientific notation with negative exponent.
                check(m[3] === undefined, "not supported: decimal points or scientific notation in non-decimal number literals " + s);
                return Float(+s);
            }

            // If we get here, s is an integer constant. Extract the base and digits.
            var base, digits;
            if (m[3] === undefined) {
                base = 10;
                digits = m[2];
            } else {
                base = parseInt(m[2].replace(/^0*/, ''));
                digits = m[3].substring(1);
            }

            // Check all the digits in the string.
            for (var i = 0; i < digits.length; i++) {
                var c = digits.charCodeAt(i);
                var v = c < 58 ? c - 48 : c - 55;
                check(v < base, "digit " + c + " is out of range for base " + base + " in number literal " + s);
            }

            // Parse the digits as a BigInt.
            var intval = BigInt.str2bigInt(digits, base, 0);

            if (m[5] !== undefined) {
                // No decimal point, but scientific notation with positive exponent.
                var exp = Number(m[5]);
                var baseAsBigInt = BigInt.int2bigInt(base, 0, 0);
                for (var i = 0; i < exp; i++)
                    intval = BigInt.mult(intval, baseAsBigInt);
            }

            // Convert to hex. (This is pretty silly in the common case that
            // it's a decimal constant with no exponent that fits in a
            // SmallInteger, but it's correct.)
            var hex = BigInt.bigInt2str(intval, 16);

            var n = parseInt(hex, 16);
            if (sign)
                n = -n;
            if ((0xc0000000|0) < n && n <= 0x3fffffff)
                return Integer(n);
            else
                return LargeInteger(sign + hex);
        }


        function parseString(token) {
            assert(token.length >= 2);
            assert(token[0] === "'");
            assert(token[token.length - 1] === "'");
            return token.substring(1, token.length - 1).replace(/''/g, "'");
        }

        function stripOctothorpe(t) {
            var match = /^#[ \n\r\t]*/.exec(t);
            return match === null ? t : t.substring(match[0].length);
        }

        // constantToken :: = pseudo | identifier | literal | operator | punctuation
        // constant ::= constantToken | constantArray | "(" constant* ")"
        function constant() {
            var t = tokens[p];

            while (t === "#")
                t = tokens[++p];
            t = stripOctothorpe(t);

            if (t === '(') {
                return constantArray();
            } else if (t[0] === "$") {
                p++;
                return Character(t[1]);
            } else if (t[0] === "'") {
                p++;
                return String(parseString(t));
            } else if (t.match(/^[A-Za-z]/)) {
                p++;
                return Symbol(t);
            } else if (t.match(/^-?[0-9]/)) {
                p++;
                return number(t);
            } else if (isOperator(t) || isPunctuation(t)) {
                p++;
                return Symbol(t);
            } else {
                fail("expected constant expression, got: " + t);
            }
        }

        // constantArray ::= "#" "(" constant* ")"
        function constantArray() {
            require("(");
            var arr = [];
            while (tokens[p] !== ")") {
                check(p < tokens.length, "unexpected end of input in constant array");
                arr[arr.length] = constant();
            }
            require(")");
            return ConstantArray(arr);
        }

        // arrayExpr ::= "{" (expr ".")* expr "."? "}"
        function arrayExpr() {
            var arr = [];
            require("{");
            while (tokens[p] !== "}") {
                check(p < tokens.length, "unexpected end of input in array expression");
                arr[arr.length] = expr();
                if (tokens[p] !== "}")
                    require(".");
            }
            require("}");
            return ArrayExpr(arr);
        }

        // symbol ::= "#" (string | identifier | operator | punctuation)
        // literal ::= number | "-" number | character | string | symbol
        // atomExpr ::= literal | identifier | constantArray | arrayExpr | block | "(" expr ")"
        function atomExpr() {
            var x;
            var t = tokens[p];
            if (t === "(") {
                p++;
                x = expr();
                require(")");
                return x;
            } else if (t === "[") {
                return block();
            } else if (t === "{") {
                return arrayExpr();
            } else if (t[0] === "$") {
                p++;
                return Character(t[1]);
            } else if (t[0] === "'") {
                p++;
                return String(parseString(t));
            } else if (t.charAt(0) === "#") {
                while (t === "#")
                    t = tokens[++p];
                if (t.charAt(0) === "#")
                    t = stripOctothorpe(t);
                if (t === "(") {
                    return constantArray();
                } else if (t.match(/^[A-Za-z]/) || isOperator(t) || isPunctuation(t) || t === ")") {
                    p++;
                    return Symbol(t);
                } else if (t[0] === "'") {
                    p++;
                    return Symbol(parseString(t));
                } else {
                    fail("expected identifier, string, operator, or ( after #; got: " + t);
                }
            } else if (isId(t)) {
                p++;
                return idExpr(t);
            } else if (t.match(/^[0-9]/)) {
                p++;
                return number(t);
            } else if (t === "-") {
                p++;
                t = tokens[p];
                check(t.match(/^[0-9]/), "expected expression, got: -" + t);
                p++;
                return number("-" + t);
            } else {
                fail("expected expression, got: " + t);
            }
        }

        // unaryExpr ::= atomExpr | atomExpr identifier
        function unaryExpr() {
            var b = atomExpr();
            while (isId(tokens[p]))
                b = MessageExpr(b, message());
            return b;
        }

        // binaryExpr ::= unaryExpr | binaryExpr operator unaryExpr
        function binaryExpr() {
            var b = unaryExpr();
            while (isOperator(tokens[p]))
                b = MessageExpr(b, message());
            return b;
        }

        // keywordExpr ::= binaryExpr (keyword binaryExpr)*
        function keywordExpr() {
            var b = binaryExpr();
            if (isKeyword(tokens[p]))
                b = MessageExpr(b, message());
            return b;
        }    

        function isPseudo(t) {
            return !!t.match(/^(?:nil|true|false|self|super|thisContext)$/);
        }

        // message ::= identifier | operator unaryExpr | (keyword binaryExpr)+
        function message() {
            var t = tokens[p];
            if (isOperator(t)) {
                p++;
                return Message(t, [unaryExpr()]);
            } else if (isId(t)) {
                p++;
                return Message(t, []);
            } else if (isKeyword(t)) {
                var selector = '';
                var args = [];
                while (isKeyword(tokens[p])) {
                    selector += tokens[p++];
                    args[args.length] = binaryExpr();
                }
                return Message(selector, args);
            } else {
                fail("expected message after ';', got: " + t);
            }
        }

        // cascadeExpr ::= keywordExpr (";" message)*
        function cascadeExpr() {
            var e = keywordExpr();
            if (tokens[p] === ";") {
                var arr = [];
                while (tokens[p] === ";") {
                    p++;
                    arr[arr.length] = message();
                }
                e = CascadeExpr(e, arr);
            }
            return e;
        }

        // assignExpr ::= cascadeExpr | identifier := cascadeExpr
        // expr ::= assignExpr
        function expr() {
            if (p + 1 < tokens.length) {
                var a = tokens[p];
                var b = tokens[p + 1];
                if (isId(a) && (b === ":=" || b === "_")) {
                    check(!isPseudo(a), "cannot assign to " + a);
                    var left = atomExpr();
                    assert(left.type === "Local" || left.type === "Identifier", "unexpected name on lhs of assignment");
                    assert(tokens[p] === b ,"unexpected parse of lhs of assignment");
                    p++;
                    return AssignExpr(left, expr());
                }
            }
            return cascadeExpr();
        }

        // locals ::= "|" identifier+ "|"
        function locals() {
            var arr = [];
            if (tokens[p] === "|") {
                require("|");
                while (isId(tokens[p])) {
                    var id = tokens[p++];
                    check(!isPseudo(id), "variable name already used: " + id);
                    check(!haveLocal(id), "variable name already used in this method: " + id);
                    arr[arr.length] = id;
                }
                require("|");
            }
            return arr;
        }

        // exprSeq ::= (expr .)* ("^"? expr .?)?
        function exprSeq(delim) {
            var arr = [];

            if (delim === undefined && p + 1 < tokens.length && tokens[p] === "<" && tokens[p + 1] === "primitive:") {
                // Two forms are allowed: <primitive: 123> and <primitive: 'name' module: 'name'>.
                p += 2;
                check(p + 2 <= tokens.length, "unexpected end of source in <primitive:>");

                var primitive;
                if (tokens[p].match(/^[0-9]/)) {
                    primitive = parseInt(tokens[p++]);
                } else {
                    check(tokens[p][0] === "'");
                    primitive = parseString(tokens[p++]);
                }

                var module;
                if (tokens[p] === "module:") {
                    p++;
                    check(tokens[p][0] === "'");
                    module = parseString(tokens[p++]);
                } else {
                    module = null;
                }
                require(">");
                arr[0] = Primitive(primitive, module);
            }

            while (p < tokens.length && tokens[p] !== "^" && tokens[p] !== delim) {
                if (tokens[p] === ".") {
                    // empty expression (probably actually a comment)
                    p++;
                } else {
                    arr[arr.length] = expr();
                    if (tokens[p] === ".")
                        p++;
                    else
                        break;
                }
            }

            if (p < tokens.length && tokens[p] === "^") {
                p++;
                arr[arr.length] = AnswerExpr(expr());
                if (tokens[p] === ".")
                    p++;
            }

            return ExprSeq(arr);
        }

        // params ::= (":" identifier)+ "|"
        // block ::= [ params? locals? exprSeq ]
        function block() {
            require("[");
            var params = [], loc, body;
            while (tokens[p] === ":") {
                p++;
                var id = tokens[p++];
                check(isId(id), 'expected identifier after ":" for block parameter name');
                check(!isPseudo(id), "variable name already used: " + id);
                params[params.length] = id;
            }

            var loc, body;
            if (tokens[p] === "]") {
                loc = [];
                body = ExprSeq([]);
            } else {
                if (params.length)
                    require("|");
                loc = locals();
                body = withScope(params.concat(loc), exprSeq, "]");
            }
            require("]");
            return Block(params, loc, body);
        }

        function messageSignature() {
            var t = tokens[p];
            var selector, args = [];
            if (isId(t)) {
                check(!isPseudo(t), "illegal name for message: " + t);
                p++;
                selector = t;
            } else if (isOperator(t)) {
                p++;
                var rhs = tokens[p];
                check(isId(rhs), "expected identifier after operator, got: " + rhs);
                check(!isPseudo(rhs), "illegal name for operand: " + rhs);
                p++;
                selector = t;
                args[0] = rhs;
            } else if (isKeyword(t)) {
                selector = '';
                while (isKeyword(tokens[p])) {
                    selector += tokens[p++];
                    var v = tokens[p];
                    check(isId(v), "expected identifier after keyword '" + tokens[p - 1] + "', got: " + v);
                    check(!isPseudo(v), "illegal argument name after keyword '" + tokens[p - 1] + "': " + v);
                    p++;
                    args[args.length] = v;
                }
            } else {
                fail("expected message definition, got: " + t);
            }
            return [selector, args];
        }

        // methodDefinition ::= message locals? exprSeq
        function methodDefinition() {
            var pair = messageSignature();
            var selector = pair[0];
            var args = pair[1];
            var loc = locals();
            var body = withScope(args.concat(loc), exprSeq, undefined);
            return MethodDefinition(selector, args, loc, body);
        }

        function methodNoArgs() {
            var loc = locals();
            var body = withScope(loc, exprSeq, undefined);
            return MethodDefinition(null, [], loc, body);
        }

        // SqueakSource ::= string ! SqueakSourceElement*
        // SqueakSourceElement ::= directive | classComment |  method | comment "!"
        // directive ::= expr "!"
        // classComment ::= "!" identifier "commentStamp:" string "prior:" number "!" <<raw text>> "!"
        // method ::= "!" identifier "class"? "methodsFor:" string ("stamp:" string)? "!" methodDefinition "!" "!"

        var allowedParsers = {
            method: methodDefinition,
            expr: expr,
            methodNoArgs: methodNoArgs
        };
        assert(allowedParsers.hasOwnProperty(mode));
        var selectedParser = allowedParsers[mode];

        var tokens = tokenize(s);
        var p = 0;
        return selectedParser();
    }


    var cr = "(?:\\r\\n?|\\n)";
    var directive_re = [
        "(?:",
        "('(?:[^!]|!!)*!" + cr + ")", // first line of file
        "|([A-Za-z][A-Za-z0-9]* (?:subclass: |(?:variable(?:|Byte|Word)|weak)Subclass: |class\\b)(?:[^!]|!!)*)!" + cr,
        "|!([A-Za-z][A-Za-z0-9]* commentStamp: (?:[^!]|!!)*)!" + cr +
            "(?:[^!]|!!)*!" + cr +
            "(?:\\]style\\[(?:[^!]|!!)*!" + cr +
            ")?" + cr +
            "(?:\\r\\n?|\\n|$)",
        "|" + cr +
            "?!([A-Za-z][A-Za-z0-9]* (?:class )?methodsFor: (?:[^!]|!!)*)!" + cr +
            "((?:[^!]|!!)*)(?:!" + cr +
            "\\]style\\[(?:[^!]|!!)*)?! !" + cr,
        '|"[- ]+"!' + cr + cr, // big long line of dashes before class
        "|" + cr + "", // random newlines appear between classes
        "|\x0c", // form feed, good grief
        "|([A-Za-z](?:[^!]|!!)*)!", // any expression
        ")"].join("");

    function variableNames(s) {
        var names = s.trimRight().split(/ /g);
        if (names[names.length - 1] === "")
            names.pop();
        return names;
    }

    function parseSqueakSource(s) {
        var point;
        function check(b, msg) {
            if (!b)
                throw new Error(msg + " at line " + lineno());
        }

        function lineno(i) {
            if (i === undefined)
                i = point;
            return s.substring(0, i).split(/\r\n?|\n/g).length;
        }

        var subclass_re = /^(subclass|(?:variable(?:Word|Byte|)|weak)Subclass):instanceVariableNames:classVariableNames:poolDictionaries:category:$/;

        var classes = Object.create(null);

        var i = 0, a = [];
        var re = new RegExp(directive_re, "g");
        while (re.lastIndex < s.length) {
            point = re.lastIndex;
            var m = re.exec(s);
            check(m !== null && m.index === point, "unrecognized source element");
            if (m[1] !== undefined) {
                // Comment on first line, do nothing
            } else if (m[2] !== undefined) {
                var expr = parse(m[2].replace(/!!/g, '!'), 'expr');
                check(expr.type === "MessageExpr", "0");
                if (expr.message.selector === "instanceVariableNames:") {
                    // `Monster class instanceVariableNames: 'blah '`
                    check(expr.receiver.type === "MessageExpr", "1");
                    check(expr.receiver.receiver.type === "Identifier", "2");
                    check(expr.receiver.message.selector === "class", "3");
                    var className = expr.receiver.receiver.id;
                    check(className in classes, "class not found: " + className);
                    var cls = classes[className];
                    check(expr.message.args[0].type === "String", "4");
                    var ivn = expr.message.args[0].value.split(" ");
                    if (ivn[ivn.length - 1] === "")
                        ivn.pop();
                    cls.weirdness.push({instanceVariableNames: ivn});
                } else {
                    // Class definition.
                    m = subclass_re.exec(expr.message.selector);
                    check(m, "unrecognized expression");
                    var superclassName =
                        expr.receiver.type === "Nil" ? null : expr.receiver.id;
                    var subclassKind = m[1];
                    var args = expr.message.args;
                    check(args[0].type === "Symbol", "5");
                    var name = args[0].value;
                    check(args[1].type === "String", "6");
                    var ivn = variableNames(args[1].value);
                    check(args[2].type === "String", "7");
                    var cvn = variableNames(args[2].value);
                    check(args[3].type === "String", "8");
                    var pd = args[3].value;
                    check(args[4].type === "String" ,"9");
                    var cat = args[4].value;
                    var cls = ClassDef(subclassKind, name, superclassName, ivn, cvn, pd, cat);
                    classes[name] = cls;
                }
            } else if (m[3] !== undefined) {
                // Class comment, skip it
            } else if (m[4] !== undefined) {
                // Method definition.
                var x = parse(m[4].replace(/!!/g, '!'), 'expr');
                check(x.type === "MessageExpr", "10");
                var className, kind;
                if (x.receiver.type === "Identifier") {
                    className = x.receiver.id;
                    kind = 'methods';
                } else {
                    check(x.receiver.type === "MessageExpr", "11");
                    check(x.receiver.receiver.type === "Identifier", "12");
                    check(x.receiver.message.selector === "class", "13");
                    className = x.receiver.receiver.id;
                    kind = 'classMethods';
                }
                check(x.message.selector === "methodsFor:" ||
                      x.message.selector === "methodsFor:stamp:", "14");
                check(x.message.args[0].type === "String", "15");
                check(className in classes, "method has unrecognized class name");
                var methodGroup = x.message.args[0].value;
                var cls = classes[className];
                var def = parse(m[5].replace(/!!/g, '!'), "method");
                if (def.selector in cls[kind]) {
                    console.warn("Method defined more than once: " +
                                 cls.name + (kind === 'classMethods' ? " class" : "") + "#" +
                                 def.selector);
                }
                cls[kind][def.selector] = {type: "Method",
                                           loc: point,
                                           methodGroup: methodGroup,
                                           method: def};
            } else if (m[6] !== undefined) {
                // mysterious!
                if (m[6].match(/^(?:TextConstants|ZipConstants) at: /)) {
                    // this seems to be unparseable nonsense
                    // do nothing
                } else {
                    parse(m[6].replace(/!!/g, '!'), "expr");
                }
            } else {
                // long row of dashes or blank line, ignore
            }
        }

        function ClassDef(subclassKind, name, superclassName, ivn, cvn, pd, cat) {
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
        }
        return classes;
    }

    function parseExpr(s) {
        return parse(s, "expr");
    }

    function parseMethod(s) {
        return parse(s, "method");
    }

    function parseMethodNoArgs(s) {
        return parse(s, "methodNoArgs");
    }

    // Return an object G such that G[s1][s2] is true if there is a
    // method with selector s1 which sends a message with selector s2
    // to anything.
    //
    function callGraph(classes) {
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

        var classNames = Object.keys(classes);
        for (var i = 0; i < classNames.length; i++) {
            var cls = classes[classNames[i]];
            process(cls.methods, cls.name);
            process(cls.classMethods, cls.name + " class");
        }
        return messages;
    }

    var characters = [];

    smalltalk = {
        tokenize: tokenize,
        parseSqueakSource: parseSqueakSource,
        parseMethod: parseMethod,
        parseExpr: parseExpr,
        parseMethodNoArgs: parseMethodNoArgs,
        callGraph: callGraph,
        characters: characters
    };
})();
