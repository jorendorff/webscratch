// main.js - Compile Smalltalk sources to JS.

// Fake console.
var console = {
    log: function () {
        print("// log: " + uneval(Array.slice(arguments)));
    },
    warn: function () {
        print("// warn: " + uneval(Array.slice(arguments)));
    }
};

load('smalltalk.js');
load('parse.js');
load('compile.js');

if (arguments.length != 1) {
    print("usage: $JS main.js program.st");
    quit(1);
}

var st = read(arguments[0]);
var ast = smalltalk.parseSqueakSource(st);
var js = smalltalk.translate(ast);
print(js);
