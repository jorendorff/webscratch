// main.js - Compile Smalltalk sources to JS.

(function (argv) {
    "use strict";

    load('smalltalk.js');
    load('parse.js');
    load('compile.js');

    if (argv.length != 1) {
        print("usage: $JS main.js program.st");
        quit(1);
    }

    var st = read(argv[0]);
    var ast = smalltalk.parseSqueakSource(st);
    var js = smalltalk.translate(ast);
    print(js);
})(arguments);
