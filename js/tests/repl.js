// Compile and load the whole image, then enter a read-eval-print loop.

(function () {
    "use strict";

    function smalltalk_eval(code) {
        var ast = smalltalk.parseMethodNoArgs(code);

        // After parsing the input, but before emitting code, hack the parse
        // tree to make the method answer the value of the last expression.
        var seq = ast.body.seq;
        if (seq.length > 0) {
            var last = seq[seq.length - 1];
            if (last.type !== 'AnswerExpr')
                seq[seq.length - 1] = {type: 'AnswerExpr', expr: last};
        }

        var fn = smalltalk.compileMethodLive(SmalltalkRuntime, ast);
        return fn();
    }

    function repl() {
        var buf = '', line;
        while ((line = readline("smalltalk> ")) !== null) {
            if (line !== '') {
                buf += line + '\n';
                continue;
            }
            try {
                // Clear buf before risking any exception, so that on error the
                // user gets to start with a fresh buffer.
                var code = buf;
                buf = '';
                var val = smalltalk_eval(code);
                print(val.printString().__str);
            } catch (exc) {
                print("*** " + exc.name + ": " + exc.message);
                if (exc.stack)
                    print(exc.stack.replace(/^/mg, '        '));
            }
            print();
        }
    }

    try {
        load("../BigInt.js");
        load("../smalltalk.js");
        load("../ast.js");
        load("../parse.js");
        load("../bind.js");
        load("../compile.js");
        load("../deadcode.js");

        print("Loading...");
        var js = read("../../build/ScratchSources.js");
        var initfn = eval(js);
        initfn(SmalltalkRuntime);
        print("Ready.");

        repl();
    } catch (exc) {
        print(exc.stack);
        throw exc;
    }
})();
