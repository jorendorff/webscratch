(function () {
    "use strict";

    var roots = [
        // base of the Morphic event loop
        'doOneCycleNow',
 
	// likely Morphic event handlers
	'acceptDroppingMorph:event:',
	'click:',
	'cursorKey:',
	'deleteOrCropCurrentSelection:',
	'dispatchKeyStroke:',
	'doubleClick:',
	'enterKeyPressed:',
	'escapeKeyPressed:',
	'handlesMouseDown:',
	'handlesMouseOver:',
	'handlesMouseOverDragging:',
	'justDroppedInto:event:',
	'keyStroke:',
	'linearOffset:',
	'mouseDown:',
	'mouseEnter:',
	'mouseEnterDragging:',
	'mouseHold:',
	'mouseLeave:',
	'mouseLeaveDragging:',
	'mouseMove:',
	'mouseUp:',
	'preemptsMouseDown:',
	'rejectDropEvent:',
	'slideBackToFormerSituation:',
	'startDrag:',
	'tabToNextField:',
	'textMouseDown:',
	'textMouseMove:',
	'wantsDroppedMorph:event:',

	// from blockSpecs
        '&',
        '*',
        '+',
        '-',
        '/',
        '<',
        '=',
        '>',
        '\\\\',
        'allMotorsOff',
        'allMotorsOn',
        'answer',
        'append:toList:',
        'bounceOffEdge',
        'broadcast:',
        'changeGraphicEffect:by:',
        'changePenHueBy:',
        'changePenShadeBy:',
        'changePenSizeBy:',
        'changeSizeBy:',
        'changeTempoBy:',
        'changeVolumeBy:',
        'changeXposBy:',
        'changeYposBy:',
        'clearPenTrails',
        'color:sees:',
        'comeToFront',
        'computeFunction:of:',
        'concatenate:with:',
        'costumeIndex',
        'deleteLine:ofList:',
        'distanceTo:',
        'doAsk',
        'doBroadcastAndWait',
        'doForever',
        'doForeverIf',
        'doIf',
        'doIfElse',
        'doPlaySoundAndWait',
        'doRepeat',
        'doReturn',
        'doUntil',
        'doWaitUntil',
        'drum:duration:elapsed:from:',
        'filterReset',
        'forward:',
        'getAttribute:of:',
        'getLine:ofList:',
        'glideSecs:toX:y:elapsed:from:',
        'goBackByLayers:',
        'gotoSpriteOrMouse:',
        'gotoX:y:',
        'heading',
        'heading:',
        'hide',
        'hideVariable:',
        'insert:at:ofList:',
        'isLoud',
        'keyPressed:',
        'letter:of:',
        'lineCountOfList:',
        'list:contains:',
        'lookLike:',
        'midiInstrument:',
        'motorOnFor:elapsed:from:',
        'mousePressed',
        'mouseX',
        'mouseY',
        'nextCostume',
        'not',
        'noteOn:duration:elapsed:from:',
        'penColor:',
        'penSize:',
        'playSound:',
        'pointTowards:',
        'putPenDown',
        'putPenUp',
        'randomFrom:to:',
        'rest:elapsed:from:',
        'rounded',
        'say:',
        'say:duration:elapsed:from:',
        'scale',
        'sensor:',
        'sensorPressed:',
        'setGraphicEffect:to:',
        'setLine:ofList:to:',
        'setMotorDirection:',
        'setPenHueTo:',
        'setPenShadeTo:',
        'setSizeTo:',
        'setTempoTo:',
        'setVolumeTo:',
        'show',
        'showVariable:',
        'soundLevel',
        'stampCostume',
        'startMotorPower:',
        'stopAll',
        'stopAllSounds',
        'stringLength:',
        'tempo',
        'think:',
        'think:duration:elapsed:from:',
        'timer',
        'timerReset',
        'touching:',
        'touchingColor:',
        'turnLeft:',
        'turnRight:',
        'volume',
        'wait:elapsed:from:',
        'xpos',
        'xpos:',
        'ypos',
        'ypos:',
        '|',

        // for handmade-test.st
        'runTests',

        // Color>>name calls these.
        'black',
        'veryVeryDarkGray',
        'veryDarkGray',
        'darkGray',
        'gray',
        'lightGray',
        'veryLightGray',
        'veryVeryLightGray',
        'white',
        'red',
        'yellow',
        'green',
        'cyan',
        'blue',
        'magenta',
        'brown',
        'orange',
        'lightRed',
        'lightYellow',
        'lightGreen',
        'lightCyan',
        'lightBlue',
        'lightMagenta',
        'lightBrown',
        'lightOrange',
        'transparent',
        'paleBuff',
        'paleBlue',
        'paleYellow',
        'paleGreen',
        'paleRed',
        'veryPaleRed',
        'paleTan',
        'paleMagenta',
        'paleOrange',
        'palePeach',

        // DisplayScanner>>displayLine:offset:leftInRun: calls this
        'endOfRun'
    ];

    function deadMethods(classes_ast) {
	var g = smalltalk.ast.callGraph(classes_ast);
        var q = [];
        var seen = Object.create(null);
        for (var i = 0; i < roots.length; i++) {
            var s = roots[i];
            if (s in g) {
                q.push(s);
                seen[s] = true;
            }
        }

        while (q.length) {
            var s = q.pop();
	    //console.log("marking children of " + s);
            var edges = Object.keys(g[s]);
            for (var i = 0; i < edges.length; i++) {
                var callee = edges[i];
                if (callee in g && !seen[callee]) {
		    //console.log("    " + callee);
                    q.push(callee);
                    seen[callee] = true;
                }
            }
        }

        var n = 0;
        var dead = [];
        for (var c in classes_ast) {
	    var cls = classes_ast[c];
	    for (var m in cls.methods) {
		var method = cls.methods[m].method;
		if (!(method.selector in seen)) {
                    dead.push(cls.name + ">>" + method.selector);
                    delete cls.methods[m];
                }
                n++;
            }
	    for (var m in cls.classMethods) {
		var method = cls.classMethods[m].method;
		if (!(method.selector in seen)) {
                    dead.push(cls.name + " class>>" + method.selector);
                    delete cls.classMethods[m];
                }
                n++;
            }
        }
        console.log(dead.length + " dead methods found (of " + n + " methods)");
        dead.sort();
        return dead;
    }

    smalltalk.deadMethods = deadMethods;

})();
