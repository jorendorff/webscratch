// Test: load, compile, and run handmade-test.st.

(function (argv) {
    "use strict";

    load("../BigInt.js");
    load("../smalltalk.js");
    load("../parse.js");
    load("../deadcode.js");
    load("../compile.js");

    var dump = argv.length === 1 && argv[0] === "-d";
    try {
        var objects_st = read("../../build/sources/ScratchSource1.4/objectdump.txt.utf8");
        var objects_ast = smalltalk.parseMethodNoArgs(objects_st);

        var st = read("handmade-test.st");
        var ast = smalltalk.parseSqueakSource(st);
        smalltalk.deadMethods(ast);

        var js = smalltalk.translate(ast, objects_ast);
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
