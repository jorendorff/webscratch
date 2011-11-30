// Smalltalk runtime, for use with compile.js and code emitted by it

var SmalltalkRuntime;
var console;

(function () {
    "use strict";

    if (typeof console === "undefined") {
        // Fake console.
        console = {
            log: function () {
                print("// log: " + uneval(Array.slice(arguments)));
            },
            warn: function () {
                print("// warn: " + uneval(Array.slice(arguments)));
            }
        };
    }

    function assert(b, msg) {
        if (!b) throw new Error("assertion failed: " + msg);
    }
    function assertEq(actual, expected, msg) {
        assert(actual === expected, msg);
    }

    var classes = Object.create(null);

    // === Bootstrapping

    // Bootstrap Object, the base class for everything. Object itself
    // is a class, so we have to create Class as well. Ultimately
    // about 6 classes (and their 6 metaclasses and the 12
    // corresponding im objects, plus the special object nil) must be
    // created "by hand" before there is enough on the factory floor
    // to call defClass.

    var Object_im = Object.create(null);
    var Behavior_im = Object.create(Object_im);
    var ClassDescription_im = Object.create(Behavior_im);
    var Metaclass_im = Object.create(ClassDescription_im);
    var Class_im = Object.create(ClassDescription_im);
    var UndefinedObject_im = Object.create(Object_im);

    var Object_class_im = Object.create(Class_im);
    var Behavior_class_im = Object.create(Object_class_im);
    var ClassDescription_class_im = Object.create(Behavior_class_im);
    var Metaclass_class_im = Object.create(ClassDescription_class_im);
    var Class_class_im = Object.create(ClassDescription_class_im);
    var UndefinedObject_class_im = Object.create(Object_class_im);

    var nil = Object.create(UndefinedObject_im);

    function defineBasicClassDescription(metaclass_im, im, iv) {
        var cls = Object.create(metaclass_im);
        cls.__im = im;
        cls.__iv = (cls.__iv || []).concat(iv);
        cls._superclass = im.__class || nil;  // must do this before setting im.__class!
        im.__class = cls;
        cls.__flags = 0;
        cls._methodDict = cls._format = cls._instanceVariables =
            cls._organization = nil;
        return cls;
    }

    function defineBasicClass(name, metaclass_im, im, iv, flags) {
        var cls = defineBasicClassDescription(metaclass_im, im, iv, flags);
        cls._name = name; // should create a Symbol, probably
        cls._subclasses = cls._classPool = cls._sharedPools = cls._environment = nil;
        classes[name] = cls;
        return cls;
    }

    function defineBasicMetaclass(cm, cls) {
        var mcls = defineBasicClassDescription(Metaclass_im, cm, []);
        mcls._thisClass = cls;
    }

    defineBasicClass("Object", Object_class_im, Object_im, []);
    defineBasicClass("Behavior", Behavior_class_im, Behavior_im,
                     ['_superclass', '_methodDict', '_format']);
    defineBasicClass("ClassDescription", ClassDescription_class_im, ClassDescription_im,
                     ['_instanceVariables', '_organization']);
    defineBasicClass("Metaclass", Metaclass_class_im, Metaclass_im,
                     ['_thisClass']);
    defineBasicClass("Class", Class_class_im, Class_im,
                     ['_subclasses', '_name', '_classPool', '_sharedPools',
                      '_environment']);
    defineBasicClass("UndefinedObject", UndefinedObject_class_im, UndefinedObject_im, []);

    defineBasicMetaclass(Object_class_im, classes.Object);
    defineBasicMetaclass(Behavior_class_im, classes.Behavior);
    defineBasicMetaclass(ClassDescription_class_im, classes.ClassDescription);
    defineBasicMetaclass(Metaclass_class_im, classes.Metaclass);
    defineBasicMetaclass(Class_class_im, classes.Class);
    defineBasicMetaclass(UndefinedObject_class_im, classes.UndefinedObject);

    // === Primitives of the bootstrap classes

    function defMethods(im, methods) {
        var keys = Object.keys(methods);
        for (var i = 0; i < keys.length; i++) {
            var k = keys[i];
            im[k] = methods[k];
        }
    }

    function basicNew(cls) {
        var obj = Object.create(cls.__im);
        var iv = cls.__iv;
        for (var i = 0, n = iv.length; i < n; i++)
            obj[iv[i]] = nil;

        switch (cls.__flags) {
        case 0:
            break;
        case 1: case 2: case 3:
            obj.__array = [];
            break;
        case 4: case 6:
            // ByteArrays and LargeIntegers get a byte array.
            // Strings and Symbols get a string.
            if (cls === classes.String || Object.prototype.isPrototypeOf(classes.String.__im, cls.__im))
                obj.__str = "";
            else
                obj.__array = new Uint8Array();
            break;
        }
        return obj;
    }

    function toJSNaturalNumber(i) {
        if (i.__class === SmallInteger_class) {
            assert(i.__value >= 0, "non-negative integer required");
            return i.__value;
        }
        assert(i.isKindOf(classes.Integer), "Integer required");
        throw new Error("not supported yet: converting " + i.__class._name +
                        " object to JS number");
    }

    function basicNew_(cls, size) {
        assert(cls.__flags != 0,
               cls._name + " cannot have variable sized instances");
        var obj = Object.create(cls.__im);
        var iv = cls.__iv;
        for (var i = 0, n = iv.length; i < n; i++)
            obj[iv[i]] = nil;

        switch (cls.__flags) {
        case 0:
            break;
        case 1: case 2: case 3:
            obj.__array = Array(toJSNaturalNumber(size));
            break;
        case 4: case 6:
            if (cls === classes.String || Object.prototype.isPrototypeOf(classes.String.__im, cls.__im))
                obj.__str = Array(toJSNaturalNumber(size) + 1).join("\0");
            else
                obj.__array = new Uint8Array(toJSNaturalNumber(size));
            break;
        }
        return obj;
    }

    function bust() {
        this.error_("primitive not yet implemented");
    }
    function die() {
        this.error_("this program deserves to die");
    }
    function noop() { return this; }

    defMethods(Behavior_im, {
        instSpec: function Behavior$instSpec() {
            return getInteger((this.__flags << 1) |
                              +(this.__flags != 2 && this.__iv.length > 0));
        },
        indexIfCompact: function Behavior$indexIfCompat() {
            return getInteger(0);
        },
        format: die,
        superclass_methodDictionary_format_: die,
        becomeCompact: die,
        becomeCompactSimplyAt: die,
        becomeUncompact: die,
        someInstance: die,
        flushCache: noop
    });

    function Object_shallowCopy() {
        var copy = Object.create(Object.getPrototypeOf(this));
        var iv = this.__class.__iv;
        for (var i = 0, n = iv.length; i < n; i++) {
            var k = iv[i];
            copy[k] = this[k];
        }
        var arr = this.__array;
        if (arr)
            copy.__array = [].concat(arr);
        return copy;
    }

    function Object_error_(msg) {
        debugger;
        throw new Error(msg.__str);
    }

    defMethods(Object_im, {
        pointsTo_: function Object$pointsTo_(v) {
            var keys = Object.keys(this);
            for (var i = 0; i < keys.length; i++) {
                var k = keys[i];
                if (k === "__array") {
                    var arr = this.__array;
                    for (var j = 0; j < arr.length; j++) {
                        if (arr[j] === v)
                            return true_;
                    }
                } else if (this[k] === v) {
                    return true_;
                }
            }
            return false_;
        },
        clone: Object_shallowCopy,
        shallowCopy: Object_shallowCopy,
        perform_: function (aSymbol) { return this.perform_withArguments_(aSymbol, Array_([])); },
        perform_with_: function (aSymbol, arg1) {
            return this.perform_withArguments_(aSymbol, Array_([arg1]));
        },
        perform_with_with_: function (aSymbol, arg1, arg2) {
            return this.perform_withArguments_(aSymbol, Array_([arg1, arg2]));
        },
        perform_with_with_with_: function (aSymbol, arg1, arg2, arg3) {
            return this.perform_withArguments_(aSymbol, Array_([arg1, arg2, arg3]));
        },
        perform_withArguments_: function (selector, argArray) {
            return this.perform_withArguments_inSuperclass_(
                selector, argArray, this.__class);
        },

        beep: function Object$beep() {
            console.log("=== beep ===");
            return this;
        },
        dbeep: function Object$dbeep() {
            console.log("=== dbeep ===");
            return this;
        },
        nextInstance: die,
        nextObject: die,
        someObject: die,
        error_: Object_error_,
        halt_: Object_error_
    });


    // === defClass

    function defClass(name, superclass, im, cm, iv, cv, flags) {
        var cls, cls_im, mcls, mcls_im;
        if (Object.prototype.hasOwnProperty.call(classes, name)) {
            // Class and metaclass already exist.
            cls = classes[name];
            cls_im = cls.__im;
            mcls = cls.__class;
            mcls_im = mcls.__im;
            if (cls._superclass !== superclass &&
                !(name === "Object" && superclass == null))
            {
                throw Error("defClass cannot change the superclass of an existing class");
            }
        } else {
            // Create the class and metaclass.
            mcls_im = Object.create(superclass.__class.__im);
            mcls = defineBasicClassDescription(Metaclass_im, mcls_im, cv);
            cls_im = Object.create(superclass.__im);
            cls = defineBasicClass(name, mcls_im, cls_im, iv);
            cls.__flags = flags || 0;
            var cv = mcls.__iv;
            for (var i = 0, n = cv.length; i < n; i++)
                cls[cv[i]] = nil;

            mcls._thisClass = cls;
        }

        // Define class methods.
        var clsmethods = Object.keys(cm);
        for (var i = 0; i < clsmethods.length; i++) {
            var x = clsmethods[i];
            mcls_im[x] = cm[x];
        }

        // Define instance methods.
        var im_names = Object.keys(im);
        for (var i = 0; i < im_names.length; i++) {
            var x = im_names[i];
            cls_im[x] = im[x];
        }

        assertEq(classes[name], cls);
        return cls;
    }

    function has(cls, methodName) {
        return cls !== undefined &&
               Object.prototype.hasOwnProperty.call(cls.__im, methodName);
    }

    function hasMethod(className, methodName) {
        return has(classes[className], methodName);
    }

    function hasClassMethod(className, methodName) {
        var cls = classes[className];
        return cls !== undefined && has(cls.__class, methodName);
    }


    // === Primitives of other classes

    var primitives = Object.create(null);
    function getPrimitive(module, nameOrIndex) {
        var key = module === null ? "" + nameOrIndex : module + "_" + nameOrIndex;
        return primitives[key];
    }


    // --- Numbers
    defClass("Magnitude", classes.Object, {}, {}, [], []);
    defClass("Number", classes.Magnitude, {}, {}, [], []);
    defClass("Integer", classes.Number, {}, {}, [], []);

    function getInteger(n) {
        if (n < (0xc0000000|0) || 0x3fffffff < n)
            return getLargeInteger(n);
        return getSmallInteger(n);
    }

    function getLargeInteger(n) {
        var cls = n < 0 ? classes.LargeNegativeInteger : classes.LargePositiveInteger;
        n = Math.abs(n);
        var s = n.toString(16);
        if (s.length & 1)
            s = "0" + s;
        var obj = cls.new_(getSmallInteger(s.length >> 1));
        var p = s.length;
        for (var i = 0; i < s.length; i++, p -= 2)
            obj.__array[i] = parseInt(s.slice(p - 2, p), 16);
        return obj;
    }

    function numOp(op) {
        return ("if ({0}.__class === _SmallInteger)\n" +
                "    return __smalltalk.Integer(this.__value " + op + " {0}.__value);\n");
    }

    function isSmall(v) {
        var cls = v.__class;
        if (cls === classes.SmallInteger)
            return true;

        // Large integers with a value that would fit into an int32 also count as small.
        if (cls !== classes.LargePositiveInteger && cls !== classes.LargeNegativeInteger)
            return false;
        var a = v.__array;
        if (a.length !== 4)
            return false;
        if ((a[3] & 0x80) === 0)
            return true;
        return (cls === classes.LargeNegativeInteger &&
                a[3] === 0x80 && a[2] === 0 && a[1] === 0 && a[0] === 0);
    }

    function smallValue(v) {
        var cls = v.__class;
        if (cls === classes.SmallInteger)
            return v.__value;
        var a = v.__array;
        var b = a[0] | (a[1] << 8) | (a[2] << 16) | (a[3] << 24);
        return cls === classes.LargePositiveInteger ? b : -b;
    }

    function bitOp(op) {
        return ("if (__smalltalk.isSmall(this) && __smalltalk.isSmall({0}))\n" +
                "    return __smalltalk.Integer(__smalltalk.smallValue(this) " + op +
                " __smalltalk.smallValue({0}));\n");
    }

    function cmpOp(op) {
        return ("if ({0}.__class === _SmallInteger)\n" +
                "    return this.__value " + op + " {0}.__value ? __smalltalk.true : __smalltalk.false;\n");
    }

    // SmallInteger#+ and #-.
    primitives[1] = numOp("+");
    primitives[2] = numOp("-");

    // SmallInteger#<, #>, #<=, #>=, #=, and #~=.
    primitives[3] = cmpOp("<");
    primitives[4] = cmpOp(">");
    primitives[5] = cmpOp("<=");
    primitives[6] = cmpOp(">=");
    primitives[7] = cmpOp("===");
    primitives[8] = cmpOp("!==");

    // SmallInteger#*. This is careful about the range of the result, because
    // the maximum SmallInteger value is 0x3fffffff, and multiplying that by
    // itself using JS numbers produces 1152921502459363300, 29 less than the
    // correct answer. Addition and subtraction do not have this problem; even
    // results that would overflow 32 bits are still exact in JS (64-bit
    // floating-point) numbers.
    primitives[9] = (
        "if ({0}.__class === _SmallInteger) {\n" +
        "    var $$r = this.__value * {0}.__value;\n" +
        "    if (-0x80000000 <= $$r && $$r <= 0x7fffffff)\n" +
        "        return __smalltalk.Integer($$r);\n" +
        "}\n");

    // SmallInteger#//
    primitives[12] = (
        "if ({0}.__class === _SmallInteger) {" +
        "    return __smalltalk.Integer(Math.floor(this.__value / {0}.__value));\n");

    // SmallInteger#bitAnd:, #bitOr:, and #bitXor:.
    primitives[14] = bitOp("&");
    primitives[15] = bitOp("|");
    primitives[16] = bitOp("^");

    // SmallInteger#bitShift:
    primitives[17] = (
        "if (__smalltalk.isSmall(this) && __smalltalk.isSmall({0})) {\n" +
        "    var $$b = __smalltalk.smallValue(this), $$k = __smalltalk.smallValue({0});\n" +
        "    if ($$k === 0) {\n" +
        "        return this;\n" +
        "    } else if ($$k > 0) {\n" +
        // This only hits for positive $$b. It might be better to test that
        // (($$b << $$k) >> $$k) === $$b, i.e. that 32 bits is sufficient to
        // represent the result; but I can't be bothered to do the proof.
        "        if ($$k < 32 && ($$b & (-1 << (32 - $$k))) === 0)\n" +
        "            return __smalltalk.Integer($$b << $$k);\n" +
        "    } else if ($$k > -32) {\n" +
        "        return __smalltalk.Integer($$b >> -$$k);\n" +
        "    }\n" +
        "}\n");

    // SmallInteger#asFloat
    primitives[40] = "return __smalltalk.Float(this.__value);\n";

    // Float#+ and #-.
    primitives[41] = (
        "if ({0}.__class === _Float)\n" +
        "    return __smalltalk.Float(this.__value + {0}.__value);\n");
    primitives[42] = (
        "if ({0}.__class === _Float)\n" +
        "    return __smalltalk.Float(this.__value - {0}.__value);\n");

    // Float#<, #>, #<=, #>=, #=, #~=.
    primitives[43] = (
        "if ({0}.__class === _Float)\n" +
        "    return this.__value < {0}.__value ? __smalltalk.true : __smalltalk.false;\n");
    primitives[44] = (
        "if ({0}.__class === _Float)\n" +
        "    return this.__value > {0}.__value ? __smalltalk.true : __smalltalk.false;\n");
    primitives[45] = (
        "if ({0}.__class === _Float)\n" +
        "    return this.__value <= {0}.__value ? __smalltalk.true : __smalltalk.false;\n");
    primitives[46] = (
        "if ({0}.__class === _Float)\n" +
        "    return this.__value >= {0}.__value ? __smalltalk.true : __smalltalk.false;\n");
    primitives[47] = (
        "if ({0}.__class === _Float)\n" +
        "    return this.__value === {0}.__value ? __smalltalk.true : __smalltalk.false;\n");
    primitives[48] = (
        "if ({0}.__class === _Float)\n" +
        "    return this.__value !== {0}.__value ? __smalltalk.true : __smalltalk.false;\n");

    // Float#* and #/.
    primitives[49] = (
        "if ({0}.__class === _Float)\n" +
        "    return __smalltalk.Float(this.__value * {0}.__value);\n");
    primitives[50] = (
        "if ({0}.__class === _Float && {0}.__value !== 0)\n" +
        "    return __smalltalk.Float(this.__value / {0}.__value);\n");

    // Float#truncated
    // JS has Math.{floor,ceil,round}, none of which just truncates the fractional part.
    // But the built-in ToInt32 primitive does, and we can get that by doing 'f | 0'.
    primitives[51] = (
        "if (-0x80000000 <= this.__value && this.__value <= 0xffffffff)\n" +
        "    return __smalltalk.Integer(this.__value | 0);\n");

    // Object#at:, Object#basicAt:, LargePositiveInteger#digitAt:, String#byteAt:.
    primitives[60] = (
        "var $$a = this.__array, $$v = $$a[__smalltalk.toJSIndex({0})];\n" +
        "return ($$a instanceof Uint8Array) ? __smalltalk.Integer($$v) : $$v;\n");

    // Object#at:put:, Object#basicAt:put:, LargePositiveInteger#digitAt:put:
    // (This primitive is also used for String#byteAt:put:, but it always
    // fails and that is OK; the fallback code is correct.)
    primitives[61] = (
        "var $$a = this.__array;\n" +
        "if ($$a) {\n" +
        "    var $$i = __smalltalk.toJSIndex({0});\n" +
        "    if ($$a instanceof Uint8Array) {\n" +
        "        assertEq(typeof {1}.__value, 'number');\n" +
        "        $$a[$$i] = {1}.__value;\n" +
        "    } else {\n" +
        "        $$a[$$i] = {1};\n" +
        "    }\n" +
        "    return {1};\n" +
        "}\n");

    // Object#size, Object#basicSize, LargePositiveInteger#digitLength.
    primitives[62] = "return __smalltalk.Integer(this.__array.length);\n";

    // String#at: and String#at:put:.
    primitives[63] = (
        "return __smalltalk.chars[this.__str.charCodeAt(__smalltalk.toJSIndex({0}))];\n");
    primitives[64] = (
        "return __smalltalk.String_at_put_(this, {0}, {1});\n");

    // CompiledMethod#objectAt: and CompiledMethod#objectAt:put:.
    primitives[68] = "throw new Error('CompiledMethod#objectAt:');\n";
    primitives[69] = "throw new Error('CompiledMethod#objectAt:put:');\n";

    // Object#basicNew and Object#basicNew:. 70 is also used for Interval new.
    primitives[70] = "return __smalltalk.basicNew(this);\n";
    primitives[71] = "return __smalltalk.basicNew_(this, {0});\n";

    // Object#instVarAt:.
    // bug: only works for SmallIntegers.
    primitives[73] = "return this[this.__class.__iv[__smalltalk.toJSIndex({0})]];\n";

    // Object#instVarAt:put:.
    // bug: only works for SmallIntegers.
    primitives[74] = (
        "this[this.__class.__iv[{0}.__value - 1]] = {1};\n" +
        "return {1};\n");

    // Object#identityHash, Object#asOop, Symbol#hash.
    var nextHash = 0;
    function getNextHash() {
        return getSmallInteger((nextHash = (nextHash + 1) | 0));
    }
    primitives[75] = (
        "if (!('__identityHash' in this))\n" +
        "    this.__identityHash = __smalltalk.getNextHash();\n" +
        "return this.__identityHash;\n");

    // Object#someInstance and Object#nextInstance.
    primitives[77] = "throw new Error('Object#someInstance');\n";
    primitives[78] = "throw new Error('Object#nextInstance');\n";

    // CompiledMethod newMethod:header:.
    primitives[79] = "throw new Error('CompiledMethod newMethod:header:');\n";

    // BlockContext#valueWithArguments:
    primitives[82] = (
        "return this.__fn.apply(null, __smalltalk.toJSArrayReadOnly({0}));\n");

    // Behavior#flushCache.
    primitives[89] = "return __smalltalk.nil;\n";
    
    // Object#perform:withArguments:inSuperclass:.
    primitives[100] = (
        "return {2}.__im[{0}.__str.replace(/:/g, '_')].apply(this, {1}.__array);\n");

    // Object#==.
    primitives[110] = (
        "return this === {0} ? __smalltalk.true : __smalltalk.false;");

    // Object#class.
    primitives[111] = "return this.__class;\n";

    // Time primSecondsClock.
    var squeakEpoch = new Date(1901, 0, 1, 0, 0, 0).getTime() / 1000;
    primitives[137] = (
        "return __smalltalk.Integer(Math.floor(new Date().getTime() / 1000) - __smalltalk.squeakEpoch);\n");

    // Object#someObject and Object#nextObject.
    primitives[138] = "throw new Error('Object#someObject');\n";
    primitives[139] = "throw new Error('Object#nextObject');\n";

    defClass("SmallInteger", classes.Integer, {
        "*": function (that) {
            return that.__class === SmallInteger_class
                   ? getInteger(this.__value * that.__value) // XXX BUG probably imprecise
                   : classes.Integer.__im["*"].call(this, that);
        },
        "/": function (that) {
            return that.__class === SmallInteger_class
                   ? getInteger(this.__value / that.__value)
                   : classes.Integer.__im["/"].call(this, that);
        },
        "//": function (that) {
            return that.__class === SmallInteger_class
                   ? getInteger(Math.floor(this.__value / that.__value))
                   : classes.Integer.__im["//"].call(this, that);
        }
    }, {}, [], []);
    var SmallInteger_class = classes.SmallInteger;
    var SmallInteger_im = SmallInteger_class.__im;
    function getSmallInteger(n) {
        var obj = Object.create(SmallInteger_im);
        obj.__value = n;
        return obj;
    }

    defClass("Float", classes.Number, {
        arcTan: function () { return getFloat(Math.atan(this.__value)); },
        exp:    function () { return getFloat(Math.exp(this.__value)); },
        ln:     function () { return getFloat(Math.log(this.__value)); },
        sin:    function () { return getFloat(Math.sin(this.__value)); },
        sqrt:   function () { return getFloat(Math.sqrt(this.__value)); }
    }, {}, [], []);
    var Float_class = classes.Float;
    var Float_im = Float_class.__im;
    function getFloat(n) {
        var obj = Object.create(Float_im);
        obj.__value = n;
        return obj;
    }

    // --- Arrays
    defClass("Collection", classes.Object, {}, {}, [], ['_RandomForPicking']);
    defClass("SequenceableCollection", classes.Collection, {}, {}, [], []);
    defClass("ArrayedCollection", classes.SequenceableCollection, {
        size: function () {
            // Strings have .__str; everything else has .__array.
            var arr = this.__array || this.__str;
            return getSmallInteger(arr.length);
        }
    }, {}, [], []);
    defClass("Array", classes.ArrayedCollection, {}, {}, [], ['_EmptyArray'], 1);
    var Array_im = classes.Array.__im;
    function Array_(arr) {
        var obj = Object.create(Array_im);
        obj.__array = arr;
        return obj;
    }

    // Quickly get read-only access to the underlying array of a Smalltalk value.
    function toJSArrayReadOnly(v) {
        assert("__array" in v, "array expected");
        return v.__array;
    }

    function toJSIndex(v) {
        var i = v.__value - 1;
        assert((i | 0) === i, 'invalid index');
        return i;
    }

    // --- Booleans
    // True and False are really pretty ordinary. They don't even have
    // any primitive methods. However we want the values 'true' and
    // 'false' to exist by the time we start executing compiled code,
    // so we have to do at least a little bit of magic here.
    defClass("Boolean", classes.Object, {}, {}, [], []);
    defClass("False", classes.Boolean, {}, {}, [], []);
    defClass("True", classes.Boolean, {}, {}, [], []);
    var false_ = Object.create(classes.False.__im);
    var true_ = Object.create(classes.True.__im);

    function toJSBoolean(v) {
        return v === true_ ||
               (v === false_ ? false : v.halt_(getString("boolean required")));
    }

    // --- Characters
    defClass("Character", classes.Magnitude, {
        "=": function (that) { return this === that ? true_ : false_; }
    }, {}, ['_value'], ['_CharacterTable']);
    var chars = [], chr_im = classes.Character.__im;
    for (var i = 0; i < 256; i++) {
        var c = Object.create(chr_im);
        c._value = getSmallInteger(i);
        chars[i] = c;
    }
    classes.Character._CharacterTable = Array_(chars);

    // --- Blocks
    // This is extremely iffy. At least some of the methods in BlockContext
    // are just hopelessly wrong.
    defClass("InstructionStream", classes.Object, {}, {},
             ['_sender', '_pc'], ['_SpecialConstants']);
    defClass("ContextPart", classes.InstructionStream, {}, {},
             ['_stackp'], ['_PrimitiveFailToken']);
    defClass("BlockContext", classes.ContextPart, {
        value: function Block$value() {
            return this.__fn.call(null);
        },
        value_: function Block$value_(arg1) {
            return this.__fn.call(null, arg1);
        },
        whileTrue_: function Block$whileTrue_(body) {
            while (toJSBoolean(this.value()))
                body.value();
        },
        whileFalse_: function Block$whileFalse_(body) {
            while (!toJSBoolean(this.value()))
                body.value();
        }
    }, {}, ['_nargs', '_startpc', '_home'], []);
    var Block_im = classes.BlockContext.__im;
    function Block(fn) {
        var obj = Object.create(Block_im);
        obj.__fn = fn;
        return obj;
    }

    // --- Strings
    defClass("String", classes.ArrayedCollection, {
        byteAt_: function String$byteAt_(i) {
            return getSmallInteger(this.__str.charCodeAt(i.__value - i));
        },
        byteAt_put_: bust
    }, {}, [], [], 4);
    var String_im = classes.String.__im;
    function getString(str) {
        var obj = Object.create(String_im);
        obj.__str = str;
        return obj;
    }

    function String_at_put_(str, index, v) {
        // Check index.
        if (index.__class !== classes.SmallInteger && !index.isInteger())
            str.errorNonIntegerIndex();
        var s = str.__str;
        assertEq(typeof s, 'string');
        var i = toJSIndex(index);
        if (i < 0 || i >= s.length)
            str.errorSubscriptBounds_(index);

        // Check value.
        var ch;
        if (v.__class === classes.Character)
            ch = String.fromCharCode(v._value.__value);
        else if (v.__class === classes.SmallInteger || v.isInteger())
            ch = String.fromCharCode(v.__value);
        else
            str.error_(getString("Strings only store Characters"));

        str.__str = s.slice(0, i) + ch + s.slice(i + 1);
        return v;
    }


    // --- Symbols
    defClass("Symbol", classes.String, {}, {}, [], [], 4);
    var Symbol_im = classes.Symbol.__im;
    function Symbol(str) {
        var obj = Object.create(Symbol_im);
        obj.__str = str;
        return obj;
    }

    // A circular dependency between String#intern and Symbol#initialize makes
    // it impossible to start without pre-populating Symbol#SingleCharSymbols.
    var symbols = [], sym_im = classes.Symbol.__im;
    for (var i = 0; i < 128; i++) {
        var s = Object.create(sym_im);
        s.__str = String.fromCharCode(i);
        symbols[i] = s;
    }
    classes.Symbol._SingleCharSymbols = Array_(symbols);


    // === Exports

    SmalltalkRuntime = {
        classes: classes,
        nil: nil,
        true: true_,
        false: false_,
        chars: chars,
        String: getString,
        String_at_put_: String_at_put_,
        Symbol: Symbol,
        Float: getFloat,
        SmallInteger: getSmallInteger,
        Integer: getInteger,
        Array: Array_,
        Block: Block,
        defClass: defClass,
        hasMethod: hasMethod,
        hasClassMethod: hasClassMethod,
        getPrimitive: getPrimitive,
        squeakEpoch: squeakEpoch,
        isSmall: isSmall,
        smallValue: smallValue,
        getNextHash: getNextHash,
        basicNew: basicNew,
        basicNew_: basicNew_,
        toJSArrayReadOnly: toJSArrayReadOnly,
        toJSIndex: toJSIndex
    };
})();
