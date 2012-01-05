// main.js - Compile Smalltalk sources to JS.

(function (argv) {
    "use strict";

    load('smalltalk.js');
    load('BigInt.js');
    load('algorithms.js');
    load('ast.js');
    load('parse.js');
    load('deadcode.js');
    load('bind.js');
    load('compile.js');

    if (argv.length != 2) {
        print("usage: $JS main.js program.st heap.st");
        quit(1);
    }

    var st = read(argv[0]);
    var ast = smalltalk.parseSqueakSource(st);
    var heap_st = read(argv[1]);
    var heap_ast = smalltalk.parseMethodNoArgs(heap_st);
    smalltalk.deadMethods(ast);
    var js = smalltalk.compileImage(ast, heap_ast);
    print(js);
})(arguments);
