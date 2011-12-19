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

    ["\0", "\t", "\n", "\r", "0", "'", "$", "\x7f", "\x80", "\xff"].forEach(function (ch) {
        var expr = smalltalk.parseExpr("$" + ch);
        assertEq(expr.type, "Character");
        assertEq(expr.value, ch);
    });

    ["a", "a:", "a:b:", ":", ":x", ":x:", ":x:y", ":x:y:"].forEach(function (s) {
        var expr = smalltalk.parseExpr("#" + s);
        assertEq(expr.type, "Symbol", "parsing #" + s);
        assertEq(expr.value, s, "result of parsing #" + s);
    });

})();

