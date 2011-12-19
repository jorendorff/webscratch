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

    ["\0", "\t", "\n", "\r", "0", "'", "$", "\x7f", "\x80", "\xff"].map(function (ch) {
        var body = smalltalk.parseMethodNoArgs("$" + ch).body;
        var expr = body.seq[0];
        assertEq(expr.type, "Character", "Character node expected");
        assertEq(expr.value, ch, "Character value mismatch");
    });
})();

