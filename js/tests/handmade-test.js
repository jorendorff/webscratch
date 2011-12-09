// Test: load, compile, and run handmade-test.st.

(function (argv) {
    "use strict";

    load("../BigInt.js");
    load("../smalltalk.js");
    load("../parse.js");
    load("../compile.js");

    var dump = argv.length === 1 && argv[0] === "-d";
    try {
        var st = read("handmade-test.st");
        var ast = smalltalk.parseSqueakSource(st);
        var js = smalltalk.translate(ast);
        if (dump)
            print(js);
        var initfn = eval(js);
        initfn(SmalltalkRuntime);

        SmalltalkRuntime.classes.HandmadeTests.new().runTests();
    } catch (exc) {
        print(exc.stack);
        throw exc;
    }
    print("pass");
})(arguments);
