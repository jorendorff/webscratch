(function () {
    "use strict";

    function assert(b, msg) { if (!b) throw new Error("assertion failed: " + msg); }

    var ast = smalltalk.ast;

    function bindNamesInExpr(classInfo, cls, expr) {
        function bind(expr) {
            if (expr.type === "Identifier") {
                var name = expr.id;
                var cvClass = null;
                for (var c = cls; c; c = classInfo.getSuperclass(c)) {
                    if (classInfo.hasInstVar(c, name))
                        return ast.InstVar(ast.Self(), name);
                    else if (classInfo.hasClassVar(c, name))
                        cvClass = c;
                }
                if (cvClass !== null)
                    return ast.ClassVar(cvClass, name);
                return ast.Global(name);
            }
            return expr;
        }

        return ast.transform(bind, expr);
    }

    function bindNames(classInfo, classes_ast) {
        var kinds = ["methods", "classMethods"];
        for (var className in classes_ast) {
            var cls = classes_ast[className];
            for (var i = 0; i < kinds.length; i++) {
                var kind = kinds[i];
                var collection = cls[kind];
                for (var methodName in collection) {
                    var m = collection[methodName].method;
                    m.body = bindNamesInExpr(classInfo, className, m.body);
                }
            }
        }
    }

    function bindNamesInMethod(classInfo, cls, method_ast) {
        method_ast.body = bindNamesInExpr(classInfo, cls, method_ast.body);
    }

    smalltalk.bindNames = bindNames;
    smalltalk.bindNamesInMethod = bindNamesInMethod;
})();
