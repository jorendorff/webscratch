// Test: load, compile, and run handmade-test.st.

(function () {
    "use strict";

    load("../smalltalk.js");
    load("../parse.js");
    load("../compile.js");

    try {
        var st = read("handmade-test.st");
        var ast = smalltalk.parseSqueakSource(st);
        var js = smalltalk.translate(ast);
        var initfn = eval(js);
        initfn(SmalltalkRuntime);

        SmalltalkRuntime.classes.HandmadeTests.new().testBasics();
    } catch (exc) {
        print(exc.stack);
        throw exc;
    }
    print("pass");
})();
