load("../BigInt.js");
load("../parse.js");

(function () {
    "use strict";

    function assert(b, msg) {
        if (!b) throw new Error("assertion failed: " + msg);
    }
    function assertEq(actual, expected, msg) {
        if (actual !== expected)
            throw new Error("got: " + uneval(actual) + ", expected: " + uneval(expected) + " - " + msg);
    }

    function assertEquals(actual, expected, msg) {
        function equals(a, b) {
            if (a === b)
                return true;
            if (typeof a !== 'object' || typeof b !== 'object')
                return false;
            if (!equals(Object.getPrototypeOf(a), Object.getPrototypeOf(b)))
                return false;
            var cls = Object.prototype.toString;
            if (cls.call(a) !== cls.call(b))
                return false;
            if (Array.isArray(a))
                return a.length === b.length && a.every(function (val, i) { return equals(val, b[i]); });
            var anames = Object.getOwnPropertyNames(a).sort();
            var bnames = Object.getOwnPropertyNames(b).sort();
            return anames.length === bnames.length && anames.every(function (name, i) {
                return name === bnames[i] && equals(a[name], b[name]);
            });
        }
        if (!equals(actual, expected))
            throw new Error("got: " + uneval(actual) + ", expected: " + uneval(expected) + " - " + msg);
    }

    // Test tokenization.
    ["\0", "\t", "\n", "\r", "0", "'", "$", "\x7f", "\x80", "\xff"].forEach(function (ch) {
        assertEquals(smalltalk.parseExpr("$" + ch), {type: "Character", value: ch});
    });

    ["a", "a:", "a:b:", ":", ":x", ":x:", ":x:y", ":x:y:"].forEach(function (s) {
        assertEquals(smalltalk.parseExpr("#" + s), {type: "Symbol", value: s});
    });

    var a = {type: "Symbol", value: "a"};
    ["#a", "#\n'a'", "####a", "# # # # a", "# # # #\n\ta"].forEach(function (s) {
        assertEquals(smalltalk.parseExpr(s), a);
    });

    ["-1.0e6", "1.0e300", "1e-300", "-1e-300", "1.0e6"].forEach(function (s) {
        assertEquals(smalltalk.parseExpr(s), {type: "Float", value: Number(s)});
    });

    [["1e6", 1000000],
     ["1e-0", 1],
     ["2r11e28", 805306368]].forEach(function (pair) {
        assertEquals(smalltalk.parseExpr(pair[0]), {type: "Integer", value: pair[1]});
     });

    [["2r1111e27", "78000000"],
     ["2r111111e26", "FC000000"]].forEach(function (pair) {
        assertEquals(smalltalk.parseExpr(pair[0]), {type: "LargeInteger", value: pair[1]});
    });

    // Test parsing methods with arguments.
    var foobar = {
        type: "MethodDefinition",
        selector: "foo:",
        args: ["bar"],
        locals: [],
        body: {
            type: "ExprSeq",
            seq: [{type: "Nil"}]
        }
    };
    assertEquals(smalltalk.parseMethod('foo: bar nil.'), foobar);
    assertEquals(smalltalk.parseMethod('foo:bar nil.'), foobar);

    // Test parsing a block with an argument.
    var simpleBlock = {
        type: "Block",
        params: ["i"],
        locals: [],
        body: {
            type: "ExprSeq",
            seq: [{type: "Local", id: "i"}]
        }
    };

    assertEquals(smalltalk.parseExpr("[:i|i]"), simpleBlock);
    assertEquals(smalltalk.parseExpr(" [ : i | i ] "), simpleBlock);

})();

