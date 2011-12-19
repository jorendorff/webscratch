load("../BigInt.js");
load("../parse.js");

(function () {
    "use strict";

    function assert(b, msg) {
        if (!b) throw new Error("assertion failed: " + msg);
    }
    function assertEq(actual, expected, msg) {
        assert(actual === expected, msg);
    }

    var body = smalltalk.parseMethodNoArgs("$\n").body;
    var expr = body.seq[0];
    assertEq(expr.type, "Character", "$\\n should produce a Character node");
    assertEq(expr.value, "\n", "$\\n should produce a newline Character");
})();

