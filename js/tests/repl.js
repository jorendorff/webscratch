// Compile and load the whole image, then enter a read-eval-print loop.

(function () {
    "use strict";

    function repl() {
        var buf = '', line;
        while ((line = readline("smalltalk> ")) !== null) {
            if (line !== '') {
                buf += line + '\n';
                continue;
            }
            var ast = smalltalk.parseMethodNoArgs(buf);

            // After parsing the input, make sure it answers something.
            var seq = ast.body.seq;
            if (seq.length > 0) {
                var last = seq[seq.length - 1];
                if (last.type !== 'AnswerExpr')
                    seq[seq.length - 1] = {type: 'AnswerExpr', expr: last};
            }

            var fn = smalltalk.compileMethodLive(SmalltalkRuntime, ast);
            var val = fn();
            print(val.printString().__str);
            print();
            buf = '';
        }
    }

    try {
        load("../BigInt.js");
        load("../smalltalk.js");
        load("../parse.js");
        load("../compile.js");
        load("../deadcode.js");

        var st = read("../../build/sources/ScratchSource1.4/ScratchSources.st.utf8");
        var ast = smalltalk.parseSqueakSource(st);

        var objects_st = read("../../build/sources/ScratchSource1.4/objectdump.txt.utf8");
        var objects_ast = smalltalk.parseMethodNoArgs(objects_st);

        var dead = smalltalk.deadMethods(ast);
        var js = smalltalk.translate(ast, objects_ast);
        console.log("compiled:  " + js.length + " bytes");
        var initfn = eval(js);
        initfn(SmalltalkRuntime);

        repl();
    } catch (exc) {
        print(exc.stack);
        throw exc;
    }
})();
