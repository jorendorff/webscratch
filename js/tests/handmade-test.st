nil subclass: #Object
	instanceVariableNames: ''
	classVariableNames: 'DependentsFields '
	poolDictionaries: ''
	category: 'Kernel-Objects'!
!Object commentStamp: 'jm 12/7/2005 10:06' prior: 0!
Object is the root class for almost all of the other classes in the class hierarchy.

Class Object provides default behavior common to all normal objects, such as access, copying, comparison, error handling, message sending, and reflection. Also utility messages that all objects should respond to are defined here.

Object has no instance variables, nor should any be added. This is due to several classes of objects that inherit from Object that have special implementations (SmallInteger and UndefinedObject for example) or the VM knows about and depends on the structure and layout of certain standard classes.

Class Variables:
	DependentsFields		an IdentityDictionary
		Provides a virtual 'dependents' field so that any object may have one
		or more dependent views, synchronized by the changed:/update: protocol.
		Note that class Model has a real slot for its dependents, and overrides
		the associated protocol with more efficient implementations.

Because Object is the root of the inheritance tree, methods are often defined in Object to give all objects special behaviors needed by certain subsystems or applications, or to respond to certain general test messages such as isMorph.!


!Object methodsFor: 'initialization' stamp: 'jm 5/29/2003 21:43'!
initialize
	"Initialize this object. Usually called by new when a new object is created. This default implementation does nothing."! !


!Object methodsFor: 'accessing' stamp: 'di 3/29/1999 11:39'!
at: index 
	"Primitive. Assumes receiver is indexable. Answer the value of an 
	indexable element in the receiver. Fail if the argument index is not an 
	Integer or is out of bounds. Essential. See Object documentation 
	whatIsAPrimitive."

	<primitive: 60>
	index isInteger ifTrue:
		[self class isVariable
			ifTrue: [self errorSubscriptBounds: index]
			ifFalse: [self error: (self class name) , 's are not indexable']].
	index isNumber
		ifTrue: [^self at: index asInteger]
		ifFalse: [self errorNonIntegerIndex]! !

!Object methodsFor: 'accessing' stamp: 'di 3/29/1999 11:41'!
at: index put: value 
	"Primitive. Assumes receiver is indexable. Store the argument value in 
	the indexable element of the receiver indicated by index. Fail if the 
	index is not an Integer or is out of bounds. Or fail if the value is not of 
	the right type for this kind of collection. Answer the value that was 
	stored. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 61>
	index isInteger ifTrue:
		[self class isVariable
			ifTrue: [(index >= 1 and: [index <= self size])
					ifTrue: [self errorImproperStore]
					ifFalse: [self errorSubscriptBounds: index]]
			ifFalse: [self error: (self class name) , 's are not indexable']].
	index isNumber
		ifTrue: [^self at: index asInteger put: value]
		ifFalse: [self errorNonIntegerIndex]! !

!Object methodsFor: 'accessing'!
basicAt: index 
	"Primitive. Assumes receiver is indexable. Answer the value of an 
	indexable element in the receiver. Fail if the argument index is not an 
	Integer or is out of bounds. Essential. Do not override in a subclass. See 
	Object documentation whatIsAPrimitive."

	<primitive: 60>
	index isInteger ifTrue: [self errorSubscriptBounds: index].
	index isNumber
		ifTrue: [^self basicAt: index asInteger]
		ifFalse: [self errorNonIntegerIndex]! !

!Object methodsFor: 'accessing'!
basicAt: index put: value 
	"Primitive. Assumes receiver is indexable. Store the second argument 
	value in the indexable element of the receiver indicated by index. Fail 
	if the index is not an Integer or is out of bounds. Or fail if the value is 
	not of the right type for this kind of collection. Answer the value that 
	was stored. Essential. Do not override in a subclass. See Object 
	documentation whatIsAPrimitive."

	<primitive: 61>
	index isInteger
		ifTrue: [(index >= 1 and: [index <= self size])
					ifTrue: [self errorImproperStore]
					ifFalse: [self errorSubscriptBounds: index]].
	index isNumber
		ifTrue: [^self basicAt: index asInteger put: value]
		ifFalse: [self errorNonIntegerIndex]! !

!Object methodsFor: 'accessing'!
basicSize
	"Primitive. Answer the number of indexable variables in the receiver. 
	This value is the same as the largest legal subscript. Essential. Do not 
	override in any subclass. See Object documentation whatIsAPrimitive."

	<primitive: 62>
	"The number of indexable fields of fixed-length objects is 0"
	^0	! !

!Object methodsFor: 'accessing' stamp: 'di 3/29/1999 13:10'!
size
	"Primitive. Answer the number of indexable variables in the receiver. 
	This value is the same as the largest legal subscript. Essential. See Object 
	documentation whatIsAPrimitive."

	<primitive: 62>
	self class isVariable ifFalse: [self errorNotIndexable].
	^ 0! !

!Object methodsFor: 'accessing'!
yourself
	"Answer self."! !


!Object methodsFor: 'testing' stamp: 'jm 5/15/2003 22:54'!
ifNil: nilBlock
	"Just return self, since I am not nil."

	^ self
! !

!Object methodsFor: 'testing' stamp: 'jm 5/15/2003 22:48'!
ifNil: nilBlock ifNotNil: notNilBlock
	"Evaluate notNilBlock, since I am not nil."

	^ notNilBlock value
! !

!Object methodsFor: 'testing' stamp: 'jm 5/15/2003 22:55'!
ifNotNil: notNilBlock
	"Evaluate notNilBlock, since I am not nil."

	^ notNilBlock value
! !

!Object methodsFor: 'testing' stamp: 'jm 5/15/2003 22:55'!
ifNotNil: notNilBlock ifNil: nilBlock 
	"Evaluate notNilBlock, since I am not nil."

	^ notNilBlock value
! !

!Object methodsFor: 'testing' stamp: 'ar 7/9/1999 18:18'!
isBehavior
	"Return true if the receiver is a behavior.
	Note: Do not override in any class except behavior."
	^false! !

!Object methodsFor: 'testing' stamp: 'jm 1/1/2009 16:59'!
isCollection
	"Answer true if I represent a Collection."

	^ false
! !

!Object methodsFor: 'testing'!
isColor
	"Answer true if receiver is a Color. False by default."

	^ false
! !

!Object methodsFor: 'testing' stamp: 'di 11/9/1998 09:38'!
isFloat
	"Overridden to return true in Float, natch"
	^ false! !

!Object methodsFor: 'testing' stamp: 'len 1/13/98 21:18'!
isFraction
	"Answer true if the receiver is a Fraction."

	^ false! !

!Object methodsFor: 'testing' stamp: 'jm 12/8/2005 16:34'!
isHandMorph

	^ false
! !

!Object methodsFor: 'testing'!
isInteger
	"Overridden to return true in Integer."

	^ false! !

!Object methodsFor: 'testing'!
isMorph

	^ false! !

!Object methodsFor: 'testing' stamp: 'jm 5/15/2003 22:33'!
isNil
	"Coerces nil to true and everything else to false."

	^false! !

!Object methodsFor: 'testing'!
isNumber
	"Overridden to return true in Number, natch"
	^ false! !

!Object methodsFor: 'testing' stamp: 'di 11/6/1998 08:04'!
isPoint
	"Overridden to return true in Point."

	^ false! !

!Object methodsFor: 'testing'!
isText
	^ false! !

!Object methodsFor: 'testing' stamp: 'tk 10/21/97 12:45'!
isTransparent
	^ false! !

!Object methodsFor: 'testing' stamp: 'jm 6/2/2008 16:02'!
isUnicode
	"Answer true if I represent a Unicode string."

	^ false
! !

!Object methodsFor: 'testing' stamp: 'sw 9/27/96'!
name
	"Answer a name for the receiver.  This is used generically in the title of certain inspectors, such as the referred-to inspector, and specificially by various subsystems.  By default, we let the object just print itself out..  "

	^ self printString! !

!Object methodsFor: 'testing' stamp: 'jm 5/15/2003 22:56'!
notNil
	"Answer true, since I am not nil."

	^ true
! !

!Object methodsFor: 'testing' stamp: 'jm 5/15/2003 22:33'!
pointsTo: anObject
	"This method returns true if self contains a pointer to anObject,
		and returns false otherwise"
	<primitive: 132>
	1 to: self class instSize do:
		[:i | (self instVarAt: i) == anObject ifTrue: [^ true]].
	1 to: self basicSize do:
		[:i | (self basicAt: i) == anObject ifTrue: [^ true]].
	^ false! !

!Object methodsFor: 'testing' stamp: 'sw 10/20/1999 14:52'!
stepAt: millisecondClockValue in: aWindow

	^ self stepIn: aWindow! !

!Object methodsFor: 'testing' stamp: 'sw 10/19/1999 08:16'!
stepIn: aWindow

	^ self step! !

!Object methodsFor: 'testing' stamp: 'sw 10/19/1999 08:21'!
stepTime
	
	^ 1000 "milliseconds -- default backstop for objects serving as models of system windows"! !

!Object methodsFor: 'testing' stamp: 'di 1/8/1999 15:04'!
wantsSteps
	"Overridden by morphic classes whose instances want to be stepped,
	or by model classes who want their morphic views to be stepped."

	^ false! !

!Object methodsFor: 'testing' stamp: 'sw 10/19/1999 08:26'!
wantsStepsIn: aSystemWindow
	
	^ self wantsSteps! !


!Object methodsFor: 'comparing'!
= anObject 
	"Answer whether the receiver and the argument represent the same 
	object. If = is redefined in any subclass, consider also redefining the 
	message hash."

	^self == anObject! !

!Object methodsFor: 'comparing' stamp: 'jm 5/15/2003 22:58'!
== anObject 
	"Primitive. Answer true if the receiver and the argument are the same object (have the same object pointer). Do not redefine the message == in any other class!! Essential. No Lookup. Do not override in any subclass."

	<primitive: 110>
	self primitiveFailed
! !

!Object methodsFor: 'comparing'!
hash
	"Answer a SmallInteger whose value is related to the receiver's identity.
	May be overridden, and should be overridden in any classes that define = "

	^ self identityHash! !

!Object methodsFor: 'comparing' stamp: 'jm 5/15/2003 22:34'!
identityHash
	"Answer a SmallInteger whose value is related to the receiver's identity.
	This method must not be overridden, except by SmallInteger.
	Primitive. Fails if the receiver is a SmallInteger. Essential.
	See Object documentation whatIsAPrimitive.

	Do not override."

	<primitive: 75>
	self primitiveFailed! !

!Object methodsFor: 'comparing'!
~= anObject 
	"Answer whether the receiver and the argument do not represent the 
	same object."

	^self = anObject == false! !

!Object methodsFor: 'comparing' stamp: 'jm 5/15/2003 22:57'!
~~ anObject
	"Answer true if the argument are not the same object (do not have the same object pointer)."

	self == anObject
		ifTrue: [^ false]
		ifFalse: [^ true]
! !


!Object methodsFor: 'copying'!
clone

	<primitive: 148>
	self primitiveFailed! !

!Object methodsFor: 'copying'!
copy
	"Answer another instance just like the receiver. Subclasses typically 
	override this method; they typically do not override shallowCopy."

	^self shallowCopy! !

!Object methodsFor: 'copying' stamp: 'di 6/9/1999 14:44'!
copySameFrom: otherObject
	"Copy to myself all instance variables named the same in otherObject.
	This ignores otherObject's control over its own inst vars."

	| myInstVars otherInstVars match |
	myInstVars _ self class allInstVarNames.
	otherInstVars _ otherObject class allInstVarNames.
	myInstVars doWithIndex: [:each :index |
		(match _ otherInstVars indexOf: each) > 0 ifTrue:
			[self instVarAt: index put: (otherObject instVarAt: match)]]
! !

!Object methodsFor: 'copying'!
deepCopy
	"Answer a copy of the receiver with its own copy of each instance 
	variable."

	| newObject class index |
	class _ self class.
	(class == Object) ifTrue: [^self].
	class isVariable
		ifTrue: 
			[index _ self basicSize.
			newObject _ class basicNew: index.
			[index > 0]
				whileTrue: 
					[newObject basicAt: index put: (self basicAt: index) deepCopy.
					index _ index - 1]]
		ifFalse: [newObject _ class basicNew].
	index _ class instSize.
	[index > 0]
		whileTrue: 
			[newObject instVarAt: index put: (self instVarAt: index) deepCopy.
			index _ index - 1].
	^newObject! !

!Object methodsFor: 'copying' stamp: 'jm 11/14/97 11:08'!
shallowCopy
	"Answer a copy of the receiver which shares the receiver's instance variables."
	| class newObject index |
	<primitive: 148>
	class _ self class.
	class isVariable
		ifTrue: 
			[index _ self basicSize.
			newObject _ class basicNew: index.
			[index > 0]
				whileTrue: 
					[newObject basicAt: index put: (self basicAt: index).
					index _ index - 1]]
		ifFalse: [newObject _ class basicNew].
	index _ class instSize.
	[index > 0]
		whileTrue: 
			[newObject instVarAt: index put: (self instVarAt: index).
			index _ index - 1].
	^ newObject! !


!Object methodsFor: 'dependents access' stamp: 'sma 2/29/2000 20:24'!
addDependent: anObject
	"Make the given object one of the receiver's dependents."

	| dependents |
	dependents _ self dependents.
	(dependents includes: anObject) ifFalse:
		[self myDependents: (dependents copyWith: anObject)].
	^ anObject! !

!Object methodsFor: 'dependents access' stamp: 'sma 2/29/2000 19:53'!
breakDependents
	"Remove all of the receiver's dependents."

	self myDependents: nil! !

!Object methodsFor: 'dependents access' stamp: 'jm 5/23/2003 20:38'!
canDiscardEdits
	"Answer true if none of the views on this model has unaccepted edits that matter."

	self dependents do: [:each |
		each = self ifFalse: [each canDiscardEdits ifFalse: [^ false]]].
	^ true
! !

!Object methodsFor: 'dependents access' stamp: 'sma 2/29/2000 19:58'!
dependents
	"Answer a collection of objects that are 'dependent' on the receiver;
	 that is, all objects that should be notified if the receiver changes."

	^ self myDependents ifNil: [#()]! !

!Object methodsFor: 'dependents access' stamp: 'jm 5/23/2003 20:40'!
hasUnacceptedEdits
	"Answer true if any of the views on this object has unaccepted edits."

	self dependents do: [:each |
		each = self ifFalse: [each hasUnacceptedEdits ifTrue: [^ true]]].
	^ false
! !

!Object methodsFor: 'dependents access' stamp: 'sma 2/29/2000 19:55'!
myDependents
	"Private. Answer a list of all the receiver's dependents."

	^ DependentsFields at: self ifAbsent: []! !

!Object methodsFor: 'dependents access' stamp: 'sma 2/29/2000 19:52'!
myDependents: aCollectionOrNil
	"Private. Set (or remove) the receiver's dependents list."

	aCollectionOrNil
		ifNil: [DependentsFields removeKey: self ifAbsent: []]
		ifNotNil: [DependentsFields at: self put: aCollectionOrNil]! !

!Object methodsFor: 'dependents access' stamp: 'jm 10/4/2002 17:27'!
release
	"Remove references to objects that may refer to the receiver. This message 
	should be overridden by subclasses with any cycles, in which case the 
	subclass should also include the expression super release."

	self breakDependents.
! !

!Object methodsFor: 'dependents access' stamp: 'sma 2/29/2000 20:23'!
removeDependent: anObject
	"Remove the given object as one of the receiver's dependents."

	| dependents |
	dependents _ self dependents reject: [:each | each == anObject].
	self myDependents: (dependents isEmpty ifFalse: [dependents]).
	^ anObject! !


!Object methodsFor: 'updating'!
changed
	"Receiver changed in a general way; inform all the dependents by 
	sending each dependent an update: message."

	self changed: self! !

!Object methodsFor: 'updating'!
changed: aParameter 
	"Receiver changed. The change is denoted by the argument aParameter. 
	Usually the argument is a Symbol that is part of the dependent's change 
	protocol. Inform all of the dependents."

	self dependents do: [:aDependent | aDependent update: aParameter]! !

!Object methodsFor: 'updating' stamp: 'sw 10/31/1999 00:15'!
noteSelectionIndex: anInteger for: aSymbol
	"backstop"! !

!Object methodsFor: 'updating'!
okToChange
	"Allows a controller to ask this of any model"
	^ true! !

!Object methodsFor: 'updating' stamp: 'sma 2/29/2000 20:05'!
update: aParameter 
	"Receive a change notice from an object of whom the receiver is a 
	dependent. The default behavior is to do nothing; a subclass might want 
	to change itself in some way."

	^ self! !

!Object methodsFor: 'updating' stamp: 'sw 10/19/1999 14:39'!
updateListsAndCodeIn: aWindow
	self canDiscardEdits ifFalse: [^ self].
	aWindow updatablePanes do: [:aPane | aPane verifyContents]! !

!Object methodsFor: 'updating' stamp: 'jm 8/20/1998 18:26'!
windowIsClosing
	"This message is used to inform a models that its window is closing. Most models do nothing, but some, such as the Debugger, must do some cleanup. Note that this mechanism must be used with care by models that support multiple views, since one view may be closed while others left open."
! !


!Object methodsFor: 'printing' stamp: 'di 6/20/97 08:57'!
fullPrintString
	"Answer a String whose characters are a description of the receiver."

	^ String streamContents: [:s | self printOn: s]! !

!Object methodsFor: 'printing'!
isLiteral
	"Answer whether the receiver has a literal text form recognized by the 
	compiler."

	^false! !

!Object methodsFor: 'printing' stamp: 'sma 6/1/2000 09:28'!
longPrintOn: aStream
	"Append to the argument, aStream, the names and values of all 
	of the receiver's instance variables."

	self class allInstVarNames doWithIndex:
		[:title :index |
		aStream nextPutAll: title;
		 nextPut: $:;
		 space;
		 tab;
		 print: (self instVarAt: index);
		 cr]! !

!Object methodsFor: 'printing' stamp: 'sw 9/2/1999 15:18'!
longPrintString
	"Answer a String whose characters are a description of the receiver."
	^ String streamContents: [:aStream | self longPrintOn: aStream]! !

!Object methodsFor: 'printing' stamp: 'sma 6/1/2000 09:31'!
printOn: aStream
	"Append to the argument, aStream, a sequence of characters that  
	identifies the receiver."

	| title |
	title _ self class name.
	aStream
		nextPutAll: (title first isVowel ifTrue: ['an '] ifFalse: ['a ']);
		nextPutAll: title! !

!Object methodsFor: 'printing' stamp: 'sma 6/1/2000 09:22'!
printString
	"Answer a String whose characters are a description of the receiver. 
	If you want to print without a character limit, use fullPrintString."

	^ self printStringLimitedTo: 50000! !

!Object methodsFor: 'printing' stamp: 'tk 5/7/1999 16:20'!
printStringLimitedTo: limit
	"Answer a String whose characters are a description of the receiver.
	If you want to print without a character limit, use fullPrintString."
	| limitedString |
	limitedString _ String streamContents: [:s | self printOn: s] limitedTo: limit.
	limitedString size < limit ifTrue: [^ limitedString].
	^ limitedString , '...etc...'! !

!Object methodsFor: 'printing'!
storeOn: aStream 
	"Append to the argument aStream a sequence of characters that is an 
	expression whose evaluation creates an object similar to the receiver."

	aStream nextPut: $(.
	self class isVariable
		ifTrue: [aStream nextPutAll: '(', self class name, ' basicNew: ';
					store: self basicSize;
					nextPutAll: ') ']
		ifFalse: [aStream nextPutAll: self class name, ' basicNew'].
	1 to: self class instSize do:
		[:i |
		aStream nextPutAll: ' instVarAt: ';
			store: i;
			nextPutAll: ' put: ';
			store: (self instVarAt: i);
			nextPut: $;].
	1 to: self basicSize do:
		[:i |
		aStream nextPutAll: ' basicAt: ';
			store: i;
			nextPutAll: ' put: ';
			store: (self basicAt: i);
			nextPut: $;].
	aStream nextPutAll: ' yourself)'
! !

!Object methodsFor: 'printing' stamp: 'di 6/20/97 09:12'!
storeString
	"Answer a String representation of the receiver from which the receiver 
	can be reconstructed."

	^ String streamContents: [:s | self storeOn: s]! !


!Object methodsFor: 'class membership'!
class
	"Primitive. Answer the object which is the receiver's class. Essential. See 
	Object documentation whatIsAPrimitive."

	<primitive: 111>
	self primitiveFailed! !

!Object methodsFor: 'class membership'!
isKindOf: aClass 
	"Answer whether the class, aClass, is a superclass or class of the receiver."

	self class == aClass
		ifTrue: [^true]
		ifFalse: [^self class inheritsFrom: aClass]! !

!Object methodsFor: 'class membership'!
isMemberOf: aClass 
	"Answer whether the receiver is an instance of the class, aClass."

	^self class == aClass! !

!Object methodsFor: 'class membership'!
respondsTo: aSymbol 
	"Answer whether the method dictionary of the receiver's class contains 
	aSymbol as a message selector."

	^self class canUnderstand: aSymbol! !


!Object methodsFor: 'message handling' stamp: 'di 3/26/1999 07:52'!
perform: aSymbol 
	"Send the unary selector, aSymbol, to the receiver.
	Fail if the number of arguments expected by the selector is not zero.
	Primitive. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 83>
	^ self perform: aSymbol withArguments: (Array new: 0)! !

!Object methodsFor: 'message handling' stamp: 'sw 10/30/1998 18:27'!
perform: selector orSendTo: otherTarget
	"If I wish to intercept and handle selector myself, do it; else send it to otherTarget"
	^ otherTarget perform: selector! !

!Object methodsFor: 'message handling' stamp: 'di 3/26/1999 07:52'!
perform: aSymbol with: anObject 
	"Send the selector, aSymbol, to the receiver with anObject as its argument.
	Fail if the number of arguments expected by the selector is not one.
	Primitive. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 83>
	^ self perform: aSymbol withArguments: (Array with: anObject)! !

!Object methodsFor: 'message handling' stamp: 'di 3/26/1999 07:52'!
perform: aSymbol with: firstObject with: secondObject 
	"Send the selector, aSymbol, to the receiver with the given arguments.
	Fail if the number of arguments expected by the selector is not two.
	Primitive. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 83>
	^ self perform: aSymbol withArguments: (Array with: firstObject with: secondObject)! !

!Object methodsFor: 'message handling' stamp: 'di 3/26/1999 07:51'!
perform: aSymbol with: firstObject with: secondObject with: thirdObject 
	"Send the selector, aSymbol, to the receiver with the given arguments.
	Fail if the number of arguments expected by the selector is not three.
	Primitive. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 83>
	^ self perform: aSymbol
		withArguments: (Array with: firstObject with: secondObject with: thirdObject)! !

!Object methodsFor: 'message handling' stamp: 'di 3/26/1999 07:55'!
perform: selector withArguments: argArray 
	"Send the selector, aSymbol, to the receiver with arguments in argArray.
	Fail if the number of arguments expected by the selector 
	does not match the size of argArray.
	Primitive. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 84>
	^ self perform: selector withArguments: argArray inSuperclass: self class! !

!Object methodsFor: 'message handling' stamp: 'di 3/26/1999 08:00'!
perform: selector withArguments: argArray inSuperclass: lookupClass
	"NOTE:  This is just like perform:withArguments:, except that
	the message lookup process begins, not with the receivers's class,
	but with the supplied superclass instead.  It will fail if lookupClass
	cannot be found among the receiver's superclasses.
	Primitive. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 100>
	(selector isMemberOf: Symbol)
		ifFalse: [^ self error: 'selector argument must be a Symbol'].
	(selector numArgs = argArray size)
		ifFalse: [^ self error: 'incorrect number of arguments'].
	(self class == lookupClass or: [self class inheritsFrom: lookupClass])
		ifFalse: [^ self error: 'lookupClass is not in my inheritance chain'].
	self primitiveFailed! !


!Object methodsFor: 'error handling' stamp: 'jm 5/22/2003 19:32'!
assert: aBlock
	"Raise an error if aBlock does not evaluates to true."

	aBlock value ifFalse: [self error: 'Assertion failed.'].
! !

!Object methodsFor: 'error handling'!
caseError
	"Report an error from an in-line or explicit case statement."

	self error: 'Case not found, and no otherwise clause'! !

!Object methodsFor: 'error handling' stamp: 'jm 5/23/2003 12:43'!
doesNotUnderstand: aMessage 
	 "Error: an attempt was made to send the given message but the receiver does not understand this message. This message is sent by the virtual machine when a message is sent to an object that does not define a method for the message selector."
	"Example: 3 width"

	self error: 'Message not understood: ', aMessage selector.
	^ aMessage sentTo: self
! !

!Object methodsFor: 'error handling' stamp: 'jm 10/8/2006 22:30'!
error: aString
        self halt: aString! !

!Object methodsFor: 'error handling' stamp: 'jm 5/22/2003 19:26'!
halt
	"This message is used to insert breakpoints during debugging."
	"Example: nil halt"

	self halt: 'Halt encountered.'
! !

!Object methodsFor: 'error handling' stamp: 'jm 5/23/2003 12:41'!
halt: aString
	"This is the typical message to use for inserting breakpoints during debugging. It creates and schedules a Debugger with the given string as the label."
	"Example: (self halt: 'Hello!!')"

	Debugger
		openContext: thisContext
		label: aString
		contents: thisContext shortStack.
! !

!Object methodsFor: 'error handling'!
primitiveFailed
	"Announce that a primitive has failed and there is no appropriate 
	Smalltalk code to run."

	self error: 'a primitive has failed'! !

!Object methodsFor: 'error handling'!
shouldNotImplement
	"Announce that, although the receiver inherits this message, it should 
	not implement it."

	self error: 'This message is not appropriate for this object'! !

!Object methodsFor: 'error handling'!
subclassResponsibility
	"This message sets up a framework for the behavior of the class' 
	subclasses. Announce that the subclass should have implemented this 
	message."

	self error: 'My subclass should have overridden one of my messages.'! !


!Object methodsFor: 'user interface' stamp: 'sw 10/4/1999 08:13'!
addModelItemsToWindowMenu: aMenu
	"aMenu is being constructed to be presented to the user in response to the user's pressing on the menu widget in the title bar of a morphic window.  Here, the model is given the opportunity to add any model-specific items to the menu, whose default target is the SystemWindow itself."! !

!Object methodsFor: 'user interface' stamp: 'jm 11/22/2002 19:03'!
beep
	"Emit a short alert sound. Do nothing if the primitive fails."

	<primitive: 140>
! !

!Object methodsFor: 'user interface' stamp: 'jm 6/12/2008 09:58'!
dbeep
	"Debugging beep. Emit a short alert sound. Do nothing if the primitive fails."

	<primitive: 140>
! !

!Object methodsFor: 'user interface'!
defaultLabelForInspector
	"Answer the default label to be used for an Inspector window on the receiver."

	^ self class name! !

!Object methodsFor: 'user interface' stamp: 'di 5/11/1999 22:26'!
modelSleep
	"A window with me as model is being exited or collapsed or closed.
	Default response is no-op" ! !

!Object methodsFor: 'user interface' stamp: 'di 5/11/1999 22:01'!
modelWakeUp
	"A window with me as model is being entered or expanded.  Default response is no-op" ! !

!Object methodsFor: 'user interface' stamp: 'sw 10/16/1999 22:45'!
modelWakeUpIn: aWindow
	"A window with me as model is being entered or expanded.  Default response is no-op" 
	self modelWakeUp! !

!Object methodsFor: 'user interface'!
notYetImplemented
	self inform: 'Not yet implemented'! !

!Object methodsFor: 'user interface' stamp: 'di 6/10/1998 15:06'!
windowActiveOnFirstClick
	"Return true if my window should be active on first click."

	^ false! !

!Object methodsFor: 'user interface' stamp: 'di 6/10/1998 15:06'!
windowReqNewLabel: labelString
	"My window's title has been edited.
	Return true if this is OK, and override for further behavior."

	^ true! !


!Object methodsFor: 'system primitives'!
asOop
	"Primitive. Answer a SmallInteger whose value is half of the receiver's 
	object pointer (interpreting object pointers as 16-bit signed quantities). 
	Fail if the receiver is a SmallInteger. Essential. See Object documentation 
	whatIsAPrimitive."

	<primitive: 75>
	self primitiveFailed! !

!Object methodsFor: 'system primitives' stamp: 'jm 5/15/2003 22:35'!
become: otherObject 
	"Primitive. Swap the object pointers of the receiver and the argument.
	All variables in the entire system that used to point to the 
	receiver now point to the argument, and vice-versa.
	Fails if either object is a SmallInteger"

	(Array with: self)
		elementsExchangeIdentityWith:
			(Array with: otherObject)! !

!Object methodsFor: 'system primitives' stamp: 'di 1/9/1999 15:19'!
becomeForward: otherObject 
	"Primitive. All variables in the entire system that used to point
	to the receiver now point to the argument.
	Fails if either argument is a SmallInteger."

	(Array with: self)
		elementsForwardIdentityTo:
			(Array with: otherObject)! !

!Object methodsFor: 'system primitives'!
instVarAt: index 
	"Primitive. Answer a fixed variable in an object. The numbering of the 
	variables corresponds to the named instance variables. Fail if the index 
	is not an Integer or is not the index of a fixed variable. Essential. See 
	Object documentation whatIsAPrimitive."

	<primitive: 73>
	"Access beyond fixed variables."
	^self basicAt: index - self class instSize		! !

!Object methodsFor: 'system primitives'!
instVarAt: anInteger put: anObject 
	"Primitive. Store a value into a fixed variable in the receiver. The 
	numbering of the variables corresponds to the named instance variables. 
	Fail if the index is not an Integer or is not the index of a fixed variable. 
	Answer the value stored as the result. Using this message violates the 
	principle that each object has sovereign control over the storing of 
	values into its instance variables. Essential. See Object documentation 
	whatIsAPrimitive."

	<primitive: 74>
	"Access beyond fixed fields"
	^self basicAt: anInteger - self class instSize put: anObject! !

!Object methodsFor: 'system primitives' stamp: 'tk 5/5/97'!
instVarNamed: aString
	"Return the value of the instance variabvle in me with that name.  Slow and unclean, but very useful.  "

	^ self instVarAt: ((self class allInstVarNames) indexOf: aString)
! !

!Object methodsFor: 'system primitives' stamp: 'tk 5/5/97'!
instVarNamed: aString put: aValue
	"Store into the value of the instance variable in me of that name.  Slow and unclean, but very useful.  "

	^ self instVarAt: ((self class allInstVarNames) indexOf: aString) put: aValue
! !

!Object methodsFor: 'system primitives' stamp: 'jm 5/15/2003 22:36'!
nextInstance
	"Primitive. Answer the next instance after the receiver in the 
	enumeration of all instances of this class. Fails if all instances have been 
	enumerated. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 78>
	^nil! !

!Object methodsFor: 'system primitives' stamp: 'jm 5/15/2003 22:36'!
nextObject
	"Primitive. Answer the next object after the receiver in the 
	enumeration of all objects. Return 0 when all objects have been 
	enumerated."

	<primitive: 139>
	self primitiveFailed.! !

!Object methodsFor: 'system primitives'!
someObject
	"Primitive. Answer the first object in the enumeration of all
	 objects."

	<primitive: 138>
	self primitiveFailed.! !

!Object methodsFor: 'system primitives' stamp: 'ar 5/25/2000 20:27'!
tryNamedPrimitive
	"This method is a template that the Smalltalk simulator uses to 
	execute primitives. See Object documentation whatIsAPrimitive."
	<primitive:'' module:''>
	^ ContextPart primitiveFailToken! !

!Object methodsFor: 'system primitives' stamp: 'ar 5/25/2000 20:27'!
tryNamedPrimitive: arg1
	"This method is a template that the Smalltalk simulator uses to 
	execute primitives. See Object documentation whatIsAPrimitive."
	<primitive:'' module:''>
	^ ContextPart primitiveFailToken! !

!Object methodsFor: 'system primitives' stamp: 'ar 5/25/2000 20:27'!
tryNamedPrimitive: arg1 with: arg2
	"This method is a template that the Smalltalk simulator uses to 
	execute primitives. See Object documentation whatIsAPrimitive."
	<primitive:'' module:''>
	^ ContextPart primitiveFailToken! !

!Object methodsFor: 'system primitives' stamp: 'ar 5/25/2000 20:27'!
tryNamedPrimitive: arg1 with: arg2 with: arg3
	"This method is a template that the Smalltalk simulator uses to 
	execute primitives. See Object documentation whatIsAPrimitive."
	<primitive:'' module:''>
	^ ContextPart primitiveFailToken! !

!Object methodsFor: 'system primitives' stamp: 'ar 5/25/2000 20:27'!
tryNamedPrimitive: arg1 with: arg2 with: arg3 with: arg4
	"This method is a template that the Smalltalk simulator uses to 
	execute primitives. See Object documentation whatIsAPrimitive."
	<primitive:'' module:''>
	^ ContextPart primitiveFailToken! !

!Object methodsFor: 'system primitives' stamp: 'ar 5/25/2000 20:27'!
tryNamedPrimitive: arg1 with: arg2 with: arg3 with: arg4 with: arg5
	"This method is a template that the Smalltalk simulator uses to 
	execute primitives. See Object documentation whatIsAPrimitive."
	<primitive:'' module:''>
	^ ContextPart primitiveFailToken! !

!Object methodsFor: 'system primitives' stamp: 'ar 5/25/2000 20:27'!
tryNamedPrimitive: arg1 with: arg2 with: arg3 with: arg4 with: arg5 with: arg6
	"This method is a template that the Smalltalk simulator uses to 
	execute primitives. See Object documentation whatIsAPrimitive."
	<primitive:'' module:''>
	^ ContextPart primitiveFailToken! !

!Object methodsFor: 'system primitives' stamp: 'ar 5/25/2000 20:27'!
tryNamedPrimitive: arg1 with: arg2 with: arg3 with: arg4 with: arg5 with: arg6 with: arg7
	"This method is a template that the Smalltalk simulator uses to 
	execute primitives. See Object documentation whatIsAPrimitive."
	<primitive:'' module:''>
	^ ContextPart primitiveFailToken! !

!Object methodsFor: 'system primitives' stamp: 'ar 5/25/2000 20:27'!
tryNamedPrimitive: arg1 with: arg2 with: arg3 with: arg4 with: arg5 with: arg6 with: arg7 with: arg8
	"This method is a template that the Smalltalk simulator uses to 
	execute primitives. See Object documentation whatIsAPrimitive."
	<primitive:'' module:''>
	^ ContextPart primitiveFailToken! !

!Object methodsFor: 'system primitives' stamp: 'di 2/10/1999 22:16'!
tryPrimitive: primIndex withArgs: argumentArray
	"This method is a template that the Smalltalk simulator uses to 
	execute primitives. See Object documentation whatIsAPrimitive."

	<primitive: 118>
	^ ContextPart primitiveFailToken! !


!Object methodsFor: 'private'!
errorImproperStore
	"Create an error notification that an improper store was attempted."

	self error: 'Improper store into indexable object'! !

!Object methodsFor: 'private'!
errorNonIntegerIndex
	"Create an error notification that an improper object was used as an index."

	self error: 'only integers should be used as indices'! !

!Object methodsFor: 'private' stamp: 'di 3/29/1999 12:39'!
errorNotIndexable
	"Create an error notification that the receiver is not indexable."

	self error: (self class name) , 's are not indexable'! !

!Object methodsFor: 'private'!
errorSubscriptBounds: index 
	"Create an error notification that an improper integer was used as an index."

	self error: 'subscript is out of bounds: ' , index printString! !

!Object methodsFor: 'private'!
mustBeBoolean
	"Catches attempts to test truth of non-Booleans.  This message is sent from the
	interpreter."

	self error: 'NonBoolean receiver--proceed for truth.'.
	^true! !

!Object methodsFor: 'private'!
species
	"Answer the preferred class for reconstructing the receiver.  For example, 
	collections create new collections whenever enumeration messages such as 
	collect: or select: are invoked.  The new kind of collection is determined by 
	the species of the original collection.  Species and class are not always the 
	same.  For example, the species of Interval is Array."

	^self class! !

!Object methodsFor: 'private'!
storeAt: offset inTempFrame: aContext
	"This message had to get sent to an expression already on the stack
	as a Block argument being accessed by the debugger.
	Just re-route it to the temp frame."
	^ aContext tempAt: offset put: self! !


!Object methodsFor: 'associating'!
-> anObject
	"Answer an Association between self and anObject"

	^Association new key: self value: anObject! !


!Object methodsFor: 'converting' stamp: 'di 11/9/1998 12:15'!
adaptToFloat: rcvr andSend: selector
	"If no method has been provided for adapting an object to a Float,
	then it may be adequate to simply adapt it to a number."
	^ self adaptToNumber: rcvr andSend: selector! !

!Object methodsFor: 'converting' stamp: 'di 11/9/1998 12:14'!
adaptToFraction: rcvr andSend: selector
	"If no method has been provided for adapting an object to a Fraction,
	then it may be adequate to simply adapt it to a number."
	^ self adaptToNumber: rcvr andSend: selector! !

!Object methodsFor: 'converting' stamp: 'di 11/9/1998 12:15'!
adaptToInteger: rcvr andSend: selector
	"If no method has been provided for adapting an object to a Integer,
	then it may be adequate to simply adapt it to a number."
	^ self adaptToNumber: rcvr andSend: selector! !

!Object methodsFor: 'converting'!
as: aSimilarClass
	"Create an object of class aSimilarClass that has similar contents to the receiver."

	^ aSimilarClass newFrom: self! !

!Object methodsFor: 'converting' stamp: 'jm 8/10/2008 13:09'!
asNumberNoError
	"This message is intended to be sent to strings, booleans, and numbers. This method is a backstop in case some other type of object receives this message."

	^ 0
! !

!Object methodsFor: 'converting' stamp: 'sma 5/12/2000 17:39'!
asOrderedCollection
	"Answer an OrderedCollection with the receiver as its only element."

	^ OrderedCollection with: self! !

!Object methodsFor: 'converting'!
asString
	"Answer a string that represents the receiver."

	^ self printString ! !

!Object methodsFor: 'converting' stamp: 'RAA 3/31/1999 12:13'!
withoutListWrapper

	^self! !


!Object methodsFor: 'casing'!
caseOf: aBlockAssociationCollection
	"The elements of aBlockAssociationCollection are associations between blocks.
	 Answer the evaluated value of the first association in aBlockAssociationCollection
	 whose evaluated key equals the receiver.  If no match is found, report an error."

	^ self caseOf: aBlockAssociationCollection otherwise: [self caseError]

"| z | z _ {[#a]->[1+1]. ['b' asSymbol]->[2+2]. [#c]->[3+3]}. #b caseOf: z"
"| z | z _ {[#a]->[1+1]. ['d' asSymbol]->[2+2]. [#c]->[3+3]}. #b caseOf: z"
"The following are compiled in-line:"
"#b caseOf: {[#a]->[1+1]. ['b' asSymbol]->[2+2]. [#c]->[3+3]}"
"#b caseOf: {[#a]->[1+1]. ['d' asSymbol]->[2+2]. [#c]->[3+3]}"! !

!Object methodsFor: 'casing'!
caseOf: aBlockAssociationCollection otherwise: aBlock
	"The elements of aBlockAssociationCollection are associations between blocks.
	 Answer the evaluated value of the first association in aBlockAssociationCollection
	 whose evaluated key equals the receiver.  If no match is found, answer the result
	 of evaluating aBlock."

	aBlockAssociationCollection associationsDo:
		[:assoc | (assoc key value = self) ifTrue: [^assoc value value]].
	^ aBlock value

"| z | z _ {[#a]->[1+1]. ['b' asSymbol]->[2+2]. [#c]->[3+3]}. #b caseOf: z otherwise: [0]"
"| z | z _ {[#a]->[1+1]. ['d' asSymbol]->[2+2]. [#c]->[3+3]}. #b caseOf: z otherwise: [0]"
"The following are compiled in-line:"
"#b caseOf: {[#a]->[1+1]. ['b' asSymbol]->[2+2]. [#c]->[3+3]} otherwise: [0]"
"#b caseOf: {[#a]->[1+1]. ['d' asSymbol]->[2+2]. [#c]->[3+3]} otherwise: [0]"! !


!Object methodsFor: 'binding'!
bindingOf: aString
	^nil! !


!Object methodsFor: 'macpal' stamp: 'sw 1/28/1999 17:31'!
contentsChanged
	self changed: #contents! !

!Object methodsFor: 'macpal' stamp: 'jm 5/6/1998 22:35'!
flash
	"Do nothing."
! !


!Object methodsFor: 'flagging' stamp: 'sw 2/1/98 16:53'!
flag: aSymbol
	"Send this message, with a relevant symbol as argument, to flag a message for subsequent retrieval.  For example, you might put the following line in a number of messages:
	self flag: #returnHereUrgently
	Then, to retrieve all such messages, browse all senders of #returnHereUrgently."! !


!Object methodsFor: 'translation support' stamp: 'jm 1/20/2004 13:06'!
cCode: aString
	"This contruct is used only when translating Smalltalk to C code."
! !

!Object methodsFor: 'translation support' stamp: 'jm 1/20/2004 13:06'!
cCoerce: ignored1 to: ignored2
	"This contruct is used only when translating Smalltalk to C code."
! !

!Object methodsFor: 'translation support' stamp: 'jm 1/20/2004 13:06'!
export: ignored
	"This contruct is used only when translating Smalltalk to C code."
! !

!Object methodsFor: 'translation support' stamp: 'jm 1/20/2004 13:05'!
failed
	"This contruct is used only when translating Smalltalk to C code."
! !

!Object methodsFor: 'translation support'!
inline: inlineFlag
	"For translation only; noop when running in Smalltalk."! !

!Object methodsFor: 'translation support' stamp: 'jm 1/20/2004 13:05'!
returnTypeC: ignored
	"This contruct is used only when translating Smalltalk to C code."
! !

!Object methodsFor: 'translation support' stamp: 'jm 1/20/2004 13:05'!
success: ignored
	"This contruct is used only when translating Smalltalk to C code."
! !

!Object methodsFor: 'translation support'!
var: varSymbol declareC: declString
	"For translation only; noop when running in Smalltalk."! !


!Object methodsFor: 'finalization' stamp: 'ar 3/21/98 16:26'!
actAsExecutor
	"Prepare the receiver to act as executor for any resources associated with it"
	self breakDependents! !

!Object methodsFor: 'finalization' stamp: 'ar 3/20/98 22:19'!
executor
	"Return an object which can act as executor for finalization of the receiver"
	^self shallowCopy actAsExecutor! !

!Object methodsFor: 'finalization' stamp: 'ar 3/21/98 16:27'!
finalize
	"Finalize the resource associated with the receiver. This message should only be sent during the finalization process. There is NO garantuee that the resource associated with the receiver hasn't been free'd before so take care that you don't run into trouble - this all may happen with interrupt priority."! !

!Object methodsFor: 'finalization' stamp: 'ar 3/21/98 18:38'!
retryWithGC: execBlock until: testBlock
	"Retry execBlock as long as testBlock returns false. Do an incremental GC after the first try, a full GC after the second try."
	| blockValue |
	blockValue := execBlock value.
	(testBlock value: blockValue) ifTrue:[^blockValue].
	Smalltalk garbageCollectMost.
	blockValue := execBlock value.
	(testBlock value: blockValue) ifTrue:[^blockValue].
	Smalltalk garbageCollect.
	^execBlock value.! !


!Object methodsFor: 'object i/o' stamp: 'jm 9/25/2003 10:53'!
initFieldsNamed: varList from: anObjStream
	"Initialize my instance variables in the given list from the given object stream."

	| allVars |
	allVars _ self class allInstVarNames.
	varList do: [:varName |
		self instVarAt: (allVars indexOf: varName) put: anObjStream nextField].
! !

!Object methodsFor: 'object i/o' stamp: 'jm 9/25/2003 10:52'!
storeFieldsNamed: varList on: anObjStream
	"Store the instance variables in the given list on the given object stream."

	| allVars |
	allVars _ self class allInstVarNames.
	varList do: [:varName |
		anObjStream putField: (self instVarAt: (allVars indexOf: varName))].
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Object class
	instanceVariableNames: ''!

!Object class methodsFor: 'instance creation' stamp: 'jm 5/29/2003 21:45'!
new

	^ self basicNew initialize
! !

!Object class methodsFor: 'instance creation' stamp: 'di 6/9/1999 14:27'!
newFrom: aSimilarObject
	"Create an object that has similar contents to aSimilarObject.
	If the classes have any instance varaibles with the same names, copy them across.
	If this is bad for a class, override this method."

	^ self basicNew copySameFrom: aSimilarObject! !

!Object class methodsFor: 'instance creation' stamp: 'tk 4/18/1999 07:05'!
readFrom: aStream
	"Create an object based on the contents of aStream."

	| object ok |
	ok _ (aStream isKindOf: Stream) or: [aStream isKindOf: String].
	(ok or: [aStream isKindOf: Text]) ifFalse: [^ self error: 'expected String or Text'].
	object _ Compiler evaluate: aStream.
	(object isKindOf: self) ifFalse: [self error: self name, ' expected'].
	^object! !


!Object class methodsFor: 'documentation'!
howToModifyPrimitives
	"You are allowed to write methods which specify primitives, but please use 
	caution.  If you make a subclass of a class which contains a primitive method, 
	the subclass inherits the primitive.  The message which is implemented 
	primitively may be overridden in the subclass (E.g., see at:put: in String's 
	subclass Symbol).  The primitive behavior can be invoked using super (see 
	Symbol string:). 
	 
	A class which attempts to mimic the behavior of another class without being 
	its subclass may or may not be able to use the primitives of the original class.  
	In general, if the instance variables read or written by a primitive have the 
	same meanings and are in the same fields in both classes, the primitive will 
	work.  

	For certain frequently used 'special selectors', the compiler emits a 
	send-special-selector bytecode instead of a send-message bytecode.  
	Special selectors were created because they offer two advantages.  Code 
	which sends special selectors compiles into fewer bytes than normal.  For 
	some pairs of receiver classes and special selectors, the interpreter jumps 
	directly to a primitive routine without looking up the method in the class.  
	This is much faster than a normal message lookup. 
	 
	A selector which is a special selector solely in order to save space has a 
	normal behavior.  Methods whose selectors are special in order to 
	gain speed contain the comment, 'No Lookup'.  When the interpreter 
	encounters a send-special-selector bytecode, it checks the class of the 
	receiver and the selector.  If the class-selector pair is a no-lookup pair, 
	then the interpreter swiftly jumps to the routine which implements the 
	corresponding primitive.  (A special selector whose receiver is not of the 
	right class to make a no-lookup pair, is looked up normally).  The pairs are 
	listed below.  No-lookup methods contain a primitive number specification, 
	<primitive: xx>, which is redundant.  Since the method is not normally looked 
	up, deleting the primitive number specification cannot prevent this 
	primitive from running.  If a no-lookup primitive fails, the method is looked 
	up normally, and the expressions in it are executed. 
	 
	No Lookup pairs of (class, selector) 
	 
	SmallInteger with any of		+ - * /  \\  bitOr: bitShift: bitAnd:  // 
	SmallInteger with any of		=  ~=  >  <  >=  <= 
	Any class with					== 
	Any class with 					@ 
	Point with either of				x y 
	ContextPart with					blockCopy: 
	BlockContext with either of 		value value:
	"

	self error: 'comment only'! !

!Object class methodsFor: 'documentation'!
whatIsAPrimitive
	"Some messages in the system are responded to primitively. A primitive   
	response is performed directly by the interpreter rather than by evaluating   
	expressions in a method. The methods for these messages indicate the   
	presence of a primitive response by including <primitive: xx> before the   
	first expression in the method.   
	  
	Primitives exist for several reasons. Certain basic or 'primitive' 
	operations cannot be performed in any other way. Smalltalk without 
	primitives can move values from one variable to another, but cannot add two 
	SmallIntegers together. Many methods for arithmetic and comparison 
	between numbers are primitives. Some primitives allow Smalltalk to 
	communicate with I/O devices such as the disk, the display, and the keyboard. 
	Some primitives exist only to make the system run faster; each does the same 
	thing as a certain Smalltalk method, and its implementation as a primitive is 
	optional.  
	  
	When the Smalltalk interpreter begins to execute a method which specifies a 
	primitive response, it tries to perform the primitive action and to return a 
	result. If the routine in the interpreter for this primitive is successful, 
	it will return a value and the expressions in the method will not be evaluated. 
	If the primitive routine is not successful, the primitive 'fails', and the 
	Smalltalk expressions in the method are executed instead. These 
	expressions are evaluated as though the primitive routine had not been 
	called.  
	  
	The Smalltalk code that is evaluated when a primitive fails usually 
	anticipates why that primitive might fail. If the primitive is optional, the 
	expressions in the method do exactly what the primitive would have done (See 
	Number @). If the primitive only works on certain classes of arguments, the 
	Smalltalk code tries to coerce the argument or appeals to a superclass to find 
	a more general way of doing the operation (see SmallInteger +). If the 
	primitive is never supposed to fail, the expressions signal an error (see 
	SmallInteger asFloat).  
	  
	Each method that specifies a primitive has a comment in it. If the primitive is 
	optional, the comment will say 'Optional'. An optional primitive that is not 
	implemented always fails, and the Smalltalk expressions do the work 
	instead.  
	 
	If a primitive is not optional, the comment will say, 'Essential'. Some 
	methods will have the comment, 'No Lookup'. See Object 
	howToModifyPrimitives for an explanation of special selectors which are 
	not looked up.  
	  
	For the primitives for +, -, *, and bitShift: in SmallInteger, and truncated 
	in Float, the primitive constructs and returns a 16-bit 
	LargePositiveInteger when the result warrants it. Returning 16-bit 
	LargePositiveIntegers from these primitives instead of failing is 
	optional in the same sense that the LargePositiveInteger arithmetic 
	primitives are optional. The comments in the SmallInteger primitives say, 
	'Fails if result is not a SmallInteger', even though the implementor has the 
	option to construct a LargePositiveInteger. For further information on 
	primitives, see the 'Primitive Methods' part of the chapter on the formal 
	specification of the interpreter in the Smalltalk book."

	self error: 'comment only'! !


!Object class methodsFor: 'private' stamp: 'sma 2/29/2000 20:12'!
initializeDependentsFields
	DependentsFields _ IdentityDictionary new

	"Object initializeDependentsFields"! !

Object subclass: #Behavior
	instanceVariableNames: 'superclass methodDict format '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel-Classes'!
!Behavior commentStamp: '<historical>' prior: 0!
My instances describe the behavior of other objects. I provide the minimum state necessary for compiling methods, and creating and running instances. Most objects are created as instances of the more fully supported subclass, Class, but I am a good starting point for providing instance-specific behavior (as in Metaclass).!


!Behavior methodsFor: 'testing'!
isVariable
	"Answer whether the receiver has indexable variables."

	^ self instSpec >= 2! !

!Behavior methodsFor: 'instance creation'!
basicNew
	"Primitive. Answer an instance of the receiver (which is a class) with no 
	indexable variables. Fail if the class is indexable. Essential. See Object 
	documentation whatIsAPrimitive."

	<primitive: 70>
	self isVariable ifTrue: [ ^ self basicNew: 0 ].
	"space must be low"
	Smalltalk signalLowSpace.
	^ self basicNew  "retry if user proceeds"
! !

!Behavior methodsFor: 'instance creation' stamp: 'di 8/18/2000 22:10'!
basicNew: sizeRequested 
	"Primitive. Answer an instance of this class with the number
	of indexable variables specified by the argument, sizeRequested.
	Fail if this class is not indexable or if the argument is not a
	positive Integer, or if there is not enough memory available. 
	Essential. See Object documentation whatIsAPrimitive."

	<primitive: 71>
	self isVariable ifFalse:
		[self error: self printString, ' cannot have variable sized instances'].
	(sizeRequested isInteger and: [sizeRequested >= 0]) ifTrue:
		["arg okay; space must be low."
		Smalltalk signalLowSpace.
		^ self basicNew: sizeRequested  "retry if user proceeds"].
	self primitiveFailed! !

!Behavior methodsFor: 'instance creation' stamp: 'di 8/18/2000 20:27'!
new
	"Answer a new instance of the receiver (which is a class) with no indexable variables. Fail if the class is indexable."

	<primitive: 70>  "This method runs primitively if successful"
	^ self basicNew  "Exceptional conditions will be handled in basicNew"
! !

!Behavior methodsFor: 'instance creation' stamp: 'di 8/18/2000 20:32'!
new: sizeRequested 
	"Answer an instance of this class with the number of indexable
	variables specified by the argument, sizeRequested."

	<primitive: 71>  "This method runs primitively if successful"
	^ self basicNew: sizeRequested  "Exceptional conditions will be handled in basicNew:"
! !



Object subclass: #Boolean
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel-Objects'!
!Boolean commentStamp: '<historical>' prior: 0!
Boolean is an abstract class defining the protocol for logic testing operations and conditional control structures for the logical values represented by the instances of its subclasses True and False.

Boolean redefines #new so no instances of Boolean can be created. It also redefines several messages in the 'copying' protocol to ensure that only one instance of each of its subclasses True (the global true, logical assertion) and False (the global false, logical negation) ever exist in the system.!


!Boolean methodsFor: 'logical operations'!
& aBoolean 
	"Evaluating conjunction. Evaluate the argument. Then answer true if 
	both the receiver and the argument are true."

	self subclassResponsibility! !

!Boolean methodsFor: 'logical operations'!
not
	"Negation. Answer true if the receiver is false, answer false if the 
	receiver is true."

	self subclassResponsibility! !

!Boolean methodsFor: 'logical operations'!
| aBoolean 
	"Evaluating disjunction (OR). Evaluate the argument. Then answer true 
	if either the receiver or the argument is true."

	self subclassResponsibility! !


!Boolean methodsFor: 'controlling'!
and: alternativeBlock 
	"Nonevaluating conjunction. If the receiver is true, answer the value of 
	the argument, alternativeBlock; otherwise answer false without 
	evaluating the argument."

	self subclassResponsibility! !

!Boolean methodsFor: 'controlling'!
ifFalse: alternativeBlock 
	"If the receiver is true (i.e., the condition is true), then the value is the 
	true alternative, which is nil. Otherwise answer the result of evaluating 
	the argument, alternativeBlock. Create an error notification if the 
	receiver is nonBoolean. Execution does not actually reach here because 
	the expression is compiled in-line."

	self subclassResponsibility! !

!Boolean methodsFor: 'controlling'!
ifFalse: falseAlternativeBlock ifTrue: trueAlternativeBlock 
	"Same as ifTrue:ifFalse:."

	self subclassResponsibility! !

!Boolean methodsFor: 'controlling'!
ifTrue: alternativeBlock 
	"If the receiver is false (i.e., the condition is false), then the value is the 
	false alternative, which is nil. Otherwise answer the result of evaluating 
	the argument, alternativeBlock. Create an error notification if the 
	receiver is nonBoolean. Execution does not actually reach here because 
	the expression is compiled in-line."

	self subclassResponsibility! !

!Boolean methodsFor: 'controlling'!
ifTrue: trueAlternativeBlock ifFalse: falseAlternativeBlock
	"If the receiver is true (i.e., the condition is true), then answer the value 
	of the argument trueAlternativeBlock. If the receiver is false, answer the 
	result of evaluating the argument falseAlternativeBlock. If the receiver 
	is a nonBoolean then create an error notification. Execution does not 
	actually reach here because the expression is compiled in-line."

	self subclassResponsibility! !

!Boolean methodsFor: 'controlling'!
or: alternativeBlock 
	"Nonevaluating disjunction. If the receiver is false, answer the value of 
	the argument, alternativeBlock; otherwise answer true without 
	evaluating the argument."

	self subclassResponsibility! !


!Boolean methodsFor: 'copying' stamp: 'tk 6/26/1998 11:32'!
clone 
	"Receiver has two concrete subclasses, True and False.
	Only one instance of each should be made, so return self."! !

!Boolean methodsFor: 'copying'!
deepCopy 
	"Receiver has two concrete subclasses, True and False.
	Only one instance of each should be made, so return self."! !

!Boolean methodsFor: 'copying'!
shallowCopy 
	"Receiver has two concrete subclasses, True and False.
	Only one instance of each should be made, so return self."! !


!Boolean methodsFor: 'printing'!
storeOn: aStream 
	"Refer to the comment in Object|storeOn:."

	self printOn: aStream! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Boolean class
	instanceVariableNames: ''!

!Boolean class methodsFor: 'instance creation'!
new
	self error: 'You may not create any more Booleans - this is two-valued logic'! !


Boolean subclass: #False
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel-Objects'!
!False commentStamp: '<historical>' prior: 0!
False defines the behavior of its single instance, false -- logical negation. Notice how the truth-value checks become direct message sends, without the need for explicit testing.

Be aware however that most of these methods are not sent as real messages in normal use. Most are inline coded by the compiler as test and jump bytecodes - avoiding the overhead of the full message sends. So simply redefining these methods here will have no effect.!


!False methodsFor: 'logical operations'!
& alternativeObject 
	"Evaluating conjunction -- answer false since receiver is false."

	^self! !

!False methodsFor: 'logical operations'!
not
	"Negation -- answer true since the receiver is false."

	^true! !

!False methodsFor: 'logical operations'!
| aBoolean 
	"Evaluating disjunction (OR) -- answer with the argument, aBoolean."

	^aBoolean! !


!False methodsFor: 'controlling'!
and: alternativeBlock 
	"Nonevaluating conjunction -- answer with false since the receiver is false."

	^self! !

!False methodsFor: 'controlling'!
ifFalse: alternativeBlock 
	"Answer the value of alternativeBlock. Execution does not actually
	reach here because the expression is compiled in-line."

	^alternativeBlock value! !

!False methodsFor: 'controlling'!
ifFalse: falseAlternativeBlock ifTrue: trueAlternativeBlock 
	"Answer the value of falseAlternativeBlock. Execution does not
	actually reach here because the expression is compiled in-line."

	^falseAlternativeBlock value! !

!False methodsFor: 'controlling'!
ifTrue: alternativeBlock 
	"Since the condition is false, answer the value of the false alternative, 
	which is nil. Execution does not actually reach here because the
	expression is compiled in-line."

	^nil! !

!False methodsFor: 'controlling'!
ifTrue: trueAlternativeBlock ifFalse: falseAlternativeBlock 
	"Answer the value of falseAlternativeBlock. Execution does not
	actually reach here because the expression is compiled in-line."

	^falseAlternativeBlock value! !

!False methodsFor: 'controlling'!
or: alternativeBlock 
	"Nonevaluating disjunction -- answer value of alternativeBlock."

	^alternativeBlock value! !


!False methodsFor: 'converting' stamp: 'jm 8/9/2008 07:44'!
asNumberNoError

	^ 0
! !


!False methodsFor: 'printing'!
printOn: aStream 

	aStream nextPutAll: 'false'! !


Boolean subclass: #True
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel-Objects'!
!True commentStamp: '<historical>' prior: 0!
True defines the behavior of its single instance, true -- logical assertion. Notice how the truth-value checks become direct message sends, without the need for explicit testing.

Be aware however that most of these methods are not sent as real messages in normal use. Most are inline coded by the compiler as test and jump bytecodes - avoiding the overhead of the full message sends. So simply redefining these methods here will have no effect.!


!True methodsFor: 'logical operations'!
& alternativeObject 
	"Evaluating conjunction -- answer alternativeObject since receiver is true."

	^alternativeObject! !

!True methodsFor: 'logical operations'!
not
	"Negation--answer false since the receiver is true."

	^false! !

!True methodsFor: 'logical operations'!
| aBoolean 
	"Evaluating disjunction (OR) -- answer true since the receiver is true."

	^self! !


!True methodsFor: 'controlling'!
and: alternativeBlock 
	"Nonevaluating conjunction -- answer the value of alternativeBlock since
	the receiver is true."

	^alternativeBlock value! !

!True methodsFor: 'controlling'!
ifFalse: alternativeBlock 
	"Since the condition is true, the value is the true alternative, which is nil. 
	Execution does not actually reach here because the expression is compiled 
	in-line."

	^nil! !

!True methodsFor: 'controlling'!
ifFalse: falseAlternativeBlock ifTrue: trueAlternativeBlock 
	"Answer the value of trueAlternativeBlock. Execution does not 
	actually reach here because the expression is compiled in-line."

	^trueAlternativeBlock value! !

!True methodsFor: 'controlling'!
ifTrue: alternativeBlock 
	"Answer the value of alternativeBlock. Execution does not actually 
	reach here because the expression is compiled in-line."

	^alternativeBlock value! !

!True methodsFor: 'controlling'!
ifTrue: trueAlternativeBlock ifFalse: falseAlternativeBlock 
	"Answer with the value of trueAlternativeBlock. Execution does not 
	actually reach here because the expression is compiled in-line."

	^trueAlternativeBlock value! !

!True methodsFor: 'controlling'!
or: alternativeBlock 
	"Nonevaluating disjunction -- answer true since the receiver is true."

	^self! !


!True methodsFor: 'converting' stamp: 'jm 8/9/2008 07:43'!
asNumberNoError

	^ 1
! !


!True methodsFor: 'printing'!
printOn: aStream 

	aStream nextPutAll: 'true'! !


Object subclass: #UndefinedObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel-Objects'!
!UndefinedObject commentStamp: '<historical>' prior: 0!
I describe the behavior of my sole instance, nil. nil represents a prior value for variables that have not been initialized, or for results which are meaningless.!


!UndefinedObject methodsFor: 'copying' stamp: 'tk 6/26/1998 11:35'!
clone
	"Only one instance of UndefinedObject should ever be made, so answer 
	with self."! !

!UndefinedObject methodsFor: 'copying'!
deepCopy
	"Only one instance of UndefinedObject should ever be made, so answer 
	with self."! !

!UndefinedObject methodsFor: 'copying'!
shallowCopy
	"Only one instance of UndefinedObject should ever be made, so answer 
	with self."! !


!UndefinedObject methodsFor: 'printing'!
printOn: aStream 
	"Refer to the comment in Object|printOn:." 

	aStream nextPutAll: 'nil'! !

!UndefinedObject methodsFor: 'printing'!
storeOn: aStream 
	"Refer to the comment in Object|storeOn:." 

	aStream nextPutAll: 'nil'! !


!UndefinedObject methodsFor: 'testing'!
ifNil: aBlock
	"A convenient test, in conjunction with Object ifNil:"

	^ aBlock value! !

!UndefinedObject methodsFor: 'testing'!
ifNil: nilBlock ifNotNil: ifNotNilBlock
	"Evaluate the block for nil because I'm == nil"

	^ nilBlock value! !

!UndefinedObject methodsFor: 'testing'!
ifNotNil: aBlock
	"A convenient test, in conjunction with Object ifNotNil:"

	^ self! !

!UndefinedObject methodsFor: 'testing'!
ifNotNil: ifNotNilBlock ifNil: nilBlock 
	"If I got here, I am nil, so evaluate the block nilBlock"

	^ nilBlock value! !

!UndefinedObject methodsFor: 'testing' stamp: 'sw 4/7/1999 17:44'!
isEmptyOrNil
	"Answer whether the receiver contains any elements, or is nil.  Useful in numerous situations where one wishes the same reaction to an empty collection or to nil"
	^ true! !

!UndefinedObject methodsFor: 'testing' stamp: 'sma 6/6/2000 22:53'!
isLiteral
	^ true! !

!UndefinedObject methodsFor: 'testing'!
isNil 
	"Refer to the comment in Object|isNil."

	^true! !

!UndefinedObject methodsFor: 'testing'!
notNil 
	"Refer to the comment in Object|notNil."

	^false! !


!UndefinedObject methodsFor: 'dependents access'!
addDependent: ignored 
	"Refer to the comment in Object|dependents."

	self error: 'Nil should not have dependents'! !

!UndefinedObject methodsFor: 'dependents access'!
release
	"Nil release is a no-op"! !

!UndefinedObject methodsFor: 'dependents access'!
suspend
	"Kills off processes that didn't terminate properly"
	"Display reverse; reverse."  "<-- So we can catch the suspend bug"
	Processor terminateActive! !


!UndefinedObject methodsFor: 'class hierarchy' stamp: 'ar 7/15/1999 16:49'!
addSubclass: aClass
	"Ignored -- necessary to support disjoint class hierarchies"! !

!UndefinedObject methodsFor: 'class hierarchy' stamp: 'ar 7/15/1999 16:57'!
environment
	"Necessary to support disjoint class hierarchies."
	^Smalltalk! !

!UndefinedObject methodsFor: 'class hierarchy' stamp: 'ikp 9/26/97 14:45'!
removeSubclass: aClass
	"Ignored -- necessary to support disjoint class hierarchies"! !

!UndefinedObject methodsFor: 'class hierarchy' stamp: 'ar 7/15/1999 18:56'!
subclass: nameOfClass  "Define root (superclass = nil) of a class hierarchy"
	instanceVariableNames: instVarNames
	classVariableNames: classVarNames
	poolDictionaries: poolDictnames
	category: category
	^(ClassBuilder new)
		superclass: self
		subclass: nameOfClass
		instanceVariableNames: instVarNames
		classVariableNames: classVarNames
		poolDictionaries: poolDictnames
		category: category
! !

!UndefinedObject methodsFor: 'class hierarchy' stamp: 'ar 8/29/1999 12:49'!
subclassDefinerClass
	"For disjunct class hierarchies -- how should subclasses of nil be evaluated"
	^Compiler! !

!UndefinedObject methodsFor: 'class hierarchy' stamp: 'ar 7/15/1999 16:55'!
subclasses
	"Return all the subclasses of nil"
	| classList |
	classList _ WriteStream on: Array new.
	self subclassesDo:[:class| classList nextPut: class].
	^classList contents! !

!UndefinedObject methodsFor: 'class hierarchy' stamp: 'jm 5/16/2003 09:37'!
subclassesDo: aBlock
	"Evaluate aBlock with all subclasses of nil. Others are not direct subclasses of Class."

	^ Class subclassesDo: [:cl |
		cl isMeta ifTrue: [aBlock value: cl soleInstance]].
! !

!UndefinedObject methodsFor: 'class hierarchy' stamp: 'ar 7/13/1999 06:08'!
typeOfClass
	"Necessary to support disjoint class hierarchies."
	^#normal! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

UndefinedObject class
	instanceVariableNames: ''!

!UndefinedObject class methodsFor: 'instance creation'!
new
	self error: 'You may not create any more undefined objects--use nil'! !

Object subclass: #Magnitude
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel-Magnitudes'!
!Magnitude commentStamp: '<historical>' prior: 0!
I am an abstract representation of objects that measure something linear. Examples are dates, times, and numbers.!


!Magnitude methodsFor: 'comparing'!
< aMagnitude 
	"Answer whether the receiver is less than the argument."

	^self subclassResponsibility! !

!Magnitude methodsFor: 'comparing'!
<= aMagnitude 
	"Answer whether the receiver is less than or equal to the argument."

	^(self > aMagnitude) not! !

!Magnitude methodsFor: 'comparing'!
= aMagnitude 
	"Compare the receiver with the argument and answer with true if the 
	receiver is equal to the argument. Otherwise answer false."

	^self subclassResponsibility! !

!Magnitude methodsFor: 'comparing'!
> aMagnitude 
	"Answer whether the receiver is greater than the argument."

	^aMagnitude < self! !

!Magnitude methodsFor: 'comparing'!
>= aMagnitude 
	"Answer whether the receiver is greater than or equal to the argument."

	^(self < aMagnitude) not! !

!Magnitude methodsFor: 'comparing'!
between: min and: max 
	"Answer whether the receiver is less than or equal to the argument, max, 
	and greater than or equal to the argument, min."

	^self >= min and: [self <= max]! !

!Magnitude methodsFor: 'comparing'!
hash
	"Hash must be redefined whenever = is redefined."

	^self subclassResponsibility! !

!Magnitude methodsFor: 'comparing' stamp: 'jm 2/25/2003 17:03'!
within: min and: max
	"Answer the receiver if it is within the given interval [min..max]. Otherwise, answer the closest value within that interval."

	self < min ifTrue: [^ min].
	self > max ifTrue: [^ max].
	^ self
! !


!Magnitude methodsFor: 'testing'!
max: aMagnitude 
	"Answer the receiver or the argument, whichever has the greater 
	magnitude."

	self > aMagnitude
		ifTrue: [^self]
		ifFalse: [^aMagnitude]! !

!Magnitude methodsFor: 'testing'!
min: aMagnitude 
	"Answer the receiver or the argument, whichever has the lesser 
	magnitude."

	self < aMagnitude
		ifTrue: [^self]
		ifFalse: [^aMagnitude]! !

!Magnitude methodsFor: 'testing'!
min: aMin max: aMax 

	^ (self min: aMin) max: aMax! !

Magnitude subclass: #Number
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel-Numbers'!
!Number commentStamp: '<historical>' prior: 0!
I am an abstract representation of a number. My subclasses Float, Fraction, and Integer, and their subclasses, provide concrete representations of a numeric quantity.

All my subclasses participate in a simple type coercion mechanism that supports mixed-mode arithmetic and comparisons.  It works as follows:  If
	self<typeA> op: arg<typeB>
fails because of incompatible types, then it is retried in the following guise:
	(arg adaptTypeA: self) op: arg adaptToTypeA.
This gives the arg of typeB an opportunity to resolve the incompatibility, knowing exactly what two types are involved.  If self is more general, then arg will be converted, and viceVersa.  This mechanism is extensible to any new number classes that one might wish to add to Squeak.  The only requirement is that every subclass of Number must support a pair of conversion methods specific to each of the other subclasses of Number.!


!Number methodsFor: 'arithmetic'!
* aNumber 
	"Answer the result of multiplying the receiver by aNumber."

	self subclassResponsibility! !

!Number methodsFor: 'arithmetic'!
+ aNumber 
	"Answer the sum of the receiver and aNumber."

	self subclassResponsibility! !

!Number methodsFor: 'arithmetic'!
- aNumber 
	"Answer the difference between the receiver and aNumber."

	self subclassResponsibility! !

!Number methodsFor: 'arithmetic'!
/ aNumber 
	"Answer the result of dividing the receiver by aNumber."

	self subclassResponsibility! !

!Number methodsFor: 'arithmetic'!
// aNumber 
	"Integer quotient defined by division with truncation toward negative 
	infinity. 9//4 = 2, -9//4 = -3. -0.9//0.4 = -3. \\ answers the remainder 
	from this division."

	^(self / aNumber) floor! !

!Number methodsFor: 'arithmetic'!
\\ aNumber 
	"modulo. Remainder defined in terms of //. Answer a Number with the 
	same sign as aNumber. e.g. 9\\4 = 1, -9\\4 = 3, 9\\-4 = -3, 0.9\\0.4 = 0.1."

	^self - (self // aNumber * aNumber)! !

!Number methodsFor: 'arithmetic'!
abs
	"Answer a Number that is the absolute value (positive magnitude) of the 
	receiver."

	self < 0
		ifTrue: [^self negated]
		ifFalse: [^self]! !

!Number methodsFor: 'arithmetic'!
negated
	"Answer a Number that is the negation of the receiver."

	^0 - self! !

!Number methodsFor: 'arithmetic'!
quo: aNumber 
	"Integer quotient defined by division with truncation toward zero. -9 quo: 
	4 = -2, -0.9 quo: 0.4 = -2. rem: answers the remainder from this division."

	^(self / aNumber) truncated! !

!Number methodsFor: 'arithmetic'!
reciprocal
	"Answer 1 divided by the receiver. Create an error notification if the 
	receiver is 0."

	self = 0
		ifTrue: [^self error: 'zero has no reciprocal']
		ifFalse: [^1 / self]! !

!Number methodsFor: 'arithmetic'!
rem: aNumber 
	"Remainder defined in terms of quo:. Answer a Number with the same 
	sign as self. e.g. 9 rem: 4 = 1, -9 rem: 4 = -1. 0.9 rem: 0.4 = 0.1."

	^self - ((self quo: aNumber) * aNumber)! !


!Number methodsFor: 'mathematical functions'!
arcCos 
	"The receiver is the cosine of an angle. Answer the angle measured in 
	radians."

	^self asFloat arcCos! !

!Number methodsFor: 'mathematical functions'!
arcSin
	"The receiver is the sine of an angle. Answer the angle measured in 
	radians."

	^self asFloat arcSin! !

!Number methodsFor: 'mathematical functions'!
arcTan
	"The receiver is the tangent of an angle. Answer the angle measured in 
	radians."

	^self asFloat arcTan! !

!Number methodsFor: 'mathematical functions' stamp: 'jsp 2/24/1999 15:20'!
arcTan: denominator
	"The receiver is the tangent of an angle. Answer the angle measured in 
	radians."

	^(self asFloat) arcTan: denominator.! !

!Number methodsFor: 'mathematical functions'!
cos
	"The receiver represents an angle measured in radians. Answer its cosine."

	^self asFloat cos! !

!Number methodsFor: 'mathematical functions'!
exp
	"Answer the exponential of the receiver as a floating point number."

	^self asFloat exp! !

!Number methodsFor: 'mathematical functions' stamp: 'jm 3/27/98 06:16'!
floorLog: radix
	"Answer the floor of the log base radix of the receiver."

	^ self asFloat floorLog: radix
! !

!Number methodsFor: 'mathematical functions'!
ln
	"Answer the natural log of the receiver."

	^self asFloat ln! !

!Number methodsFor: 'mathematical functions' stamp: 'di 9/8/1998 17:10'!
log
	"Answer the base-10 log of the receiver."

	^self asFloat log! !

!Number methodsFor: 'mathematical functions'!
log: aNumber 
	"Answer the log base aNumber of the receiver."

	^self ln / aNumber ln! !

!Number methodsFor: 'mathematical functions' stamp: 'RJ 3/15/1999 19:35'!
raisedTo: aNumber 
	"Answer the receiver raised to aNumber."

	aNumber isInteger ifTrue:
		["Do the special case of integer power"
		^ self raisedToInteger: aNumber].
	self < 0 ifTrue:
		[ self error: self printString, ' raised to a non-integer power' ].
	aNumber = 0 ifTrue: [^ 1].		"Special case of exponent=0"
	(self = 0) | (aNumber = 1) ifTrue:
		[^ self].						"Special case of exponent=1"
	^ (aNumber * self ln) exp		"Otherwise use logarithms"! !

!Number methodsFor: 'mathematical functions' stamp: 'RJ 3/15/1999 19:32'!
raisedToInteger: anInteger 
	"Answer the receiver raised to the power anInteger where the argument 
	must be a kind of Integer. This is a special case of raisedTo:."

	anInteger isInteger ifFalse:
		[^self error: 'raisedToInteger: only works for integral arguments'].
	anInteger = 0 ifTrue: [^ 1].
	(self = 0) | (anInteger = 1) ifTrue: [^ self].
	anInteger > 1 ifTrue:
		[^ (self * self raisedToInteger: anInteger // 2)
					* (self raisedToInteger: anInteger \\ 2)].
	^ (self raisedToInteger: anInteger negated) reciprocal! !

!Number methodsFor: 'mathematical functions'!
sin
	"The receiver represents an angle measured in radians. Answer its sine."

	^self asFloat sin! !

!Number methodsFor: 'mathematical functions'!
sqrt
	"Answer the square root of the receiver."

	^self asFloat sqrt! !

!Number methodsFor: 'mathematical functions'!
squared
	"Answer the receiver multipled by itself."

	^self * self! !

!Number methodsFor: 'mathematical functions'!
tan
	"The receiver represents an angle measured in radians. Answer its 
	tangent."

	^self asFloat tan! !


!Number methodsFor: 'truncation and round off'!
ceiling
	"Answer the integer nearest the receiver toward positive infinity."

	self <= 0.0
		ifTrue: [^self truncated]
		ifFalse: [^self negated floor negated]! !

!Number methodsFor: 'truncation and round off' stamp: 'di 2/19/98 21:58'!
detentBy: detent atMultiplesOf: grid snap: snap
	"Map all values that are within detent/2 of any multiple of grid to that multiple.  Otherwise, if snap is true, return self, meaning that the values in the dead zone will never be returned.  If snap is false, then expand the range between dead zones so that it covers the range between multiples of the grid, and scale the value by that factor."
	| r1 r2 |
	r1 _ self roundTo: grid.  "Nearest multiple of grid"
	(self roundTo: detent) = r1 ifTrue: [^ r1].  "Snap to that multiple..."
	snap ifTrue: [^ self].  "...or return self"

	r2 _ self < r1  "Nearest end of dead zone"
		ifTrue: [r1 - (detent asFloat/2)]
		ifFalse: [r1 + (detent asFloat/2)].
	"Scale values between dead zones to fill range between multiples"
	^ r1 + ((self - r2) * grid asFloat / (grid - detent))
"
	(170 to: 190 by: 2) collect: [:a | a detentBy: 10 atMultiplesOf: 90 snap: true] 	(170 to: 190 by: 2) collect: [:a | a detentBy: 10 atMultiplesOf: 90 snap: false]
	(3.9 to: 4.1 by: 0.02) collect: [:a | a detentBy: 0.1 atMultiplesOf: 1.0 snap: true] 	(-3.9 to: -4.1 by: -0.02) collect: [:a | a detentBy: 0.1 atMultiplesOf: 1.0 snap: false]
"! !

!Number methodsFor: 'truncation and round off'!
floor
	"Answer the integer nearest the receiver toward negative infinity."

	| truncation |
	truncation _ self truncated.
	self >= 0 ifTrue: [^truncation].
	self = truncation
		ifTrue: [^truncation]
		ifFalse: [^truncation - 1]! !

!Number methodsFor: 'truncation and round off' stamp: 'di 10/4/1999 08:08'!
roundTo: quantum 
	"Answer the nearest number that is a multiple of quantum."

	^(self / quantum) rounded * quantum! !

!Number methodsFor: 'truncation and round off'!
roundUpTo: aNumber 
	"Answer the next multiple of aNumber toward infinity that is nearest the 
	receiver."

	^(self/aNumber) ceiling * aNumber! !

!Number methodsFor: 'truncation and round off'!
rounded
	"Answer the integer nearest the receiver."

	^(self + (self sign / 2)) truncated! !

!Number methodsFor: 'truncation and round off'!
truncateTo: aNumber 
	"Answer the next multiple of aNumber toward zero that is nearest the 
	receiver."

	^(self quo: aNumber)
		* aNumber! !

!Number methodsFor: 'truncation and round off'!
truncated
	"Answer an integer nearest the receiver toward zero."

	^self quo: 1! !


!Number methodsFor: 'testing'!
even
	"Answer whether the receiver is an even number."

	^self \\ 2 = 0! !

!Number methodsFor: 'testing' stamp: 'sw 12/30/1998 13:21'!
isDivisibleBy: aNumber
	aNumber = 0 ifTrue: [^ false].
	aNumber isInteger ifFalse: [^ false].
	^ (self \\ aNumber) = 0! !

!Number methodsFor: 'testing' stamp: 'tao 10/10/97 16:36'!
isInf
	^ false! !

!Number methodsFor: 'testing' stamp: 'tao 4/19/98 23:33'!
isInfinite

	^ false! !

!Number methodsFor: 'testing' stamp: 'tao 10/10/97 16:36'!
isNaN
	^ false! !

!Number methodsFor: 'testing'!
isNumber
	^ true! !

!Number methodsFor: 'testing'!
isZero
	^self = 0! !

!Number methodsFor: 'testing' stamp: 'di 4/23/1998 11:18'!
negative
	"Answer whether the receiver is mathematically negative."

	^ self < 0! !

!Number methodsFor: 'testing'!
odd
	"Answer whether the receiver is an odd number."

	^self even == false! !

!Number methodsFor: 'testing'!
sign
	"Answer 1 if the receiver is greater than 0, -1 if less than 0, else 0."

	self > 0 ifTrue: [^1].
	self < 0 ifTrue: [^-1].
	^0! !


!Number methodsFor: 'converting'!
@ y 
	"Primitive. Answer a Point whose x value is the receiver and whose y 
	value is the argument. Optional. No Lookup. See Object documentation 
	whatIsAPrimitive."

	<primitive: 18>
	^Point x: self y: y! !

!Number methodsFor: 'converting' stamp: 'di 11/6/1998 13:21'!
adaptToFloat: rcvr andSend: selector 
	"If I am involved in arithmetic with a Float, convert me to a Float."
	^ rcvr perform: selector with: self asFloat! !

!Number methodsFor: 'converting' stamp: 'di 11/6/1998 13:44'!
adaptToFraction: rcvr andSend: selector
	"If I am involved in arithmetic with a Fraction, convert us and evaluate exprBlock."
	^ self subclassResponsibility! !

!Number methodsFor: 'converting' stamp: 'di 11/6/1998 13:44'!
adaptToInteger: rcvr andSend: selector
	"If I am involved in arithmetic with a Integer, convert us and evaluate exprBlock."
	^ self subclassResponsibility! !

!Number methodsFor: 'converting' stamp: 'di 11/6/1998 13:44'!
adaptToPoint: rcvr andSend: selector
	"If I am involved in arithmetic with a Point, convert me to a Point."
	^ rcvr perform: selector with: self@self! !

!Number methodsFor: 'converting'!
asInteger
	"Answer an Integer nearest the receiver toward zero."

	^self truncated! !

!Number methodsFor: 'converting' stamp: 'sw 2/16/1999 18:15'!
asNumber
	^ self! !

!Number methodsFor: 'converting' stamp: 'jm 5/8/2008 11:01'!
asNumberNoError

	^ self
! !

!Number methodsFor: 'converting'!
asPoint
	"Answer a Point with the receiver as both coordinates; often used to 
	supply the same value in two dimensions, as with symmetrical gridding 
	or scaling."

	^self @ self! !

!Number methodsFor: 'converting' stamp: 'sw 9/8/97 16:30'!
asSmallAngleDegrees
	"Return the receiver normalized to lie within the range (-180, 180)"

	| pos |
	pos _ self \\ 360.
	pos > 180 ifTrue: [pos _ pos - 360].
	^ pos

"#(-500 -300 -150 -5 0 5 150 300 500 1200) collect: [:n | n asSmallAngleDegrees]"! !

!Number methodsFor: 'converting' stamp: 'sw 10/7/1999 12:24'!
asSmallPositiveDegrees
	"Return the receiver normalized to lie within the range (0, 360)"

	| result |
	result _ self.
	[result < 0] whileTrue: [result _ result + 360].
	^ result \\ 360

"#(-500 -300 -150 -5 0 5 150 300 500 1200) collect: [:n | n asSmallPositiveDegrees]"! !

!Number methodsFor: 'converting'!
degreesToRadians
	"The receiver is assumed to represent degrees. Answer the conversion to 
	radians."

	^self asFloat degreesToRadians! !

!Number methodsFor: 'converting' stamp: 'jm 8/4/2008 09:12'!
localized

	^ self
! !

!Number methodsFor: 'converting'!
radiansToDegrees
	"The receiver is assumed to represent radians. Answer the conversion to 
	degrees."

	^self asFloat radiansToDegrees! !


!Number methodsFor: 'intervals'!
to: stop
	"Answer an Interval from the receiver up to the argument, stop, 
	incrementing by 1."

	^Interval from: self to: stop by: 1! !

!Number methodsFor: 'intervals'!
to: stop by: step
	"Answer an Interval from the receiver up to the argument, stop, 
	incrementing by step."

	^Interval from: self to: stop by: step! !

!Number methodsFor: 'intervals' stamp: 'tao 1/30/1999 08:58'!
to: stop by: step do: aBlock 
	"Normally compiled in-line, and therefore not overridable.
	Evaluate aBlock for each element of the interval (self to: stop by: 
step)."
	| nextValue |
	nextValue _ self.
	step = 0 ifTrue: [self error: 'step must be non-zero'].
	step < 0
		ifTrue: [[stop <= nextValue]
				whileTrue: 
					[aBlock value: nextValue.
					nextValue _ nextValue + step]]
		ifFalse: [[stop >= nextValue]
				whileTrue: 
					[aBlock value: nextValue.
					nextValue _ nextValue + step]]! !

!Number methodsFor: 'intervals'!
to: stop do: aBlock 
	"Normally compiled in-line, and therefore not overridable.
	Evaluate aBlock for each element of the interval (self to: stop by: 1)."
	| nextValue |
	nextValue _ self.
	[nextValue <= stop]
		whileTrue: 
			[aBlock value: nextValue.
			nextValue _ nextValue + 1]! !


!Number methodsFor: 'printing'!
defaultLabelForInspector
	"Answer the default label to be used for an Inspector window on the receiver."

	^ super defaultLabelForInspector, ': ', self printString! !

!Number methodsFor: 'printing' stamp: 'jm 6/3/2004 18:52'!
hhmmss

	^ self rounded hhmmss
! !

!Number methodsFor: 'printing' stamp: 'sw 6/29/1999 21:10'!
isOrAreStringWith: aNoun
	| result |
	result _ self = 1
		ifTrue:
			[' is one ']
		ifFalse:
			[self = 0
				ifTrue:
					[' are no ']
				ifFalse:
					[' are ', self printString, ' ']].
	result _ result, aNoun.
	self = 1 ifFalse: [result _ result, 's'].
	^ result

"#(0 1 2 98.6) do:
	[:num | Transcript cr; show: 'There', (num isOrAreStringWith: 'way'), ' to skin a cat']"! !

!Number methodsFor: 'printing'!
printOn: aStream
	"Default print radix is 10"
	self printOn: aStream base: 10! !

!Number methodsFor: 'printing'!
printStringBase: base
	^ String streamContents:
		[:strm | self printOn: strm base: base]! !

!Number methodsFor: 'printing' stamp: 'jm 9/1/2008 23:33'!
printStringNoExponent

	^ self printString
! !

!Number methodsFor: 'printing'!
storeOn: aStream 
	"Normal printing is OK for storing"
	self printOn: aStream! !

!Number methodsFor: 'printing'!
storeOn: aStream base: base
	"Append my printed representation to aStream, incuding the base."

	self printOn: aStream base: base! !

!Number methodsFor: 'printing'!
storeStringBase: base
	^ String streamContents: [:strm | self storeOn: strm base: base]! !

!Number methodsFor: 'printing' stamp: 'sw 7/1/1998 12:33'!
stringForReadout
	^ self rounded printString! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Number class
	instanceVariableNames: ''!

!Number class methodsFor: 'instance creation' stamp: 'bf 12/9/1998 19:21'!
readFrom: stringOrStream 
	"Answer a number as described on aStream.  The number may
	include a leading radix specification, as in 16rFADE"
	| value base aStream sign |
	aStream _ (stringOrStream isMemberOf: String)
		ifTrue: [ReadStream on: stringOrStream]
		ifFalse: [stringOrStream].
	(aStream nextMatchAll: 'NaN') ifTrue: [^ Float nan].
	sign _ (aStream peekFor: $-) ifTrue: [-1] ifFalse: [1].
	(aStream nextMatchAll: 'Infinity') ifTrue: [^ Float infinity * sign].
	base _ 10.
	value _ Integer readFrom: aStream base: base.
	(aStream peekFor: $r)
		ifTrue: 
			["<base>r<integer>"
			(base _ value) < 2 ifTrue: [^self error: 'Invalid radix'].
			(aStream peekFor: $-) ifTrue: [sign _ sign negated].
			value _ Integer readFrom: aStream base: base].
	^ self readRemainderOf: value from: aStream base: base withSign: sign.! !

!Number class methodsFor: 'instance creation' stamp: 'tao 4/23/98 12:24'!
readFrom: stringOrStream base: base
	"Answer a number as described on aStream in the given number base."

	| aStream sign |
	aStream _ (stringOrStream isMemberOf: String)
		ifTrue: [ReadStream on: stringOrStream]
		ifFalse: [stringOrStream].
	(aStream nextMatchAll: 'NaN') ifTrue: [^ Float nan].
	sign _ (aStream peekFor: $-) ifTrue: [-1] ifFalse: [1].
	(aStream nextMatchAll: 'Infinity') ifTrue: [^ Float infinity * sign].
	^ self readRemainderOf: (Integer readFrom: aStream base: base)
			from: aStream base: base withSign: sign! !

!Number class methodsFor: 'instance creation' stamp: 'tao 4/23/98 12:12'!
readRemainderOf: integerPart from: aStream base: base withSign: sign
	"Read optional fractional part and exponent, and return the final result"

	| value fraction fracpos |

	value _ integerPart.
	(aStream peekFor: $.)
		ifTrue: 
			["<integer>.<fraction>"
			(aStream atEnd not and: [aStream peek digitValue between: 0 and: base - 1])
				ifTrue: 
					[fracpos _ aStream position.
					fraction _ Integer readFrom: aStream base: base.
					fraction _ 
						fraction asFloat / (base raisedTo: aStream position - fracpos).
					value _ value asFloat + fraction]
				ifFalse: 
					["oops - just <integer>."
					aStream skip: -1.		"un-gobble the period"
					^ value * sign
					"Number readFrom: '3r-22.2'"]].
	(aStream peekFor: $e)
		ifTrue: 
			["<integer>e<exponent>"
			value _ value * (base raisedTo: (Integer readFrom: aStream))].
	(value isFloat and: [value = 0.0 and: [sign = -1]])
		ifTrue: [^ Float negativeZero]
		ifFalse: [^ value * sign]! !


Number variableWordSubclass: #Float
	instanceVariableNames: ''
	classVariableNames: 'E Epsilon Halfpi Infinity Ln10 Ln2 MaxVal MaxValLn MinValLogBase2 NaN NegativeInfinity NegativeZero Pi RadiansPerDegree Sqrt2 Twopi '
	poolDictionaries: ''
	category: 'Kernel-Numbers'!
!Float commentStamp: '<historical>' prior: 0!
My instances represent IEEE-754 floating-point double-precision numbers.  They have about 16 digits of accuracy and their range is between plus and minus 10^307. Some valid examples are:
	
	8.0 13.3 0.3 2.5e6 1.27e-30 1.27e-31 -12.987654e12

Mainly: no embedded blanks, little e for tens power, and a digit on both sides of the decimal point.  It is actually possible to specify a radix for Squeak Float constants.  This is great for teaching about numbers, but may be confusing to the average reader:

	3r20.2 --> 6.66666666666667
	8r20.2 --> 16.25

If you don't have access to the definition of IEEE-754, you can figure out what is going on by printing various simple values in Float hex.  It may help you to know that the basic format is...
	sign		1 bit
	exponent	11 bits with bias of 1023 (16r3FF) to produce an exponent
						in the range -1023 .. +1024
				- 16r000:
					significand = 0: Float zero
					significand ~= 0: Denormalized number (exp = -1024, no hidden '1' bit)
				- 16r7FF:
					significand = 0: Infinity
					significand ~= 0: Not A Number (NaN) representation
	mantissa	53 bits, but only 52 are stored (20 in the first word, 32 in the second).  This is because a normalized mantissa, by definition, has a 1 to the right of its floating point, and IEEE-754 omits this redundant bit to gain an extra bit of precision instead.  People talk about the mantissa without its leading one as the FRACTION, and with its leading 1 as the SIGNFICAND.

The single-precision format is...
	sign		1 bit
	exponent	8 bits, with bias of 127, to represent -126 to +127
                    - 0x0 and 0xFF reserved for Float zero (mantissa is ignored)
                    - 16r7F reserved for Float underflow/overflow (mantissa is ignored)
	mantissa	24 bits, but only 23 are stored
This format is used in FloatArray (qv), and much can be learned from the conversion routines, Float asIEEE32BitWord, and Float class fromIEEE32Bit:.

Thanks to Rich Harmon for asking many questions and to Tim Olson, Bruce Cohen, Rick Zaccone and others for the answers that I have collected here.!
]style[(680 9 1189 21 6 26 149)f1,f1LFloat hex;,f1,f1LFloat asIEEE32BitWord;,f1,f1LFloat class fromIEEE32Bit:;,f1!


!Float methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:54'!
* aNumber 
	"Primitive. Answer the result of multiplying the receiver by aNumber.
	Fail if the argument is not a Float. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 49>
	^ aNumber adaptToFloat: self andSend: #*! !

!Float methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:22'!
+ aNumber 
	"Primitive. Answer the sum of the receiver and aNumber. Essential.
	Fail if the argument is not a Float. See Object documentation
	whatIsAPrimitive."

	<primitive: 41>
	^ aNumber adaptToFloat: self andSend: #+! !

!Float methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:55'!
- aNumber 
	"Primitive. Answer the difference between the receiver and aNumber.
	Fail if the argument is not a Float. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 42>
	^ aNumber adaptToFloat: self andSend: #-! !

!Float methodsFor: 'arithmetic' stamp: 'jm 5/22/2003 19:58'!
/ aNumber 
	"Primitive. Answer the result of dividing receiver by aNumber.
	Fail if the argument is not a Float. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 50>
	aNumber = 0 ifTrue: [^ self error: 'division by 0'].
	^ aNumber adaptToFloat: self andSend: #/! !

!Float methodsFor: 'arithmetic'!
abs
	"This is faster than using Number abs."
	self < 0.0
		ifTrue: [^ 0.0 - self]
		ifFalse: [^ self]! !

!Float methodsFor: 'arithmetic'!
negated
	"Answer a Number that is the negation of the receiver."

	^0.0 - self! !

!Float methodsFor: 'arithmetic'!
reciprocal
	^ 1.0 / self! !


!Float methodsFor: 'mathematical functions'!
arcCos
	"Answer the angle in radians."

	^ Halfpi - self arcSin! !

!Float methodsFor: 'mathematical functions' stamp: 'jsp 2/25/1999 11:15'!
arcSin
	"Answer the angle in radians."

	((self < -1.0) or: [self > 1.0]) ifTrue: [self error: 'Value out of range'].
	((self = -1.0) or: [self = 1.0])
		ifTrue: [^ Halfpi * self]
		ifFalse: [^ (self / (1.0 - (self * self)) sqrt) arcTan]! !

!Float methodsFor: 'mathematical functions'!
arcTan
	"Answer the angle in radians.
	 Optional. See Object documentation whatIsAPrimitive."

	| theta eps step sinTheta cosTheta |
	<primitive: 57>

	"Newton-Raphson"
	self < 0.0 ifTrue: [ ^ 0.0 - (0.0 - self) arcTan ].

	"first guess"
	theta _ (self * Halfpi) / (self + 1.0).

	"iterate"
	eps _ Halfpi * Epsilon.
	step _ theta.
	[(step * step) > eps] whileTrue: [
		sinTheta _ theta sin.
		cosTheta _ theta cos.
		step _ (sinTheta * cosTheta) - (self * cosTheta * cosTheta).
		theta _ theta - step].
	^ theta! !

!Float methodsFor: 'mathematical functions' stamp: 'jsp 3/30/1999 12:38'!
arcTan: denominator
	"Answer the angle in radians.
	 Optional. See Object documentation whatIsAPrimitive."

	| result |

	(self = 0.0) ifTrue: [ (denominator > 0.0) ifTrue: [ result _ 0 ]
										    ifFalse: [ result _ Pi ]
						]
			    ifFalse: [(denominator = 0.0)
					ifTrue: [ (self > 0.0) ifTrue: [ result _ Halfpi ]
												ifFalse: [ result _ Halfpi negated ]
							]
					ifFalse: [ (denominator > 0) ifTrue: [ result _ (self / denominator) arcTan ]
								 ifFalse: [ result _ ((self / denominator) arcTan) + Pi ]
							].
						].
	
	^ result.! !

!Float methodsFor: 'mathematical functions'!
cos
	"Answer the cosine of the receiver taken as an angle in radians."

	^ (self + Halfpi) sin! !

!Float methodsFor: 'mathematical functions'!
degreeCos
	"Answer the cosine of the receiver taken as an angle in degrees."

	^ self degreesToRadians cos! !

!Float methodsFor: 'mathematical functions'!
degreeSin
	"Answer the sine of the receiver taken as an angle in degrees."

	^ self degreesToRadians sin! !

!Float methodsFor: 'mathematical functions'!
exp
	"Answer E raised to the receiver power.
	 Optional. See Object documentation whatIsAPrimitive." 

	| base fract correction delta div |
	<primitive: 59>

	"Taylor series"
	"check the special cases"
	self < 0.0 ifTrue: [^ (self negated exp) reciprocal].
	self = 0.0 ifTrue: [^ 1].
	self abs > MaxValLn ifTrue: [self error: 'exp overflow'].

	"get first approximation by raising e to integer power"
	base _ E raisedToInteger: (self truncated).

	"now compute the correction with a short Taylor series"
	"fract will be 0..1, so correction will be 1..E"
	"in the worst case, convergance time is logarithmic with 1/Epsilon"
	fract _ self fractionPart.
	fract = 0.0 ifTrue: [ ^ base ].  "no correction required"

	correction _ 1.0 + fract.
	delta _ fract * fract / 2.0.
	div _ 2.0.
	[delta > Epsilon] whileTrue: [
		correction _ correction + delta.
		div _ div + 1.0.
		delta _ delta * fract / div].
	correction _ correction + delta.
	^ base * correction! !

!Float methodsFor: 'mathematical functions' stamp: 'jm 3/27/98 06:28'!
floorLog: radix
	"Answer the floor of the log base radix of the receiver."

	^ (self log: radix) floor
! !

!Float methodsFor: 'mathematical functions'!
ln
	"Answer the natural logarithm of the receiver.
	 Optional. See Object documentation whatIsAPrimitive."

	| expt n mant x div pow delta sum eps |
	<primitive: 58>

	"Taylor series"
	self <= 0.0 ifTrue: [self error: 'ln is only defined for x > 0.0'].

	"get a rough estimate from binary exponent"
	expt _ self exponent.
	n _ Ln2 * expt.
	mant _ self timesTwoPower: 0 - expt.

	"compute fine correction from mantinssa in Taylor series"
	"mant is in the range [0..2]"
	"we unroll the loop to avoid use of abs"
	x _ mant - 1.0.
	div _ 1.0.
	pow _ delta _ sum _ x.
	x _ x negated.  "x <= 0"
	eps _ Epsilon * (n abs + 1.0).
	[delta > eps] whileTrue: [
		"pass one: delta is positive"
		div _ div + 1.0.
		pow _ pow * x.
		delta _ pow / div.
		sum _ sum + delta.
		"pass two: delta is negative"
		div _ div + 1.0.
		pow _ pow * x.
		delta _ pow / div.
		sum _ sum + delta].

	^ n + sum

	"2.718284 ln 1.0"! !

!Float methodsFor: 'mathematical functions'!
log
	"Answer the base 10 logarithm of the receiver."

	^ self ln / Ln10! !

!Float methodsFor: 'mathematical functions' stamp: 'RJ 3/15/1999 19:35'!
raisedTo: aNumber
	"Answer the receiver raised to aNumber."

	aNumber isInteger ifTrue:
		["Do the special case of integer power"
		^ self raisedToInteger: aNumber].
	self < 0.0 ifTrue:
		[ self error: self printString, ' raised to a non-integer power' ].
	0.0 = aNumber ifTrue: [^ 1.0].				"special case for exponent = 0.0"
	(self= 0.0) | (aNumber = 1.0) ifTrue: [^ self].	"special case for self = 1.0"
	^ (self ln * aNumber asFloat) exp			"otherwise use logarithms"
! !

!Float methodsFor: 'mathematical functions' stamp: 'tao 4/19/98 23:22'!
reciprocalFloorLog: radix 
	"Quick computation of (self log: radix) floor, when self < 1.0.
	Avoids infinite recursion problems with denormalized numbers"

	| adjust scale n |
	adjust _ 0.
	scale _ 1.0.
	[(n _ radix / (self * scale)) isInfinite]
		whileTrue:
			[scale _ scale * radix.
			adjust _ adjust + 1].
	^ ((n floorLog: radix) + adjust) negated! !

!Float methodsFor: 'mathematical functions' stamp: 'tao 10/15/97 14:23'!
reciprocalLogBase2
	"optimized for self = 10, for use in conversion for printing"

	^ self = 10.0
		ifTrue: [Ln2 / Ln10]
		ifFalse: [Ln2 / self ln]! !

!Float methodsFor: 'mathematical functions'!
sin
	"Answer the sine of the receiver taken as an angle in radians.
	 Optional. See Object documentation whatIsAPrimitive."

	| sum delta self2 i |
	<primitive: 56>

	"Taylor series"
	"normalize to the range [0..Pi/2]"
	self < 0.0 ifTrue: [^ (0.0 - ((0.0 - self) sin))].
	self > Twopi ifTrue: [^ (self \\ Twopi) sin].
	self > Pi ifTrue: [^ (0.0 - (self - Pi) sin)].
	self > Halfpi ifTrue: [^ (Pi - self) sin].

	"unroll loop to avoid use of abs"
	sum _ delta _ self.
	self2 _ 0.0 - (self * self).
	i _ 2.0.
	[delta > Epsilon] whileTrue: [
		"once"
		delta _ (delta * self2) / (i * (i + 1.0)).
		i _ i + 2.0.
		sum _ sum + delta.
		"twice"
		delta _ (delta * self2) / (i * (i + 1.0)).
		i _ i + 2.0.
		sum _ sum + delta].
	^ sum! !

!Float methodsFor: 'mathematical functions'!
sqrt
	"Answer the square root of the receiver.
	 Optional. See Object documentation whatIsAPrimitive."

	| exp guess eps delta |
	<primitive: 55>

	"Newton-Raphson"
	self <= 0.0 ifTrue: [
		self = 0.0
			ifTrue: [^ 0.0]
			ifFalse: [^ self error: 'sqrt is invalid for x < 0']].

	"first guess is half the exponent"
	exp _ self exponent // 2.
	guess _ self timesTwoPower: (0 - exp).

	"get eps value"
	eps _ guess * Epsilon.
	eps _ eps * eps.
	delta _ (self - (guess * guess)) / (guess * 2.0).
	[(delta * delta) > eps] whileTrue: [
		guess _ guess + delta.
		delta _ (self - (guess * guess)) / (guess * 2.0)].
	^ guess! !

!Float methodsFor: 'mathematical functions'!
tan
	"Answer the tangent of the receiver taken as an angle in radians."

	^ self sin / self cos! !

!Float methodsFor: 'mathematical functions'!
timesTwoPower: anInteger 
	"Primitive. Answer with the receiver multiplied by 2.0 raised
	to the power of the argument.
	Optional. See Object documentation whatIsAPrimitive."

	<primitive: 54>

	anInteger < -29 ifTrue: [^ self * (2.0 raisedToInteger: anInteger)].
	anInteger < 0 ifTrue: [^ self / (1 bitShift: (0 - anInteger)) asFloat].
	anInteger < 30 ifTrue: [^ self * (1 bitShift: anInteger) asFloat].
	^ self * (2.0 raisedToInteger: anInteger)! !


!Float methodsFor: 'comparing' stamp: 'di 11/6/1998 13:55'!
< aNumber 
	"Primitive. Compare the receiver with the argument and return true
	if the receiver is less than the argument. Otherwise return false.
	Fail if the argument is not a Float. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 43>
	^ aNumber adaptToFloat: self andSend: #<! !

!Float methodsFor: 'comparing' stamp: 'di 11/6/1998 13:55'!
<= aNumber 
	"Primitive. Compare the receiver with the argument and return true
	if the receiver is less than or equal to the argument. Otherwise return
	false. Fail if the argument is not a Float. Optional. See Object
	documentation whatIsAPrimitive."

	<primitive: 45>
	^ aNumber adaptToFloat: self andSend: #<=! !

!Float methodsFor: 'comparing' stamp: 'di 11/6/1998 13:56'!
= aNumber 
	"Primitive. Compare the receiver with the argument and return true
	if the receiver is equal to the argument. Otherwise return false.
	Fail if the argument is not a Float. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 47>
	aNumber isNumber ifFalse: [^ false].
	^ aNumber adaptToFloat: self andSend: #=! !

!Float methodsFor: 'comparing' stamp: 'di 11/6/1998 13:57'!
> aNumber 
	"Primitive. Compare the receiver with the argument and return true
	if the receiver is greater than the argument. Otherwise return false.
	Fail if the argument is not a Float. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 44>
	^ aNumber adaptToFloat: self andSend: #>! !

!Float methodsFor: 'comparing' stamp: 'di 11/6/1998 13:57'!
>= aNumber 
	"Primitive. Compare the receiver with the argument and return true
	if the receiver is greater than or equal to the argument. Otherwise return
	false. Fail if the argument is not a Float. Optional. See Object documentation 
	whatIsAPrimitive. "

	<primitive: 46>
	^ aNumber adaptToFloat: self andSend: #>! !

!Float methodsFor: 'comparing' stamp: 'jm 4/28/1998 01:04'!
hash
	"Hash is reimplemented because = is implemented. Both words of the float are used; 8 bits are removed from each end to clear most of the exponent regardless of the byte ordering. (The bitAnd:'s ensure that the intermediate results do not become a large integer.) Slower than the original version in the ratios 12:5 to 2:1 depending on values. (DNS, 11 May, 1997)"

	^ (((self basicAt: 1) bitAnd: 16r00FFFF00) +
	   ((self basicAt: 2) bitAnd: 16r00FFFF00)) bitShift: -8
! !

!Float methodsFor: 'comparing'!
~= aNumber 
	"Primitive. Compare the receiver with the argument and return true
	if the receiver is not equal to the argument. Otherwise return false.
	Fail if the argument is not a Float. Optional. See Object documentation
	whatIsAPrimitive."

	<primitive: 48>
	^super ~= aNumber! !


!Float methodsFor: 'testing'!
isFloat
	^ true! !

!Float methodsFor: 'testing' stamp: 'jm 4/30/1998 13:50'!
isInfinite
	"Return true if the receiver is positive or negative infinity."

	^ self = Infinity or: [self = NegativeInfinity]
! !

!Float methodsFor: 'testing'!
isLiteral

	^true! !

!Float methodsFor: 'testing' stamp: 'tao 10/10/97 16:39'!
isNaN
	"simple, byte-order independent test for Not-a-Number"

	^ self ~= self! !

!Float methodsFor: 'testing' stamp: 'ar 6/9/2000 18:56'!
isPowerOfTwo
	"Return true if the receiver is an integral power of two.
	Floats never return true here."
	^false! !

!Float methodsFor: 'testing'!
isZero
	^self = 0.0! !

!Float methodsFor: 'testing' stamp: 'jm 4/28/1998 01:10'!
sign
	"Answer 1 if the receiver is greater than 0, -1 if less than 0, else 0.
	Handle IEEE-754 negative-zero by reporting a sign of -1"

	self > 0 ifTrue: [^ 1].
	(self < 0 or: [((self at: 1) bitShift: -31) = 1]) ifTrue: [^ -1].
	^ 0! !


!Float methodsFor: 'truncation and round off'!
exponent
	"Primitive. Consider the receiver to be represented as a power of two
	multiplied by a mantissa (between one and two). Answer with the
	SmallInteger to whose power two is raised. Optional. See Object
	documentation whatIsAPrimitive."

	| positive |
	<primitive: 53>
	self >= 1.0 ifTrue: [^self floorLog: 2].
	self > 0.0
		ifTrue: 
			[positive _ (1.0 / self) exponent.
			self = (1.0 / (1.0 timesTwoPower: positive))
				ifTrue: [^positive negated]
				ifFalse: [^positive negated - 1]].
	self = 0.0 ifTrue: [^-1].
	^self negated exponent! !

!Float methodsFor: 'truncation and round off'!
fractionPart
	"Primitive. Answer a Float whose value is the difference between the 
	receiver and the receiver's asInteger value. Optional. See Object 
	documentation whatIsAPrimitive."

	<primitive: 52>
	^self - self truncated asFloat! !

!Float methodsFor: 'truncation and round off'!
integerPart
	"Answer a Float whose value is the receiver's truncated value."

	^self - self fractionPart! !

!Float methodsFor: 'truncation and round off' stamp: 'jm 11/21/2008 12:42'!
rounded
	"Answer the integer nearest the receiver."

	self isNaN ifTrue: [^ self].
	self isInf ifTrue: [^ self].
	self >= 0.0
		ifTrue: [^ (self + 0.5) truncated]
		ifFalse: [^ (self - 0.5) truncated].
! !

!Float methodsFor: 'truncation and round off' stamp: 'tao 4/19/98 13:14'!
significand

	^ self timesTwoPower: (self exponent negated)! !

!Float methodsFor: 'truncation and round off' stamp: 'tao 4/19/98 14:27'!
significandAsInteger

	| exp sig |
	exp _ self exponent.
	sig _ (((self at: 1) bitAnd: 16r000FFFFF) bitShift: 32) bitOr: (self at: 2).
	exp > -1023
		ifTrue: [sig _ sig bitOr: (1 bitShift: 52)].
	^ sig.! !

!Float methodsFor: 'truncation and round off' stamp: 'di 7/1/1998 23:01'!
truncated
	"Answer with a SmallInteger equal to the value of the receiver without 
	its fractional part. The primitive fails if the truncated value cannot be 
	represented as a SmallInteger. In that case, the code below will compute 
	a LargeInteger truncated value.
	Essential. See Object documentation whatIsAPrimitive. "

	<primitive: 51>
	(self isInfinite or: [self isNaN]) ifTrue: [self error: 'Cannot truncate this number'].

	self abs < 2.0e16
		ifTrue: ["Fastest way when it may not be an integer"
				^ (self quo: 1073741823.0) * 1073741823 + (self rem: 1073741823.0) truncated]
		ifFalse: [^ self asTrueFraction.  "Extract all bits of the mantissa and shift if necess"]! !


!Float methodsFor: 'converting' stamp: 'di 11/6/1998 13:38'!
adaptToFraction: rcvr andSend: selector
	"If I am involved in arithmetic with a Fraction, convert it to a Float."
	^ rcvr asFloat perform: selector with: self! !

!Float methodsFor: 'converting' stamp: 'di 11/6/1998 13:07'!
adaptToInteger: rcvr andSend: selector
	"If I am involved in arithmetic with an Integer, convert it to a Float."
	^ rcvr asFloat perform: selector with: self! !

!Float methodsFor: 'converting'!
asApproximateFraction
	"Answer a Fraction approximating the receiver. This conversion uses the 
	continued fraction method to approximate a floating point number."

	| num1 denom1 num2 denom2 int frac newD temp |
	num1 _ self asInteger.	"The first of two alternating numerators"
	denom1 _ 1.		"The first of two alternating denominators"
	num2 _ 1.		"The second numerator"
	denom2 _ 0.		"The second denominator--will update"
	int _ num1.		"The integer part of self"
	frac _ self fractionPart.		"The fractional part of self"
	[frac = 0]
		whileFalse: 
			["repeat while the fractional part is not zero"
			newD _ 1.0 / frac.			"Take reciprocal of the fractional part"
			int _ newD asInteger.		"get the integer part of this"
			frac _ newD fractionPart.	"and save the fractional part for next time"
			temp _ num2.				"Get old numerator and save it"
			num2 _ num1.				"Set second numerator to first"
			num1 _ num1 * int + temp.	"Update first numerator"
			temp _ denom2.				"Get old denominator and save it"
			denom2 _ denom1.			"Set second denominator to first"
			denom1 _ int * denom1 + temp.		"Update first denominator"
			10000000000.0 < denom1
				ifTrue: 
					["Is ratio past float precision?  If so, pick which 
					of the two ratios to use"
					num2 = 0.0 
						ifTrue: ["Is second denominator 0?"
								^ Fraction numerator: num1 denominator: denom1].
					^ Fraction numerator: num2 denominator: denom2]].
	"If fractional part is zero, return the first ratio"
	denom1 = 1
		ifTrue: ["Am I really an Integer?"
				^ num1 "Yes, return Integer result"]
		ifFalse: ["Otherwise return Fraction result"
				^ Fraction numerator: num1 denominator: denom1]! !

!Float methodsFor: 'converting'!
asFloat
	"Answer the receiver itself."

	^self! !

!Float methodsFor: 'converting' stamp: 'sma 5/3/2000 21:46'!
asFraction
	^ self asTrueFraction ! !

!Float methodsFor: 'converting' stamp: 'di 2/8/1999 12:51'!
asIEEE32BitWord
	"Convert the receiver into a 32 bit Integer value representing the same number in IEEE 32 bit format. Used for conversion in FloatArrays only."
	| word1 word2 sign mantissa exponent destWord |
	self = 0.0 ifTrue:[^0].
	word1 _ self basicAt: 1.
	word2 _ self basicAt: 2.
	mantissa _ (word2 bitShift: -29) + ((word1 bitAnd:  16rFFFFF) bitShift: 3).
	exponent _ ((word1 bitShift: -20) bitAnd: 16r7FF) - 1023 + 127.
	exponent < 0 ifTrue:[^0]. "Underflow"
	exponent > 254 ifTrue:["Overflow"
		exponent _ 255.
		mantissa _ 0].
	sign _ word1 bitAnd: 16r80000000.
	destWord _ (sign bitOr: (exponent bitShift: 23)) bitOr: mantissa.
	^ destWord! !

!Float methodsFor: 'converting' stamp: 'di 7/1/1998 22:20'!
asTrueFraction
	" Answer a fraction that EXACTLY represents self,
	  a double precision IEEE floating point number.
	  Floats are stored in the same form on all platforms.
	  (Does not handle gradual underflow or NANs.)
	  By David N. Smith with significant performance
	  improvements by Luciano Esteban Notarfrancesco.
	  (Version of 11April97)"
	| shifty sign expPart exp fraction fractionPart result zeroBitsCount |
	self isInfinite ifTrue: [self error: 'Cannot represent infinity as a fraction'].
	self isNaN ifTrue: [self error: 'Cannot represent Not-a-Number as a fraction'].

	" Extract the bits of an IEEE double float "
	shifty := ((self basicAt: 1) bitShift: 32) + (self basicAt: 2).

	" Extract the sign and the biased exponent "
	sign := (shifty bitShift: -63) = 0 ifTrue: [1] ifFalse: [-1].
	expPart := (shifty bitShift: -52) bitAnd: 16r7FF.

	" Extract fractional part; answer 0 if this is a true 0.0 value "
	fractionPart := shifty bitAnd:  16r000FFFFFFFFFFFFF.
	( expPart=0 and: [ fractionPart=0 ] ) ifTrue: [ ^ 0  ].

	" Replace omitted leading 1 in fraction "
	fraction := fractionPart bitOr: 16r0010000000000000.

	"Unbias exponent: 16r3FF is bias; 52 is fraction width"
	exp := 16r3FF + 52 - expPart.

	" Form the result. When exp>52, the exponent is adjusted by
	  the number of trailing zero bits in the fraction to minimize
	  the (huge) time otherwise spent in #gcd:. "
	exp negative
		ifTrue: [
			result := sign * fraction bitShift: exp negated ]
		ifFalse:	[
			zeroBitsCount _ fraction lowBit - 1.
			exp := exp - zeroBitsCount.
			exp <= 0
				ifTrue: [
					zeroBitsCount := zeroBitsCount + exp.
					"exp := 0."   " Not needed; exp not
refernced again "
					result := sign * fraction bitShift:
zeroBitsCount negated ]
				ifFalse: [
					result := Fraction
						numerator: (sign * fraction
bitShift: zeroBitsCount negated)
						denominator: (1 bitShift:
exp) ] ].

	"Low cost validation omitted after extensive testing"
	"(result asFloat = self) ifFalse: [self error: 'asTrueFraction validation failed']."
	^ result ! !

!Float methodsFor: 'converting'!
degreesToRadians
	"Answer the receiver in radians. Assumes the receiver is in degrees."

	^self * RadiansPerDegree! !

!Float methodsFor: 'converting' stamp: 'jm 10/31/2007 20:13'!
isInf

	^ self = Infinity or: [self = NegativeInfinity]! !

!Float methodsFor: 'converting'!
radiansToDegrees
	"Answer the receiver in degrees. Assumes the receiver is in radians."

	^self / RadiansPerDegree! !


!Float methodsFor: 'copying'!
deepCopy

	^self copy! !

!Float methodsFor: 'copying'!
shallowCopy

	^self + 0.0! !


!Float methodsFor: 'printing' stamp: 'jm 10/26/2007 10:08'!
absFixedPrintBase10On: aStream
	"Like absPrintExactlyOn:base: but (a) always base 10 and (b) never uses expontential notation."

	| base fBase significand exp baseExpEstimate be be1 r s mPlus mMinus scale roundingIncludesLimits d tc1 tc2 decPointCount |
	self isInfinite ifTrue: [aStream nextPutAll: 'Infinity'. ^ self].
	base _ 10.
	fBase _ base asFloat.
	significand _ self significandAsInteger.
	roundingIncludesLimits _ significand even.
	exp _ (self exponent - 52) max: MinValLogBase2.
	baseExpEstimate _ (self exponent * fBase reciprocalLogBase2 - 1.0e-10) ceiling.
	exp >= 0
		ifTrue:
			[be _ 1 << exp.
			significand ~= 16r10000000000000
				ifTrue:
					[r _ significand * be * 2.
					s _ 2.
					mPlus _ be.
					mMinus _ be]
				ifFalse:
					[be1 _ be * 2.
					r _ significand * be1 * 2.
					s _ 4.
					mPlus _ be1.
					mMinus _ be]]
		ifFalse:
			[(exp = MinValLogBase2) | (significand ~= 16r10000000000000)
				ifTrue:
					[r _ significand * 2.
					s _ (1 << (exp negated)) * 2.
					mPlus _ 1.
					mMinus _ 1]
				ifFalse:
					[r _ significand * 4.
					s _ (1 << (exp negated + 1)) * 2.
					mPlus _ 2.
					mMinus _ 1]].
	baseExpEstimate >= 0
		ifTrue: [s _ s * (base raisedToInteger: baseExpEstimate)]
		ifFalse:
			[scale _ base raisedToInteger: baseExpEstimate negated.
			r _ r * scale.
			mPlus _ mPlus * scale.
			mMinus _ mMinus * scale].
	(r + mPlus > s) | (roundingIncludesLimits & (r + mPlus = s))
		ifTrue: [baseExpEstimate _ baseExpEstimate + 1]
		ifFalse:
			[r _ r * base.
			mPlus _ mPlus * base.
			mMinus _ mMinus * base].

	decPointCount _ baseExpEstimate.
	baseExpEstimate <= 0 ifTrue: [
		aStream nextPutAll: '0.'.
		baseExpEstimate negated timesRepeat: [aStream nextPut: $0]].

	[d _ r // s.
	r _ r \\ s.
	(tc1 _ (r < mMinus) | (roundingIncludesLimits & (r = mMinus))) |
	(tc2 _ (r + mPlus > s) | (roundingIncludesLimits & (r + mPlus = s)))] whileFalse:
		[aStream nextPut: (Character digitValue: d).
		r _ r * base.
		mPlus _ mPlus * base.
		mMinus _ mMinus * base.
		decPointCount _ decPointCount - 1.
		decPointCount = 0 ifTrue: [aStream nextPut: $.]].
	tc2 ifTrue:
		[tc1 not | (tc1 & (r*2 >= s)) ifTrue: [d _ d + 1]].
	aStream nextPut: (Character digitValue: d).
	decPointCount > 0
		ifTrue:
		[decPointCount - 1 to: 1 by: -1 do: [:i | aStream nextPut: $0].
		aStream nextPutAll: '.0'].
! !

!Float methodsFor: 'printing' stamp: 'tao 4/19/98 23:21'!
absPrintExactlyOn: aStream base: base
	"Print my value on a stream in the given base.  Assumes that my value is strictly
	positive; negative numbers, zero, and NaNs have already been handled elsewhere.
	Based upon the algorithm outlined in:
	Robert G. Burger and R. Kent Dybvig
	Printing Floating Point Numbers Quickly and Accurately
	ACM SIGPLAN 1996 Conference on Programming Language Design and Implementation
	June 1996.
	This version guarantees that the printed representation exactly represents my value
	by using exact integer arithmetic."

	| fBase significand exp baseExpEstimate be be1 r s mPlus mMinus scale roundingIncludesLimits d tc1 tc2 fixedFormat decPointCount |
	self isInfinite ifTrue: [aStream nextPutAll: 'Infinity'. ^ self].
	fBase _ base asFloat.
	significand _ self significandAsInteger.
	roundingIncludesLimits _ significand even.
	exp _ (self exponent - 52) max: MinValLogBase2.
	baseExpEstimate _ (self exponent * fBase reciprocalLogBase2 - 1.0e-10) ceiling.
	exp >= 0
		ifTrue:
			[be _ 1 << exp.
			significand ~= 16r10000000000000
				ifTrue:
					[r _ significand * be * 2.
					s _ 2.
					mPlus _ be.
					mMinus _ be]
				ifFalse:
					[be1 _ be * 2.
					r _ significand * be1 * 2.
					s _ 4.
					mPlus _ be1.
					mMinus _ be]]
		ifFalse:
			[(exp = MinValLogBase2) | (significand ~= 16r10000000000000)
				ifTrue:
					[r _ significand * 2.
					s _ (1 << (exp negated)) * 2.
					mPlus _ 1.
					mMinus _ 1]
				ifFalse:
					[r _ significand * 4.
					s _ (1 << (exp negated + 1)) * 2.
					mPlus _ 2.
					mMinus _ 1]].
	baseExpEstimate >= 0
		ifTrue: [s _ s * (base raisedToInteger: baseExpEstimate)]
		ifFalse:
			[scale _ base raisedToInteger: baseExpEstimate negated.
			r _ r * scale.
			mPlus _ mPlus * scale.
			mMinus _ mMinus * scale].
	(r + mPlus > s) | (roundingIncludesLimits & (r + mPlus = s))
		ifTrue: [baseExpEstimate _ baseExpEstimate + 1]
		ifFalse:
			[r _ r * base.
			mPlus _ mPlus * base.
			mMinus _ mMinus * base].
	(fixedFormat _ baseExpEstimate between: -3 and: 6)
		ifTrue:
			[decPointCount _ baseExpEstimate.
			baseExpEstimate <= 0
				ifTrue: [aStream nextPutAll: ('0.000000' truncateTo: 2 - baseExpEstimate)]]
		ifFalse:
			[decPointCount _ 1]. 
	[d _ r // s.
	r _ r \\ s.
	(tc1 _ (r < mMinus) | (roundingIncludesLimits & (r = mMinus))) |
	(tc2 _ (r + mPlus > s) | (roundingIncludesLimits & (r + mPlus = s)))] whileFalse:
		[aStream nextPut: (Character digitValue: d).
		r _ r * base.
		mPlus _ mPlus * base.
		mMinus _ mMinus * base.
		decPointCount _ decPointCount - 1.
		decPointCount = 0 ifTrue: [aStream nextPut: $.]].
	tc2 ifTrue:
		[tc1 not | (tc1 & (r*2 >= s)) ifTrue: [d _ d + 1]].
	aStream nextPut: (Character digitValue: d).
	decPointCount > 0
		ifTrue:
		[decPointCount - 1 to: 1 by: -1 do: [:i | aStream nextPut: $0].
		aStream nextPutAll: '.0'].
	fixedFormat ifFalse:
		[aStream nextPut: $e.
		aStream nextPutAll: (baseExpEstimate - 1) printString]! !

!Float methodsFor: 'printing' stamp: 'tao 4/22/98 11:58'!
absPrintOn: aStream base: base
	"Print my value on a stream in the given base.  Assumes that my value is strictly
	positive; negative numbers, zero, and NaNs have already been handled elsewhere.
	Based upon the algorithm outlined in:
	Robert G. Burger and R. Kent Dybvig
	Printing Floating Point Numbers Quickly and Accurately
	ACM SIGPLAN 1996 Conference on Programming Language Design and Implementation
	June 1996.
	This version performs all calculations with Floats instead of LargeIntegers, and loses
	about 3 lsbs of accuracy compared to an exact conversion."

	| significantBits fBase exp baseExpEstimate r s mPlus mMinus scale d tc1 tc2 fixedFormat decPointCount |
	self isInfinite ifTrue: [aStream nextPutAll: 'Infinity'. ^ self].
	significantBits _ 50.  "approximately 3 lsb's of accuracy loss during conversion"
	fBase _ base asFloat.
	exp _ self exponent.
	baseExpEstimate _ (exp * fBase reciprocalLogBase2 - 1.0e-10) ceiling.
	exp >= 0
		ifTrue:
			[r _ self.
			s _ 1.0.
			mPlus _ 1.0 timesTwoPower: exp - significantBits.
			mMinus _ self significand ~= 1.0 ifTrue: [mPlus] ifFalse: [mPlus / 2.0]]
		ifFalse:
			[r _ self timesTwoPower: significantBits.
			s _ 1.0 timesTwoPower:  significantBits.
			mMinus _ 1.0 timesTwoPower: (exp max: -1024).
			mPlus _
				(exp = MinValLogBase2) | (self significand ~= 1.0)
					ifTrue: [mMinus]
					ifFalse: [mMinus * 2.0]].
	baseExpEstimate >= 0
		ifTrue:
			[s _ s * (fBase raisedToInteger: baseExpEstimate).
			exp = 1023
				ifTrue:   "scale down to prevent overflow to Infinity during conversion"
					[r _ r / fBase.
					s _ s / fBase.
					mPlus _ mPlus / fBase.
					mMinus _ mMinus / fBase]]
		ifFalse:
			[exp < -1023
				ifTrue:   "scale up to prevent denorm reciprocals overflowing to Infinity"
					[d _ (53 * fBase reciprocalLogBase2 - 1.0e-10) ceiling.
					scale _ fBase raisedToInteger: d.
					r _ r * scale.
					mPlus _ mPlus * scale.
					mMinus _ mMinus * scale.
					scale _ fBase raisedToInteger: (baseExpEstimate + d) negated]
				ifFalse:
				[scale _ fBase raisedToInteger: baseExpEstimate negated].
			s _ s / scale].
	(r + mPlus >= s)
		ifTrue: [baseExpEstimate _ baseExpEstimate + 1]
		ifFalse:
			[s _ s / fBase].
	(fixedFormat _ baseExpEstimate between: -3 and: 6)
		ifTrue:
			[decPointCount _ baseExpEstimate.
			baseExpEstimate <= 0
				ifTrue: [aStream nextPutAll: ('0.000000' truncateTo: 2 - baseExpEstimate)]]
		ifFalse:
			[decPointCount _ 1].
	[d _ (r / s) truncated.
	r _ r - (d * s).
	(tc1 _ r <= mMinus) | (tc2 _ r + mPlus >= s)] whileFalse:
		[aStream nextPut: (Character digitValue: d).
		r _ r * fBase.
		mPlus _ mPlus * fBase.
		mMinus _ mMinus * fBase.
		decPointCount _ decPointCount - 1.
		decPointCount = 0 ifTrue: [aStream nextPut: $.]].
	tc2 ifTrue:
		[tc1 not | (tc1 & (r*2.0 >= s)) ifTrue: [d _ d + 1]].
	aStream nextPut: (Character digitValue: d).
	decPointCount > 0
		ifTrue:
		[decPointCount - 1 to: 1 by: -1 do: [:i | aStream nextPut: $0].
		aStream nextPutAll: '.0'].
	fixedFormat ifFalse:
		[aStream nextPut: $e.
		aStream nextPutAll: (baseExpEstimate - 1) printString]! !

!Float methodsFor: 'printing'!
hex  "If ya really want to know..."
	| word nibble |
	^ String streamContents:
		[:strm |
		1 to: 2 do:
			[:i | word _ self at: i.
			1 to: 8 do: 
				[:s | nibble _ (word bitShift: -8+s*4) bitAnd: 16rF.
				strm nextPut: ('0123456789ABCDEF' at: nibble+1)]]]
"
(-2.0 to: 2.0) collect: [:f | f hex]
"! !

!Float methodsFor: 'printing' stamp: 'tao 4/19/98 23:31'!
printOn: aStream base: base
	"Handle sign, zero, and NaNs; all other values passed to absPrintOn:base:" 

	self isNaN ifTrue: [aStream nextPutAll: 'NaN'. ^ self]. "check for NaN before sign"
	self > 0.0
		ifTrue: [self absPrintOn: aStream base: base]
		ifFalse:
			[self sign = -1
				ifTrue: [aStream nextPutAll: '-'].
			self = 0.0
				ifTrue: [aStream nextPutAll: '0.0'. ^ self]
				ifFalse: [self negated absPrintOn: aStream base: base]]! !

!Float methodsFor: 'printing' stamp: 'jm 10/26/2007 09:59'!
printStringNoExponent
	"Answer a printed representation of me that does not use exponential notation."

	| s |
	self isNaN ifTrue: [^ 'NaN']. "check for NaN before sign"
	self = 0.0 ifTrue: [^ '0.0'].
	s _ WriteStream on: (String new: 100).
	self > 0.0
		ifTrue: [self absFixedPrintBase10On: s]
		ifFalse: [
			s nextPutAll: '-'.
			self negated absFixedPrintBase10On: s].

	^ s contents
! !


!Float methodsFor: 'private' stamp: 'ls 10/10/1999 11:55'!
absPrintOn: aStream base: base digitCount: digitCount 
	"Print me in the given base, using digitCount significant figures."

	| fuzz x exp q fBase scale logScale xi |
	self isInf ifTrue: [^ aStream nextPutAll: 'Inf'].
	fBase _ base asFloat.
	"x is myself normalized to [1.0, fBase), exp is my exponent"
	exp _ 
		self < 1.0
			ifTrue: [self reciprocalFloorLog: fBase]
			ifFalse: [self floorLog: fBase].
	scale _ 1.0.
	logScale _ 0.
	[(x _ fBase raisedTo: (exp + logScale)) = 0]
		whileTrue:
			[scale _ scale * fBase.
			logScale _ logScale + 1].
	x _ self * scale / x.
	fuzz _ fBase raisedTo: 1 - digitCount.
	"round the last digit to be printed"
	x _ 0.5 * fuzz + x.
	x >= fBase
		ifTrue: 
			["check if rounding has unnormalized x"
			x _ x / fBase.
			exp _ exp + 1].
	(exp < 6 and: [exp > -4])
		ifTrue: 
			["decimal notation"
			q _ 0.
			exp < 0 ifTrue: [1 to: 1 - exp do: [:i | aStream nextPut: ('0.0000'
at: i)]]]
		ifFalse: 
			["scientific notation"
			q _ exp.
			exp _ 0].
	[x >= fuzz]
		whileTrue: 
			["use fuzz to track significance"
			xi _ x asInteger.
			aStream nextPut: (Character digitValue: xi).
			x _ x - xi asFloat * fBase.
			fuzz _ fuzz * fBase.
			exp _ exp - 1.
			exp = -1 ifTrue: [aStream nextPut: $.]].
	[exp >= -1]
		whileTrue: 
			[aStream nextPut: $0.
			exp _ exp - 1.
			exp = -1 ifTrue: [aStream nextPut: $.]].
	q ~= 0
		ifTrue: 
			[aStream nextPut: $e.
			q printOn: aStream]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Float class
	instanceVariableNames: ''!

!Float class methodsFor: 'class initialization' stamp: 'jm 4/30/1998 13:48'!
initialize
	"Float initialize"
	"Constants from Computer Approximations, pp. 182-183:
		Pi = 3.14159265358979323846264338327950288
		Pi/2 = 1.57079632679489661923132169163975144
		Pi*2 = 6.28318530717958647692528676655900576
		Pi/180 = 0.01745329251994329576923690768488612
		2.0 ln = 0.69314718055994530941723212145817657
		2.0 sqrt = 1.41421356237309504880168872420969808"

	Pi _ 3.14159265358979323846264338327950288.
	Halfpi _ Pi / 2.0.
	Twopi _ Pi * 2.0.
	RadiansPerDegree _ Pi / 180.0.

	Ln2 _ 0.69314718055994530941723212145817657.
	Ln10 _ 10.0 ln.
	Sqrt2 _ 1.41421356237309504880168872420969808.
	E _ 2.718281828459045235360287471353.

	Epsilon _ 0.000000000001.  "Defines precision of mathematical functions"

	MaxVal _ 1.7976931348623159e308.
	MaxValLn _ 709.782712893384.
	MinValLogBase2 _ -1074.

	Infinity _ MaxVal * MaxVal.
	NegativeInfinity _ 0.0 - Infinity.
	NaN _ Infinity - Infinity.
	NegativeZero _ 1.0 / Infinity negated.
! !


!Float class methodsFor: 'instance creation' stamp: 'di 2/8/1999 12:58'!
fromIEEE32Bit: word
	"Convert the given 32 bit word (which is supposed to be a positive 32bit value) from a 32bit IEEE floating point representation into an actual Squeak float object (being 64bit wide). Should only be used for conversion in FloatArrays or likewise objects."
	| sign mantissa exponent newFloat |
	word negative ifTrue: [^ self error:'Cannot deal with negative numbers'].
	word = 0 ifTrue:[^ 0.0].
	mantissa _ word bitAnd:  16r7FFFFF.
	exponent _ ((word bitShift: -23) bitAnd: 16rFF) - 127.
	sign _ word bitAnd: 16r80000000.

	exponent = 128 ifTrue:["Either NAN or INF"
		mantissa = 0 ifFalse:[^ Float nan].
		sign = 0 
			ifTrue:[^ Float infinity]
			ifFalse:[^ Float infinity negated]].

	"Create new float"
	newFloat _ self new: 2.
	newFloat basicAt: 1 put: ((sign bitOr: (1023 + exponent bitShift: 20)) bitOr: (mantissa bitShift: -3)).
	newFloat basicAt: 2 put: ((mantissa bitAnd: 7) bitShift: 29).
	^newFloat! !

!Float class methodsFor: 'instance creation'!
readFrom: aStream 
	"Answer a new Float as described on the stream, aStream."

	^(super readFrom: aStream) asFloat! !


!Float class methodsFor: 'constants'!
e
	"Answer the constant, E."

	^E! !

!Float class methodsFor: 'constants' stamp: 'sw 10/8/1999 22:59'!
halfPi
	^ Halfpi! !

!Float class methodsFor: 'constants' stamp: 'tao 4/23/98 11:37'!
infinity
	"Answer the value used to represent an infinite magnitude"

	^ Infinity! !

!Float class methodsFor: 'constants' stamp: 'tao 4/23/98 11:38'!
nan
	"Answer the canonical value used to represent Not-A-Number"

	^ NaN! !

!Float class methodsFor: 'constants' stamp: 'tao 4/23/98 12:05'!
negativeZero

	^ NegativeZero! !

!Float class methodsFor: 'constants'!
pi
	"Answer the constant, Pi."

	^Pi! !



Number subclass: #Integer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel-Numbers'!
!Integer commentStamp: '<historical>' prior: 0!
I am a common abstract superclass for all Integer implementations. My implementation subclasses are SmallInteger, LargePositiveInteger, and LargeNegativeInteger.
	
Integer division consists of:
	/	exact division, answers a fraction if result is not a whole integer
	//	answers an Integer, rounded towards negative infinity
	\\	is modulo rounded towards negative infinity
	quo: truncated division, rounded towards zero!


!Integer methodsFor: 'testing'!
even 
	"Refer to the comment in Number|even."

	^((self digitAt: 1) bitAnd: 1) = 0! !

!Integer methodsFor: 'testing'!
isInteger
	"True for all subclasses of Integer."

	^ true! !

!Integer methodsFor: 'testing' stamp: 'ar 6/9/2000 18:56'!
isPowerOfTwo
	"Return true if the receiver is an integral power of two."
	^ (self bitAnd: self-1) = 0! !

!Integer methodsFor: 'testing' stamp: 'jm 6/29/2008 12:04'!
isSeparator
	"Answer true if I am a Unicode separator character."

	^ #(32 "space"
		13 "cr"
		9 "tab"
		10 "line feed"
		12 "form feed") includes: self
! !


!Integer methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:59'!
* aNumber
	"Refer to the comment in Number * " 
	aNumber isInteger ifTrue:
		[^ self digitMultiply: aNumber 
					neg: self negative ~~ aNumber negative].
	^ aNumber adaptToInteger: self andSend: #*! !

!Integer methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:59'!
+ aNumber
	"Refer to the comment in Number + "
	aNumber isInteger ifTrue:
		[self negative == aNumber negative
			ifTrue: [^ (self digitAdd: aNumber) normalize]
			ifFalse: [^ self digitSubtract: aNumber]].
	^ aNumber adaptToInteger: self andSend: #+! !

!Integer methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:59'!
- aNumber
	"Refer to the comment in Number - "
	aNumber isInteger ifTrue:
		[self negative == aNumber negative
			ifTrue: [^ self digitSubtract: aNumber]
			ifFalse: [^ (self digitAdd: aNumber) normalize]].
	^ aNumber adaptToInteger: self andSend: #-! !

!Integer methodsFor: 'arithmetic' stamp: 'jm 9/5/2006 18:38'!
/ aNumber
	"Refer to the comment in Number / "

	| quoRem |
	aNumber isInteger ifTrue:
		[quoRem _ self digitDiv: aNumber abs	"*****I've added abs here*****"
						neg: self negative ~~ aNumber negative.
		(quoRem at: 2) = 0
			ifTrue: [^ (quoRem at: 1) normalize]
			ifFalse: [^ self asFloat / aNumber]].
	^ aNumber adaptToInteger: self andSend: #/
! !

!Integer methodsFor: 'arithmetic'!
// aNumber

	| q |
	aNumber = 0 ifTrue: [^self error: 'division by 0'].
	self = 0 ifTrue: [^0].
	q _ self quo: aNumber 
	"Refer to the comment in Number|//.".
	(q negative
		ifTrue: [q * aNumber ~= self]
		ifFalse: [q = 0 and: [self negative ~= aNumber negative]])
		ifTrue: [^q - 1"Truncate towards minus infinity"]
		ifFalse: [^q]! !

!Integer methodsFor: 'arithmetic'!
alignedTo: anInteger
	"Answer the smallest number not less than receiver that is a multiple of anInteger."

	^(self+anInteger-1//anInteger)*anInteger

"5 alignedTo: 2"
"12 alignedTo: 3"! !

!Integer methodsFor: 'arithmetic' stamp: 'di 11/6/1998 14:00'!
quo: aNumber 
	"Refer to the comment in Number quo: "
	| ng quo |
	aNumber isInteger ifTrue: 
		[ng _ self negative == aNumber negative == false.
		quo _ (self digitDiv:
			(aNumber class == SmallInteger
				ifTrue: [aNumber abs]
				ifFalse: [aNumber])
			neg: ng) at: 1.
		^ quo normalize].
	^ aNumber adaptToInteger: self andSend: #quo:! !


!Integer methodsFor: 'comparing' stamp: 'di 11/6/1998 14:00'!
< aNumber
	aNumber isInteger ifTrue:
		[self negative == aNumber negative
			ifTrue: [self negative
						ifTrue: [^ (self digitCompare: aNumber) > 0]
						ifFalse: [^ (self digitCompare: aNumber) < 0]]
			ifFalse: [^ self negative]].
	^ aNumber adaptToInteger: self andSend: #<! !

!Integer methodsFor: 'comparing' stamp: 'di 11/6/1998 14:00'!
= aNumber
	aNumber isNumber ifFalse: [^ false].
	aNumber isInteger ifTrue:
		[aNumber negative == self negative
			ifTrue: [^ (self digitCompare: aNumber) = 0]
			ifFalse: [^ false]].
	^ aNumber adaptToInteger: self andSend: #=! !

!Integer methodsFor: 'comparing' stamp: 'di 11/6/1998 14:00'!
> aNumber
	aNumber isInteger ifTrue:
		[self negative == aNumber negative
			ifTrue: [self negative
						ifTrue: [^(self digitCompare: aNumber) < 0]
						ifFalse: [^(self digitCompare: aNumber) > 0]]
			ifFalse: [^ aNumber negative]].
	^ aNumber adaptToInteger: self andSend: #>! !

!Integer methodsFor: 'comparing'!
hash
	"Hash is reimplemented because = is implemented."

	^(self lastDigit bitShift: 8) + (self digitAt: 1)! !


!Integer methodsFor: 'truncation and round off' stamp: 'sma 5/12/2000 12:35'!
atRandom: aGenerator
	"Answer a random integer from 1 to self picked from aGenerator."

	^ aGenerator nextInt: self! !

!Integer methodsFor: 'truncation and round off'!
ceiling 
	"Refer to the comment in Number|ceiling."! !

!Integer methodsFor: 'truncation and round off'!
floor 
	"Refer to the comment in Number|floor."! !

!Integer methodsFor: 'truncation and round off'!
normalize 
	"SmallInts OK; LgInts override"
	^ self! !

!Integer methodsFor: 'truncation and round off'!
rounded 
	"Refer to the comment in Number|rounded."! !

!Integer methodsFor: 'truncation and round off'!
truncated 
	"Refer to the comment in Number|truncated."! !


!Integer methodsFor: 'enumerating'!
timesRepeat: aBlock 
	"Evaluate the argument, aBlock, the number of times represented by the 
	receiver."

	| count |
	count _ 1.
	[count <= self]
		whileTrue: 
			[aBlock value.
			count _ count + 1]! !


!Integer methodsFor: 'mathematical functions'!
degreeCos
	"Answer the cosine of the receiver taken as an angle in degrees."

	^ (90 + self) degreeSin! !

!Integer methodsFor: 'mathematical functions'!
degreeSin
	"Answer the sine of the receiver taken as an angle in degrees."

	^ self asFloat degreesToRadians sin! !

!Integer methodsFor: 'mathematical functions' stamp: 'di 4/22/1998 14:45'!
factorial
	"Answer the factorial of the receiver."

	self = 0 ifTrue: [^ 1].
	self > 0 ifTrue: [^ self * (self - 1) factorial].
	self error: 'Not valid for negative integers'! !

!Integer methodsFor: 'mathematical functions' stamp: 'LC 6/17/1998 19:22'!
gcd: anInteger
	"See Knuth, Vol 2, 4.5.2, Algorithm L"
	"Initialize"
	| higher u v k uHat vHat a b c d vPrime vPrimePrime q t |
	higher _ SmallInteger maxVal highBit.
	u _ self abs max: (v _ anInteger abs).
	v _ self abs min: v.
	[v class == SmallInteger]
		whileFalse: 
			[(uHat _ u bitShift: (k _ higher - u highBit)) class == SmallInteger
				ifFalse: 
					[k _ k - 1.
					uHat _ uHat bitShift: -1].
			vHat _ v bitShift: k.
			a _ 1.
			b _ 0.
			c _ 0.
			d _ 1.
			"Test quotient"
			[(vPrime _ vHat + d) ~= 0
				and: [(vPrimePrime _ vHat + c) ~= 0 and: [(q _ uHat + a // vPrimePrime) = (uHat + b // vPrime)]]]
				whileTrue: 
					["Emulate Euclid"
					c _ a - (q * (a _ c)).
					d _ b - (q * (b _ d)).
					vHat _ uHat - (q * (uHat _ vHat))].
			"Multiprecision step"
			b = 0
				ifTrue: 
					[v _ u rem: (u _ v)]
				ifFalse: 
					[t _ u * a + (v * b).
					v _ u * c + (v * d).
					u _ t]].
	^ v gcd: u! !

!Integer methodsFor: 'mathematical functions'!
lcm: n 
	"Answer the least common multiple of the receiver and n."

	^self // (self gcd: n) * n! !

!Integer methodsFor: 'mathematical functions' stamp: 'tk 7/30/97 13:08'!
take: kk
	"Return the number of combinations of (self) elements taken kk at a time.  For 6 take 3, this is 6*5*4 / (1*2*3).  Zero outside of Pascal's triangle.  Use a trick to go faster."
	" 6 take: 3  "

	| num denom |
	kk < 0 ifTrue: [^ 0].
	kk > self ifTrue: [^ 0].
	num _ 1.
	self to: (kk max: self-kk) + 1 by: -1 do: [:factor | num _ num * factor].
	denom _ 1.
	1 to: (kk min: self-kk) do: [:factor | denom _ denom * factor].
	^ num // denom! !


!Integer methodsFor: 'bit manipulation'!
<< shiftAmount  "left shift"
	shiftAmount < 0 ifTrue: [self error: 'negative arg'].
	^ self bitShift: shiftAmount! !

!Integer methodsFor: 'bit manipulation' stamp: 'dwh 8/18/1999 21:57'!
>> shiftAmount  "right shift"
	shiftAmount < 0 ifTrue: [self error: 'negative arg'].
	^ self bitShift: 0 - shiftAmount! !

!Integer methodsFor: 'bit manipulation'!
allMask: mask 
	"Treat the argument as a bit mask. Answer whether all of the bits that 
	are 1 in the argument are 1 in the receiver."

	^mask = (self bitAnd: mask)! !

!Integer methodsFor: 'bit manipulation' stamp: 'sr 6/9/2000 10:14'!
anyBitOfMagnitudeFrom: start to: stopArg 
	"Tests for any magnitude bits in the interval from start to stopArg."
	| magnitude firstDigitIx lastDigitIx rightShift leftShift stop |
	<primitive: 'primAnyBitFromTo' module:'LargeIntegers'>
	start < 1 | (stopArg < 1) ifTrue: [^ self error: 'out of range'].
	magnitude _ self abs.
	stop _ stopArg min: magnitude highBit.
	start > stop ifTrue: [^ false].
	firstDigitIx _ start - 1 // 8 + 1.
	lastDigitIx _ stop - 1 // 8 + 1.
	rightShift _ (start - 1 \\ 8) negated.
	leftShift _ 7 - (stop - 1 \\ 8).
	firstDigitIx = lastDigitIx
		ifTrue: 
			[| digit mask | 
			mask _ (255 bitShift: rightShift negated)
						bitAnd: (255 bitShift: leftShift negated).
			digit _ magnitude digitAt: firstDigitIx.
			^ (digit bitAnd: mask)
				~= 0].
	((magnitude digitAt: firstDigitIx)
		bitShift: rightShift)
		~= 0 ifTrue: [^ true].
	firstDigitIx + 1 to: lastDigitIx - 1 do: [:ix | (magnitude digitAt: ix)
			~= 0 ifTrue: [^ true]].
	((magnitude digitAt: lastDigitIx)
		bitShift: leftShift)
		~= 0 ifTrue: [^ true].
	^ false! !

!Integer methodsFor: 'bit manipulation'!
anyMask: mask 
	"Treat the argument as a bit mask. Answer whether any of the bits that 
	are 1 in the argument are 1 in the receiver."

	^0 ~= (self bitAnd: mask)! !

!Integer methodsFor: 'bit manipulation' stamp: 'sr 3/13/2000 17:47'!
bitAnd: n 
	"Answer an Integer whose bits are the logical AND of the receiver's bits  
	and those of the argument, n."
	| norm |
	<primitive: 'primDigitBitAnd' module:'LargeIntegers'>
	norm _ n normalize.
	^ self
		digitLogic: norm
		op: #bitAnd:
		length: (self digitLength max: norm digitLength)! !

!Integer methodsFor: 'bit manipulation' stamp: 'di 4/30/1998 10:32'!
bitClear: aMask 
	"Answer an Integer equal to the receiver, except with all bits cleared that are set in aMask."

	^ (self bitOr: aMask) - aMask! !

!Integer methodsFor: 'bit manipulation' stamp: 'wb 4/28/1998 12:17'!
bitInvert
	"Answer an Integer whose bits are the logical negation of the receiver's bits.
	Numbers are interpreted as having 2's-complement representation."

	^ -1 - self! !

!Integer methodsFor: 'bit manipulation'!
bitInvert32
	"Answer the 32-bit complement of the receiver."

	^ self bitXor: 16rFFFFFFFF! !

!Integer methodsFor: 'bit manipulation' stamp: 'sr 3/13/2000 17:47'!
bitOr: n 
	"Answer an Integer whose bits are the logical OR of the receiver's bits  
	and those of the argument, n."
	| norm |
	<primitive: 'primDigitBitOr' module:'LargeIntegers'>
	norm _ n normalize.
	^ self
		digitLogic: norm
		op: #bitOr:
		length: (self digitLength max: norm digitLength)! !

!Integer methodsFor: 'bit manipulation' stamp: 'sr 6/9/2000 10:09'!
bitShift: shiftCount 
	"Answer an Integer whose value (in twos-complement representation) is  
	the receiver's value (in twos-complement representation) shifted left by 
	the number of bits indicated by the argument. Negative arguments  
	shift right. Zeros are shifted in from the right in left shifts."
	| magnitudeShift |
	magnitudeShift _ self bitShiftMagnitude: shiftCount.
	^ ((self negative and: [shiftCount negative])
		and: [self anyBitOfMagnitudeFrom: 1 to: shiftCount negated])
		ifTrue: [magnitudeShift - 1]
		ifFalse: [magnitudeShift]! !

!Integer methodsFor: 'bit manipulation' stamp: 'sr 6/9/2000 14:02'!
bitShiftMagnitude: shiftCount 
	"Answer an Integer whose value (in magnitude representation) is  
	the receiver's value (in magnitude representation) shifted left by  
	the number of bits indicated by the argument. Negative arguments
	shift right. Zeros are shifted in from the right in left shifts."
	| rShift |
	<primitive: 'primDigitBitShiftMagnitude' module:'LargeIntegers'>
	shiftCount >= 0 ifTrue: [^ self digitLshift: shiftCount].
	rShift _ 0 - shiftCount.
	^ (self
		digitRshift: (rShift bitAnd: 7)
		bytes: (rShift bitShift: -3)
		lookfirst: self digitLength) normalize! !

!Integer methodsFor: 'bit manipulation' stamp: 'sr 3/13/2000 17:47'!
bitXor: n 
	"Answer an Integer whose bits are the logical XOR of the receiver's bits  
	and those of the argument, n."
	| norm |
	<primitive: 'primDigitBitXor' module:'LargeIntegers'>
	norm _ n normalize.
	^ self
		digitLogic: norm
		op: #bitXor:
		length: (self digitLength max: norm digitLength)! !

!Integer methodsFor: 'bit manipulation' stamp: 'sr 6/8/2000 02:13'!
highBit
	"Answer the index of the high order bit of the receiver, or zero if the  
	receiver is zero. Raise an error if the receiver is negative, since  
	negative integers are defined to have an infinite number of leading 1's 
	in 2's-complement arithmetic. Use >>highBitOfMagnitude if you want to  
	get the highest bit of the magnitude."

	^ self subclassResponsibility! !

!Integer methodsFor: 'bit manipulation' stamp: 'sr 6/8/2000 01:55'!
highBitOfMagnitude
	"Answer the index of the high order bit of the magnitude of the  
	receiver, or zero if the receiver is zero."
	^ self subclassResponsibility! !

!Integer methodsFor: 'bit manipulation' stamp: 'jm 2/19/98 12:11'!
lowBit
	"Answer the index of the low order bit of this number."
	| index |
	self = 0 ifTrue: [ ^ 0 ].
	index := 1.
	[ (self digitAt: index) = 0 ]
		whileTrue:
			[ index := index + 1 ].
	^ (self digitAt: index) lowBit + (8 * (index - 1))! !

!Integer methodsFor: 'bit manipulation'!
noMask: mask 
	"Treat the argument as a bit mask. Answer whether none of the bits that 
	are 1 in the argument are 1 in the receiver."

	^0 = (self bitAnd: mask)! !


!Integer methodsFor: 'converting' stamp: 'di 11/6/1998 13:43'!
adaptToFraction: rcvr andSend: selector
	"If I am involved in arithmetic with a Fraction, convert me to a Fraction."
	^ rcvr perform: selector with: self asFraction! !

!Integer methodsFor: 'converting'!
asCharacter
	"Answer the Character whose value is the receiver."

	^Character value: self! !

!Integer methodsFor: 'converting' stamp: 'ar 10/31/1998 23:04'!
asColorOfDepth: d
	"Return a color value representing the receiver as color of the given depth"
	^Color colorFromPixelValue: self depth: d! !

!Integer methodsFor: 'converting' stamp: 'di 1/13/1999 12:45'!
asFloat
	"Answer a Float that represents the value of the receiver.
	Optimized to process only the significant digits of a LargeInteger.
	SqR: 11/30/1998 21:11"

	| sum firstByte shift |
	shift _ 0.
	sum _ 0.0.
	firstByte _ self size - 7 max: 1.
	firstByte to: self size do:
		[:byteIndex | 
		sum _ ((self digitAt: byteIndex) asFloat timesTwoPower: shift) + sum.
		shift _ shift + 8].
	^sum * self sign asFloat timesTwoPower: firstByte - 1 * 8! !

!Integer methodsFor: 'converting'!
asFraction
	"Answer a Fraction that represents value of the the receiver."

	^Fraction numerator: self denominator: 1! !

!Integer methodsFor: 'converting' stamp: 'ls 5/26/1998 20:53'!
asHexDigit
	^'0123456789ABCDEF' at: self+1! !

!Integer methodsFor: 'converting'!
asInteger
	"Answer with the receiver itself."

	^self

! !


!Integer methodsFor: 'printing' stamp: 'sw 11/24/1998 14:53'!
asStringWithCommas
	"123456789 asStringWithCommas"
	"-123456789 asStringWithCommas"
	| digits |
	digits _ self abs printString.
	^ String streamContents:
		[:strm | 
		self sign = -1 ifTrue: [strm nextPut: $-].
		1 to: digits size do: 
			[:i | strm nextPut: (digits at: i).
			(i < digits size and: [(i - digits size) \\ 3 = 0])
				ifTrue: [strm nextPut: $,]]]! !

!Integer methodsFor: 'printing' stamp: 'sw 11/13/1999 23:00'!
asTwoCharacterString
	"Answer a two-character string representing the receiver, with leading zero if required.  Intended for use with integers in the range 0 to 99, but plausible replies given for other values too"

	^ (self >= 0 and: [self < 10])
		ifTrue:	['0', self printString]
		ifFalse:	[self printString copyFrom: 1 to: 2]


"
2 asTwoCharacterString
11 asTwoCharacterString
1943 asTwoCharacterString
0 asTwoCharacterString
-2 asTwoCharacterString
-234 asTwoCharacterString
"! !

!Integer methodsFor: 'printing' stamp: 'jm 4/23/2004 14:27'!
bits
	"Answer myself in binary."

	| s |
	s _ self printStringBase: 2.
	s _ s copyFrom: 3 to: s size.
	^ s
! !

!Integer methodsFor: 'printing' stamp: 'MPW 1/1/1901 00:14'!
destinationBuffer:digitLength
  digitLength <= 1
		ifTrue: [self]
		ifFalse: [LargePositiveInteger new: digitLength].! !

!Integer methodsFor: 'printing' stamp: 'MPW 1/1/1901 00:16'!
digitBuffer:digitLength
  ^Array new:digitLength*8.! !

!Integer methodsFor: 'printing'!
hex
	^ self printStringBase: 16! !

!Integer methodsFor: 'printing'!
hex8  "16r3333 hex8"
	| hex |
	hex _ self hex.  "16rNNN"
	hex size < 11
		ifTrue: [^ hex copyReplaceFrom: 4 to: 3
						 with: ('00000000' copyFrom: 1 to: 11-hex size)]
		ifFalse: [^ hex]! !

!Integer methodsFor: 'printing' stamp: 'jm 6/3/2004 18:31'!
hhmmss
	"Answer a string of the form HH:MM:SS. For displaying a time in seconds as hours, minutes, and seconds."

	| hh mm ss |
	hh _ (self // 3600) printString.
	mm _ ((self // 60) \\ 60) printString.
	mm size < 2 ifTrue: [mm _ '0', mm].
	ss _ (self \\ 60) printString.
	ss size < 2 ifTrue: [ss _ '0', ss].
	^ hh, ':', mm, ':', ss
! !

!Integer methodsFor: 'printing'!
isLiteral

	^true! !

!Integer methodsFor: 'printing' stamp: 'MPW 1/1/1901 01:04'!
printOn: aStream base: b 
	"Print a representation of the receiver on the stream, aStream, in base, b, 
	where 2<=b<=16."
	| digits source dest i j pos t rem |
	self negative ifTrue:[aStream nextPut:$-].
	b = 10 ifFalse: [aStream print: b; nextPut: $r].
	i _ self digitLength.
	"Estimate size of result, conservatively"
	digits _ Array new: i * 8.
	pos _ 0.
	dest _ i <= 1
		ifTrue: [self]
		ifFalse: [LargePositiveInteger new: i].
	source _ self.
	[i >= 1]
		whileTrue: 
			[rem _ 0.
			j _ i.
			[j > 0]
				whileTrue: 
					[t _ (rem bitShift: 8) + (source digitAt: j).
					dest digitAt: j put: t // b.
					rem _ t \\ b.
					j _ j - 1].
			pos _ pos + 1.
			digits at: pos put: rem.
			source _ dest.
			(source digitAt: i) = 0 ifTrue: [i _ i - 1]].
	"(dest digitAt: 1) printOn: aStream base: b."
	[pos > 0]
		whileTrue:
			[aStream nextPut: (Character digitValue: (digits at: pos)).
			pos _ pos - 1]! !

!Integer methodsFor: 'printing'!
radix: radix 
	"Answer a String representing the receiver as a base radix integer."

	^ self printStringBase: radix! !

!Integer methodsFor: 'printing' stamp: 'jm 5/22/2003 19:33'!
romanString
	"Answer myself as represented in Roman numerals."
	"1999 romanString"

	self assert: [self > 0].
	^ String streamContents: [:s |
		self // 1000 timesRepeat: [s nextPut: $M].
		self romanDigits: 'MDC' for: 100 on: s.
		self romanDigits: 'CLX' for: 10 on: s.
		self romanDigits: 'XVI' for: 1 on: s]
! !


!Integer methodsFor: 'system primitives' stamp: 'tk 3/24/1999 20:26'!
lastDigit
	"Answer the last digit of the integer base 256.  LargePositiveInteger uses bytes of base two number, and each is a 'digit'."

	^self digitAt: self digitLength! !

!Integer methodsFor: 'system primitives'!
replaceFrom: start to: stop with: replacement startingAt: repStart
	| j |  "Catches failure if LgInt replace primitive fails"
	j _ repStart.
	start to: stop do:
		[:i |
		self digitAt: i put: (replacement digitAt: j).
		j _ j+1]! !


!Integer methodsFor: 'private'!
copyto: x
	| stop |
	stop _ self digitLength min: x digitLength.
	^ x replaceFrom: 1 to: stop with: self startingAt: 1! !

!Integer methodsFor: 'private' stamp: 'sr 1/23/2000 05:41'!
digitAdd: arg 
	| len arglen accum sum |
	<primitive: 'primDigitAdd' module:'LargeIntegers'>
	accum _ 0.
	(len _ self digitLength) < (arglen _ arg digitLength) ifTrue: [len _ arglen].
	"Open code max: for speed"
	sum _ Integer new: len neg: self negative.
	1 to: len do: 
		[:i | 
		accum _ (accum bitShift: -8)
					+ (self digitAt: i) + (arg digitAt: i).
		sum digitAt: i put: (accum bitAnd: 255)].
	accum > 255
		ifTrue: 
			[sum _ sum growby: 1.
			sum at: sum digitLength put: (accum bitShift: -8)].
	^ sum! !

!Integer methodsFor: 'private' stamp: 'sr 1/23/2000 05:43'!
digitCompare: arg 
	"Compare the magnitude of self with that of arg.   
	Return a code of 1, 0, -1 for self >, = , < arg"
	| len arglen argDigit selfDigit |
	<primitive: 'primDigitCompare' module:'LargeIntegers'>
	len _ self digitLength.
	(arglen _ arg digitLength) ~= len
		ifTrue: [arglen > len
				ifTrue: [^ -1]
				ifFalse: [^ 1]].
	[len > 0]
		whileTrue: 
			[(argDigit _ arg digitAt: len) ~= (selfDigit _ self digitAt: len)
				ifTrue: [argDigit < selfDigit
						ifTrue: [^ 1]
						ifFalse: [^ -1]].
			len _ len - 1].
	^ 0! !

!Integer methodsFor: 'private' stamp: 'jm 5/22/2003 19:57'!
digitDiv: arg neg: ng 
	"Answer with an array of (quotient, remainder)."
	| quo rem ql d div dh dnh dl qhi qlo j l hi lo r3 a t |
	<primitive: 'primDigitDivNegative' module:'LargeIntegers'>
	arg = 0 ifTrue: [^ self error: 'division by 0'].
	"TFEI added this line"
	l _ self digitLength - arg digitLength + 1.
	l <= 0 ifTrue: [^ Array with: 0 with: self].
	"shortcut against #highBit"
	d _ 8 - arg lastDigit highBitOfPositiveReceiver.
	div _ arg digitLshift: d.
	div _ div growto: div digitLength + 1.
	"shifts so high order word is >=128"
	rem _ self digitLshift: d.
	rem digitLength = self digitLength ifTrue: [rem _ rem growto: self digitLength + 1].
	"makes a copy and shifts"
	quo _ Integer new: l neg: ng.
	dl _ div digitLength - 1.
	"Last actual byte of data"
	ql _ l.
	dh _ div digitAt: dl.
	dnh _ dl = 1
				ifTrue: [0]
				ifFalse: [div digitAt: dl - 1].
	1 to: ql do: 
		[:k | 
		"maintain quo*arg+rem=self"
		"Estimate rem/div by dividing the leading to bytes of rem by dh."
		"The estimate is q = qhi*16+qlo, where qhi and qlo are nibbles."
		j _ rem digitLength + 1 - k.
		"r1 _ rem digitAt: j."
		(rem digitAt: j)
			= dh
			ifTrue: [qhi _ qlo _ 15
				"i.e. q=255"]
			ifFalse: 
				["Compute q = (r1,r2)//dh, t = (r1,r2)\\dh.  
				Note that r1,r2 are bytes, not nibbles.  
				Be careful not to generate intermediate results exceeding 13  
				bits."
				"r2 _ (rem digitAt: j - 1)."
				t _ ((rem digitAt: j)
							bitShift: 4)
							+ ((rem digitAt: j - 1)
									bitShift: -4).
				qhi _ t // dh.
				t _ (t \\ dh bitShift: 4)
							+ ((rem digitAt: j - 1)
									bitAnd: 15).
				qlo _ t // dh.
				t _ t \\ dh.
				"Next compute (hi,lo) _ q*dnh"
				hi _ qhi * dnh.
				lo _ qlo * dnh + ((hi bitAnd: 15)
								bitShift: 4).
				hi _ (hi bitShift: -4)
							+ (lo bitShift: -8).
				lo _ lo bitAnd: 255.
				"Correct overestimate of q.  
				Max of 2 iterations through loop -- see Knuth vol. 2"
				r3 _ j < 3
							ifTrue: [0]
							ifFalse: [rem digitAt: j - 2].
				[(t < hi
					or: [t = hi and: [r3 < lo]])
					and: 
						["i.e. (t,r3) < (hi,lo)"
						qlo _ qlo - 1.
						lo _ lo - dnh.
						lo < 0
							ifTrue: 
								[hi _ hi - 1.
								lo _ lo + 256].
						hi >= dh]]
					whileTrue: [hi _ hi - dh].
				qlo < 0
					ifTrue: 
						[qhi _ qhi - 1.
						qlo _ qlo + 16]].
		"Subtract q*div from rem"
		l _ j - dl.
		a _ 0.
		1 to: div digitLength do: 
			[:i | 
			hi _ (div digitAt: i)
						* qhi.
			lo _ a + (rem digitAt: l) - ((hi bitAnd: 15)
							bitShift: 4) - ((div digitAt: i)
							* qlo).
			rem digitAt: l put: lo - (lo // 256 * 256).
			"sign-tolerant form of (lo bitAnd: 255)"
			a _ lo // 256 - (hi bitShift: -4).
			l _ l + 1].
		a < 0
			ifTrue: 
				["Add div back into rem, decrease q by 1"
				qlo _ qlo - 1.
				l _ j - dl.
				a _ 0.
				1 to: div digitLength do: 
					[:i | 
					a _ (a bitShift: -8)
								+ (rem digitAt: l) + (div digitAt: i).
					rem digitAt: l put: (a bitAnd: 255).
					l _ l + 1]].
		quo digitAt: quo digitLength + 1 - k put: (qhi bitShift: 4)
				+ qlo].
	rem _ rem
				digitRshift: d
				bytes: 0
				lookfirst: dl.
	^ Array with: quo with: rem! !

!Integer methodsFor: 'private'!
digitLogic: arg op: op length: len
	| result neg1 neg2 rneg z1 z2 rz b1 b2 b |
	neg1 _ self negative.
	neg2 _ arg negative.
	rneg _ 
		((neg1 ifTrue: [-1] ifFalse: [0])
			perform: op 
			with: (neg2
					ifTrue: [-1]
					ifFalse: [0])) < 0.
	result _ Integer new: len neg: rneg.
	rz _ z1 _ z2 _ true.
	1 to: result digitLength do: 
		[:i | 
		b1 _ self digitAt: i.
		neg1 
			ifTrue: [b1 _ z1
						ifTrue: [b1 = 0
									ifTrue: [0]
									ifFalse: 
										[z1 _ false.
										256 - b1]]
						ifFalse: [255 - b1]].
		b2 _ arg digitAt: i.
		neg2 
			ifTrue: [b2 _ z2
						ifTrue: [b2 = 0
									ifTrue: [0]
									ifFalse: 
										[z2 _ false.
										256 - b2]]
						ifFalse: [255 - b2]].
		b _ b1 perform: op with: b2.
		b = 0
			ifTrue: 
				[result digitAt: i put: 0]
			ifFalse: 
				[result 
					digitAt: i 
					put: (rneg
							ifTrue: [rz ifTrue: 
											[rz _ false.
											256 - b]
										ifFalse: [255 - b]]
						ifFalse: [b])]].
	^ result normalize! !

!Integer methodsFor: 'private' stamp: 'sr 6/8/2000 01:30'!
digitLshift: shiftCount 
	| carry rShift mask len result digit byteShift bitShift highBit |
	(highBit _ self highBitOfMagnitude) = 0 ifTrue: [^ 0].
	len _ highBit + shiftCount + 7 // 8.
	result _ Integer new: len neg: self negative.
	byteShift _ shiftCount // 8.
	bitShift _ shiftCount \\ 8.
	bitShift = 0 ifTrue: ["Fast version for byte-aligned shifts"
		^ result
			replaceFrom: byteShift + 1
			to: len
			with: self
			startingAt: 1].
	carry _ 0.
	rShift _ bitShift - 8.
	mask _ 255 bitShift: 0 - bitShift.
	1 to: byteShift do: [:i | result digitAt: i put: 0].
	1 to: len - byteShift do: 
		[:i | 
		digit _ self digitAt: i.
		result digitAt: i + byteShift put: (((digit bitAnd: mask)
				bitShift: bitShift)
				bitOr: carry).
		carry _ digit bitShift: rShift].
	^ result! !

!Integer methodsFor: 'private' stamp: 'sr 1/23/2000 05:46'!
digitMultiply: arg neg: ng 
	| prod prodLen carry digit k ab |
	<primitive: 'primDigitMultiplyNegative' module:'LargeIntegers'>
	(arg digitLength = 1 and: [(arg digitAt: 1)
			= 0])
		ifTrue: [^ 0].
	(self digitLength = 1 and: [(self digitAt: 1)
			= 0])
		ifTrue: [^ 0].
	prodLen _ self digitLength + arg digitLength.
	prod _ Integer new: prodLen neg: ng.
	"prod starts out all zero"
	1 to: self digitLength do: [:i | (digit _ self digitAt: i) ~= 0
			ifTrue: 
				[k _ i.
				carry _ 0.
				"Loop invariant: 0<=carry<=0377, k=i+j-1"
				1 to: arg digitLength do: 
					[:j | 
					ab _ (arg digitAt: j)
								* digit + carry + (prod digitAt: k).
					carry _ ab bitShift: -8.
					prod digitAt: k put: (ab bitAnd: 255).
					k _ k + 1].
				prod digitAt: k put: carry]].
	^ prod normalize! !

!Integer methodsFor: 'private'!
digitRshift: anInteger bytes: b lookfirst: a 
	 "Shift right 8*b+anInteger bits, 0<=n<8.
	Discard all digits beyond a, and all zeroes at or below a."
	| n x r f m digit count i |
	n _ 0 - anInteger.
	x _ 0.
	f _ n + 8.
	i _ a.
	m _ 255 bitShift: 0 - f.
	digit _ self digitAt: i.
	[((digit bitShift: n) bitOr: x) = 0 and: [i ~= 1]] whileTrue:
		[x _ digit bitShift: f "Can't exceed 8 bits".
		i _ i - 1.
		digit _ self digitAt: i].
	i <= b ifTrue: [^Integer new: 0 neg: self negative].  "All bits lost"
	r _ Integer new: i - b neg: self negative.
	count _ i.
	x _ (self digitAt: b + 1) bitShift: n.
	b + 1 to: count do:
		[:j | digit _ self digitAt: j + 1.
		r digitAt: j - b put: (((digit bitAnd: m) bitShift: f) bitOr: x) 
			"Avoid values > 8 bits".
		x _ digit bitShift: n].
	^r! !

!Integer methodsFor: 'private' stamp: 'sr 1/23/2000 05:46'!
digitSubtract: arg 
	| smaller larger z sum sl al ng |
	<primitive: 'primDigitSubtract' module:'LargeIntegers'>
	sl _ self digitLength.
	al _ arg digitLength.
	(sl = al
		ifTrue: 
			[[(self digitAt: sl)
				= (arg digitAt: sl) and: [sl > 1]]
				whileTrue: [sl _ sl - 1].
			al _ sl.
			(self digitAt: sl)
				< (arg digitAt: sl)]
		ifFalse: [sl < al])
		ifTrue: 
			[larger _ arg.
			smaller _ self.
			ng _ self negative == false.
			sl _ al]
		ifFalse: 
			[larger _ self.
			smaller _ arg.
			ng _ self negative].
	sum _ Integer new: sl neg: ng.
	z _ 0.
	"Loop invariant is -1<=z<=1"
	1 to: sl do: 
		[:i | 
		z _ z + (larger digitAt: i) - (smaller digitAt: i).
		sum digitAt: i put: z - (z // 256 * 256).
		"sign-tolerant form of (z bitAnd: 255)"
		z _ z // 256].
	^ sum normalize! !

!Integer methodsFor: 'private'!
growby: n

	^self growto: self digitLength + n! !

!Integer methodsFor: 'private'!
growto: n

	^self copyto: (self species new: n)! !

!Integer methodsFor: 'private' stamp: 'sma 5/20/2000 17:00'!
romanDigits: digits for: base on: aStream
	| n |
	n _ self \\ (base * 10) // base.
	n = 9 ifTrue: [^ aStream nextPut: digits last; nextPut: digits first].
	n = 4 ifTrue: [^ aStream nextPut: digits last; nextPut: digits second].
	n > 4 ifTrue: [aStream nextPut: digits second].
	n \\ 5 timesRepeat: [aStream nextPut: digits last]! !


!Integer methodsFor: 'benchmarks' stamp: 'jm 11/20/1998 07:06'!
benchFib  "Handy send-heavy benchmark"
	"(result // seconds to run) = approx calls per second"
	" | r t |
	  t _ Time millisecondsToRun: [r _ 26 benchFib].
	  (r * 1000) // t"
	"138000 on a Mac 8100/100"
	^ self < 2
		ifTrue: [1] 
		ifFalse: [(self-1) benchFib + (self-2) benchFib + 1]
! !

!Integer methodsFor: 'benchmarks' stamp: 'di 4/11/1999 11:20'!
benchmark  "Handy bytecode-heavy benchmark"
	"(500000 // time to run) = approx bytecodes per second"
	"5000000 // (Time millisecondsToRun: [10 benchmark]) * 1000"
	"3059000 on a Mac 8100/100"
    | size flags prime k count |
    size _ 8190.
    1 to: self do:
        [:iter |
        count _ 0.
        flags _ (Array new: size) atAllPut: true.
        1 to: size do:
            [:i | (flags at: i) ifTrue:
                [prime _ i+1.
                k _ i + prime.
                [k <= size] whileTrue:
                    [flags at: k put: false.
                    k _ k + prime].
                count _ count + 1]]].
    ^ count! !

!Integer methodsFor: 'benchmarks' stamp: 'dwh 11/21/1999 16:40'!
tinyBenchmarks
	"Report the results of running the two tiny Squeak benchmarks.
	ar 9/10/1999: Adjusted to run at least 1 sec to get more stable results"
	"0 tinyBenchmarks"
	"On a 292 MHz G3 Mac: 22727272 bytecodes/sec; 984169 sends/sec"
	"On a 400 MHz PII/Win98:  18028169 bytecodes/sec; 1081272 sends/sec"
	| t1 t2 r n1 n2 |
	n1 _ 1.
	[t1 _ Time millisecondsToRun: [n1 benchmark].
	t1 < 1000] whileTrue:[n1 _ n1 * 2]. "Note: #benchmark's runtime is about O(n)"

	n2 _ 28.
	[t2 _ Time millisecondsToRun: [r _ n2 benchFib].
	t2 < 1000] whileTrue:[n2 _ n2 + 1]. 
	"Note: #benchFib's runtime is about O(k^n),
		where k is the golden number = (1 + 5 sqrt) / 2 = 1.618...."

	^ ((n1 * 500000 * 1000) // t1) printString, ' bytecodes/sec; ',
	  ((r * 1000) // t2) printString, ' sends/sec'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Integer class
	instanceVariableNames: ''!

!Integer class methodsFor: 'instance creation' stamp: 'tk 4/20/1999 14:18'!
basicNew

	self == Integer ifTrue: [
		^ self error: 'Integer is an abstract class.  Make a concrete subclass.'].
	^ super basicNew! !

!Integer class methodsFor: 'instance creation'!
byte1: byte1 byte2: byte2 byte3: byte3 byte4: byte4 
	"Depending on high-order byte copy directly into a LargeInteger,
	or build up a SmallInteger by shifting"
	| value |
	byte4 < 16r20 ifTrue:
		[^ (byte4 bitShift: 24)
		 + (byte3 bitShift: 16)
		 + (byte2 bitShift: 8)
		 + byte1].
	value _ LargePositiveInteger new: 4.
	value digitAt: 4 put: byte4.
	value digitAt: 3 put: byte3.
	value digitAt: 2 put: byte2.
	value digitAt: 1 put: byte1.
	^ value! !

!Integer class methodsFor: 'instance creation' stamp: 'tk 4/18/1999 22:01'!
new

	self == Integer ifTrue: [
		^ self error: 'Integer is an abstract class.  Make a concrete subclass.'].
	^ super new! !

!Integer class methodsFor: 'instance creation'!
new: length neg: neg
	"Answer an instance of a large integer whose size is length. neg is a flag 
	determining whether the integer is negative or not."

	neg 
		ifTrue: [^LargeNegativeInteger new: length]
		ifFalse: [^LargePositiveInteger new: length]! !

!Integer class methodsFor: 'instance creation'!
readFrom: aStream 
	"Answer a new Integer as described on the stream, aStream.
	Embedded radix specifiers not allowed - use Number readFrom: for that."
	^self readFrom: aStream base: 10! !

!Integer class methodsFor: 'instance creation' stamp: 'ls 6/23/1999 20:37'!
readFrom: aStream base: base 
	"Answer an instance of one of my concrete subclasses. Initial minus sign 
	accepted, and bases > 10 use letters A-Z. Embedded radix specifiers not 
	allowed--use Number readFrom: for that. Answer zero (not an error) if 
	there are no digits."

	| digit value neg startPos |
	neg _ aStream peekFor: $-.
	neg ifFalse: [aStream peekFor: $+].
	value _ 0.
	startPos _ aStream position.
	[aStream atEnd]
		whileFalse: 
			[digit _ aStream next digitValue.
			(digit < 0 or: [digit >= base])
				ifTrue: 
					[aStream skip: -1.
					aStream position = startPos ifTrue: [self error: 'At least one digit expected here'].
					neg ifTrue: [^ value negated].
					^ value]
				ifFalse: [value _ value * base + digit]].
	neg ifTrue: [^ value negated].
	^ value! !

!Integer class methodsFor: 'instance creation' stamp: 'di 4/30/1998 10:42'!
testBitLogic  "Integer testBitLogic"
	"This little suite of tests is designed to verify correct operation of most
	of Squeak's bit manipulation code, including two's complement
	representation of negative values.  It was written in a hurry and
	is probably lacking several important checks."

	"Shift 1 bit left then right and test for 1"
	| n |
	1 to: 100 do: [:i | ((1 bitShift: i) bitShift: i negated) = 1 ifFalse: [self error: 'Bit Logic Failure']].

	"Shift -1 left then right and test for 1"
	1 to: 100 do: [:i | ((-1 bitShift: i) bitShift: i negated) = -1 ifFalse: [self error: 'Bit Logic Failure']].

	"And a single bit with -1 and test for same value"
	1 to: 100 do: [:i | ((1 bitShift: i) bitAnd: -1) = (1 bitShift: i) ifFalse: [self error: 'Bit Logic Failure']].

	"Verify that (n bitAnd: n negated) = n for single bits"
	1 to: 100 do: [:i | n _ 1 bitShift: i.
				(n bitAnd: n negated) = n ifFalse: [self error: 'Bit Logic Failure']].

	"Verify that n negated = (n complemented + 1) for single bits"
	1 to: 100 do: [:i | n _ 1 bitShift: i.
				n negated = ((n bitXor: -1) + 1) ifFalse: [self error: 'Bit Logic Failure']].

	"Verify that (n + n complemented) = -1 for single bits"
	1 to: 100 do: [:i | n _ 1 bitShift: i.
				(n + (n bitXor: -1)) = -1 ifFalse: [self error: 'Bit Logic Failure']].

	"Verify that n negated = (n complemented +1) for single bits"
	1 to: 100 do: [:i | n _ 1 bitShift: i.
				n negated = ((n bitXor: -1) + 1) ifFalse: [self error: 'Bit Logic Failure']].
! !



Integer subclass: #SmallInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel-Numbers'!
!SmallInteger commentStamp: '<historical>' prior: 0!
My instances are 30-bit numbers, stored in twos complement form. The allowable range is approximately +- 1 billion (see SmallInteger minVal, maxVal).!


!SmallInteger methodsFor: 'arithmetic' stamp: 'di 2/1/1999 21:29'!
* aNumber 
	"Primitive. Multiply the receiver by the argument and answer with the
	result if it is a SmallInteger. Fail if the argument or the result is not a
	SmallInteger. Essential. No Lookup. See Object documentation whatIsAPrimitive."

	<primitive: 9>
	^ super * aNumber! !

!SmallInteger methodsFor: 'arithmetic' stamp: 'di 2/1/1999 21:31'!
+ aNumber 
	"Primitive. Add the receiver to the argument and answer with the result
	if it is a SmallInteger. Fail if the argument or the result is not a
	SmallInteger  Essential  No Lookup. See Object documentation whatIsAPrimitive."

	<primitive: 1>
	^ super + aNumber! !

!SmallInteger methodsFor: 'arithmetic'!
- aNumber 
	"Primitive. Subtract the argument from the receiver and answer with the
	result if it is a SmallInteger. Fail if the argument or the result is not a
	SmallInteger. Essential. No Lookup. See Object documentation
	whatIsAPrimitive."

	<primitive: 2>
	^super - aNumber! !

!SmallInteger methodsFor: 'arithmetic' stamp: 'jm 9/5/2006 18:39'!
/ aNumber 
	"Primitive. This primitive (for /) divides the receiver by the argument
	and returns the result if the division is exact. Fail if the result is not a
	whole integer. Fail if the argument is 0 or is not a SmallInteger. Optional.
	No Lookup. See Object documentation whatIsAPrimitive."

	<primitive: 10>
	aNumber = 0 ifTrue: [^ self error: 'division by 0'].
	(aNumber isMemberOf: SmallInteger)
		ifTrue: [^ self asFloat / aNumber]
		ifFalse: [^ super / aNumber]
! !

!SmallInteger methodsFor: 'arithmetic'!
// aNumber 
	"Primitive. Divide the receiver by the argument and answer with the
	result. Round the result down towards negative infinity to make it a
	whole integer. Fail if the argument is 0 or is not a SmallInteger.
	Essential. No Lookup. See Object documentation whatIsAPrimitive. "

	<primitive: 12>
	^super // aNumber"Do with quo: if primitive fails"! !

!SmallInteger methodsFor: 'arithmetic'!
\\ aNumber 
	"Primitive. Take the receiver modulo the argument. The result is the
	remainder rounded towards negative infinity, of the receiver divided by
	the argument Fail if the argument is 0 or is not a SmallInteger. Optional.
	No Lookup. See Object documentation whatIsAPrimitive."

	<primitive: 11>
	^super \\ aNumber"Do with // if primitive fails"! !

!SmallInteger methodsFor: 'arithmetic' stamp: 'LC 4/22/1998 14:21'!
gcd: anInteger 
	"See SmallInteger (Integer) | gcd:"
	| n m |
	n _ self.
	m _ anInteger.
	[n = 0]
		whileFalse: 
			[n _ m \\ (m _ n)].
	^ m abs! !

!SmallInteger methodsFor: 'arithmetic' stamp: 'jm 5/22/2003 19:59'!
quo: aNumber 
	"Primitive. Divide the receiver by the argument and answer with the 
	result. Round the result down towards zero to make it a whole integer. 
	Fail if the argument is 0 or is not a SmallInteger. Optional. See Object 
	documentation whatIsAPrimitive."
	<primitive: 13>
	aNumber = 0 ifTrue: [^ self error: 'division by 0'].
	(aNumber isMemberOf: SmallInteger)
		ifFalse: [^ super quo: aNumber].
	(aNumber == -1 and: [self == self class minVal])
		ifTrue: ["result is aLargeInteger" ^ self negated].
	self primitiveFailed! !


!SmallInteger methodsFor: 'bit manipulation' stamp: 'wb 4/28/1998 12:17'!
bitAnd: arg 
	"Primitive. Answer an Integer whose bits are the logical OR of the
	receiver's bits and those of the argument, arg.
	Numbers are interpreted as having 2's-complement representation.
	Essential.  See Object documentation whatIsAPrimitive."

	<primitive: 14>
	self >= 0 ifTrue: [^ arg bitAnd: self].
	^ (self bitInvert bitOr: arg bitInvert) bitInvert! !

!SmallInteger methodsFor: 'bit manipulation' stamp: 'di 4/30/1998 10:33'!
bitOr: arg 
	"Primitive. Answer an Integer whose bits are the logical OR of the
	receiver's bits and those of the argument, arg.
	Numbers are interpreted as having 2's-complement representation.
	Essential.  See Object documentation whatIsAPrimitive."

	<primitive: 15>
	self >= 0 ifTrue: [^ arg bitOr: self].
	^ arg < 0
		ifTrue: [(self bitInvert bitAnd: arg bitInvert) bitInvert]
		ifFalse: [(self bitInvert bitClear: arg) bitInvert]! !

!SmallInteger methodsFor: 'bit manipulation' stamp: 'wb 4/28/1998 12:17'!
bitShift: arg 
	"Primitive. Answer an Integer whose value is the receiver's value shifted
	left by the number of bits indicated by the argument. Negative arguments
	shift right. The receiver is interpreted as having 2's-complement representation.
	Essential.  See Object documentation whatIsAPrimitive."

	<primitive: 17>
	self >= 0 ifTrue: [^ super bitShift: arg].
	^ arg >= 0
		ifTrue: [(self negated bitShift: arg) negated]
		ifFalse: [(self bitInvert bitShift: arg) bitInvert]! !

!SmallInteger methodsFor: 'bit manipulation' stamp: 'wb 4/28/1998 12:17'!
bitXor: arg 
	"Primitive. Answer an Integer whose bits are the logical XOR of the
	receiver's bits and those of the argument, arg.
	Numbers are interpreted as having 2's-complement representation.
	Essential.  See Object documentation whatIsAPrimitive."

	<primitive: 16>
	self >= 0 ifTrue: [^ arg bitXor: self].
	^ arg < 0
		ifTrue: [self bitInvert bitXor: arg bitInvert]
		ifFalse: [(self bitInvert bitXor: arg) bitInvert]! !

!SmallInteger methodsFor: 'bit manipulation' stamp: 'sr 6/8/2000 02:07'!
highBit
	"Answer the index of the high order bit of the receiver, or zero if the  
	receiver is zero. Raise an error if the receiver is negative, since  
	negative integers are defined to have an infinite number of leading 1's 
	in 2's-complement arithmetic. Use >>highBitOfMagnitude if you want to 
	get the highest bit of the magnitude."
	self < 0 ifTrue: [^ self error: 'highBit is not defined for negative integers'].
	^ self highBitOfPositiveReceiver! !

!SmallInteger methodsFor: 'bit manipulation' stamp: 'sr 6/8/2000 02:08'!
highBitOfMagnitude
	"Answer the index of the high order bit of the receiver, or zero if the  
	receiver is zero. This method is used for negative SmallIntegers as well,  
	since Squeak's LargeIntegers are sign/magnitude."
	^ self abs highBitOfPositiveReceiver! !

!SmallInteger methodsFor: 'bit manipulation' stamp: 'jm 2/19/98 12:11'!
lowBit
	" Answer the index of the low order one bit.
		2r00101000 lowBit       (Answers: 4)
		2r-00101000 lowBit      (Answers: 4)
	  First we skip bits in groups of 4, then single bits.
	  While not optimal, this is a good tradeoff; long
	  integer #lowBit always invokes us with bytes."
	| n result |
	n := self.
	n = 0 ifTrue: [ ^ 0 ].
	result := 1.
	[ (n bitAnd: 16rF) = 0 ]
		whileTrue: [
			result := result + 4.
			n := n bitShift: -4 ].
	[ (n bitAnd: 1) = 0 ]
		whileTrue: [
			result := result + 1.
			n := n bitShift: -1 ].
	^ result! !


!SmallInteger methodsFor: 'testing'!
even

	^(self bitAnd: 1) = 0! !

!SmallInteger methodsFor: 'testing'!
odd

	^(self bitAnd: 1) = 1! !


!SmallInteger methodsFor: 'comparing'!
< aNumber 
	"Primitive. Compare the receiver with the argument and answer with
	true if the receiver is less than the argument. Otherwise answer false.
	Fail if the argument is not a SmallInteger. Essential. No Lookup. See
	Object documentation whatIsAPrimitive."

	<primitive: 3>
	^super < aNumber! !

!SmallInteger methodsFor: 'comparing'!
<= aNumber 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is less than or equal to the argument. Otherwise answer
	false. Fail if the argument is not a SmallInteger. Optional. No Lookup.
	See Object documentation whatIsAPrimitive. "

	<primitive: 5>
	^super <= aNumber! !

!SmallInteger methodsFor: 'comparing'!
= aNumber 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is equal to the argument. Otherwise answer false. Fail if the
	argument is not a SmallInteger. Essential. No Lookup. See Object
	documentation whatIsAPrimitive. "

	<primitive: 7>
	^super = aNumber! !

!SmallInteger methodsFor: 'comparing'!
> aNumber 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is greater than the argument. Otherwise answer false. Fail if
	the argument is not a SmallInteger. Essential. No Lookup. See Object
	documentation whatIsAPrimitive."

	<primitive: 4>
	^super > aNumber! !

!SmallInteger methodsFor: 'comparing'!
>= aNumber 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is greater than or equal to the argument. Otherwise answer
	false. Fail if the argument is not a SmallInteger. Optional. No Lookup.
	See Object documentation whatIsAPrimitive."

	<primitive: 6>
	^super >= aNumber! !

!SmallInteger methodsFor: 'comparing'!
hash

	^self! !

!SmallInteger methodsFor: 'comparing'!
identityHash

	^self! !

!SmallInteger methodsFor: 'comparing'!
~= aNumber 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is not equal to the argument. Otherwise answer false. Fail if
	the argument is not a SmallInteger. Essential. No Lookup. See Object
	documentation whatIsAPrimitive."

	<primitive: 8>
	^super ~= aNumber! !


!SmallInteger methodsFor: 'copying' stamp: 'tk 6/26/1998 11:34'!
clone
! !

!SmallInteger methodsFor: 'copying'!
deepCopy! !

!SmallInteger methodsFor: 'copying'!
shallowCopy! !


!SmallInteger methodsFor: 'converting'!
asFloat
	"Primitive. Answer a Float that represents the value of the receiver.
	Essential. See Object documentation whatIsAPrimitive."

	<primitive: 40>
	self primitiveFailed! !

!SmallInteger methodsFor: 'converting' stamp: 'jm 6/26/2006 10:25'!
asSignedByte
	"Used for converting ByteArray literals to Java."

	self assert: [(self >= 0) & (self <= 255)].
	^ self > 127 ifTrue: [self - 256] ifFalse: [self]
! !


!SmallInteger methodsFor: 'printing' stamp: 'MPW 1/1/1901 00:15'!
destinationBuffer:digitLength
  ^ LargePositiveInteger new: digitLength.! !

!SmallInteger methodsFor: 'printing'!
printOn: aStream base: b
	"Refer to the comment in Integer|printOn:base:."
	"SmallInteger maxVal printStringBase: 2"

	| digitsInReverse x i |
	self < 0 ifTrue: [
		aStream nextPut: $-.
		^ self negated printOn: aStream base: b.
	].

	b = 10 ifFalse: [aStream print: b; nextPut: $r].
	digitsInReverse _ Array new: 32.
	x _ self.
	i _ 0.
	[x >= b] whileTrue: [
		digitsInReverse at: (i _ i + 1) put: x \\ b.
		x _ x // b.
	].
	digitsInReverse at: (i _ i + 1) put: x.
	[i > 0] whileTrue: [
		aStream nextPut: (Character digitValue: (digitsInReverse at: i)).
		i _ i - 1.
	].! !


!SmallInteger methodsFor: 'system primitives'!
asOop
	"Answer an object pointer as an integer, return negative number for SmallInteger"

	^ self! !

!SmallInteger methodsFor: 'system primitives' stamp: 'tk 3/24/1999 20:28'!
digitAt: n 
	"Answer the value of an indexable field in the receiver.  LargePositiveInteger uses bytes of base two number, and each is a 'digit' base 256.  Fail if the argument (the index) is not an Integer or is out of bounds."
	n>4 ifTrue: [^ 0].
	self < 0
		ifTrue: 
			[self = SmallInteger minVal ifTrue:
				["Can't negate minVal -- treat specially"
				^ #(0 0 0 64) at: n].
			^ ((0-self) bitShift: (1-n)*8) bitAnd: 16rFF]
		ifFalse: [^ (self bitShift: (1-n)*8) bitAnd: 16rFF]! !

!SmallInteger methodsFor: 'system primitives'!
digitAt: n put: value 
	"Fails. The digits of a small integer can not be modified."

	self error: 'You cant store in a SmallInteger'! !

!SmallInteger methodsFor: 'system primitives'!
digitLength
	"Answer the number of indexable fields in the receiver. This value is the 
	same as the largest legal subscript. Included so that a SmallInteger can 
	behave like a LargePositiveInteger or LargeNegativeInteger."

	(self < 16r100 and: [self > -16r100]) ifTrue: [^ 1].
	(self < 16r10000 and: [self > -16r10000]) ifTrue: [^ 2].
	(self < 16r1000000 and: [self > -16r1000000]) ifTrue: [^ 3].
	^ 4! !

!SmallInteger methodsFor: 'system primitives'!
instVarAt: i 
	"Small integer has to be specially handled."

	i = 1 ifTrue: [^self].
	self error: 'argument too big for small integer instVarAt:'! !

!SmallInteger methodsFor: 'system primitives' stamp: 'tk 5/14/1999 20:54'!
nextInstance
	"SmallIntegers can't be enumerated this way.  There are a finite number of them from from (SmallInteger minVal) to (SmallInteger maxVal), but you'll have to enumerate them yourself with:
	(SmallInteger minVal) to: (SmallInteger maxVal) do: [:integer | <your code here>].
	"

	self shouldNotImplement ! !


!SmallInteger methodsFor: 'private'!
fromString: str radix: radix

	| maxdigit c val |
	maxdigit _ 
		radix + (radix > 10
					ifTrue: [55 - 1]
					ifFalse: [48 - 1]).
	val _ 0.
	1 to: str size do: 
		[:i | 
		c _ str at: i.
		(c < 48 ifFalse: [c > maxdigit])
			ifTrue: [^false].
		val _ val * radix + (c <= 57
							ifTrue: [c - 48]
							ifFalse: 
								[c < 65 ifTrue: [^false].
								c - 55])].
	^val! !

!SmallInteger methodsFor: 'private' stamp: 'sr 6/8/2000 01:14'!
highBitOfPositiveReceiver
	| shifted bitNo |
	"Answer the index of the high order bit of the receiver, or zero if the 
	receiver is zero. Receiver has to be positive!!"
	shifted _ self.
	bitNo _ 0.
	[shifted < 16]
		whileFalse: 
			[shifted _ shifted bitShift: -4.
			bitNo _ bitNo + 4].
	[shifted = 0]
		whileFalse: 
			[shifted _ shifted bitShift: -1.
			bitNo _ bitNo + 1].
	^ bitNo! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SmallInteger class
	instanceVariableNames: ''!

!SmallInteger class methodsFor: 'instance creation' stamp: 'tk 4/20/1999 14:17'!
basicNew

	self error: 'SmallIntegers can only be created by performing arithmetic'! !

!SmallInteger class methodsFor: 'instance creation' stamp: 'tk 4/20/1999 14:18'!
new

	self basicNew	"generates an error"! !


!SmallInteger class methodsFor: 'constants'!
maxVal
	"Answer the maximum value for a SmallInteger."
	^ 16r3FFFFFFF! !

!SmallInteger class methodsFor: 'constants'!
minVal
	"Answer the minimum value for a SmallInteger."
	^ -16r40000000! !


!SmallInteger class methodsFor: 'documentation'!
guideToDivision
	"Handy guide to the kinds of Integer division: 
	/  exact division, returns a fraction if result is not a whole integer. 
	//  returns an Integer, rounded towards negative infinity. 
	\\ is modulo rounded towards negative infinity. 
	quo:  truncated division, rounded towards zero."! !

Float initialize!




Integer variableByteSubclass: #LargePositiveInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel-Numbers'!
!LargePositiveInteger commentStamp: '<historical>' prior: 0!
I represent positive integers of more than 30 bits (ie, >= 1073741824).  These values are beyond the range of SmallInteger, and are encoded here as an array of 8-bit digits.  Care must be taken, when new values are computed, that any result that COULD BE a SmallInteger IS a SmallInteger (see normalize).

Note that the bit manipulation primitives, bitAnd:, bitShift:, etc., = and ~= run without failure (and therefore fast) if the value fits in 32 bits.  This is a great help to the simulator.!


!LargePositiveInteger methodsFor: 'arithmetic'!
* anInteger 
	"Primitive. Multiply the receiver by the argument and answer with an
	Integer result. Fail if either the argument or the result is not a
	SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824). Optional. See
	Object documentation whatIsAPrimitive. "

	<primitive: 29>
	^super * anInteger! !

!LargePositiveInteger methodsFor: 'arithmetic'!
+ anInteger 
	"Primitive. Add the receiver to the argument and answer with an
	Integer result. Fail if either the argument or the result is not a
	SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824). Optional. See
	Object documentation whatIsAPrimitive."

	<primitive: 21>
	^super + anInteger! !

!LargePositiveInteger methodsFor: 'arithmetic'!
- anInteger 
	"Primitive. Subtract the argument from the receiver and answer with an
	Integer result. Fail if either the argument or the result is not a
	SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824). Optional. See
	Object documentation whatIsAPrimitive."

	<primitive: 22>
	^super - anInteger! !

!LargePositiveInteger methodsFor: 'arithmetic'!
/ anInteger 
	"Primitive. Divide the receiver by the argument and answer with the
	result if the division is exact. Fail if the result is not a whole integer.
	Fail if the argument is 0. Fail if either the argument or the result is not
	a SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824). Optional. See
	Object documentation whatIsAPrimitive. "

	<primitive: 30>
	^super / anInteger! !

!LargePositiveInteger methodsFor: 'arithmetic'!
// anInteger 
	"Primitive. Divide the receiver by the argument and return the result.
	Round the result down towards negative infinity to make it a whole
	integer. Fail if the argument is 0. Fail if either the argument or the
	result is not a SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824).
	Optional. See Object documentation whatIsAPrimitive. "

	<primitive: 32>
	^super // anInteger! !

!LargePositiveInteger methodsFor: 'arithmetic'!
\\ anInteger 
	"Primitive. Take the receiver modulo the argument. The result is the
	remainder rounded towards negative infinity, of the receiver divided
	by the argument. Fail if the argument is 0. Fail if either the argument
	or the result is not a SmallInteger or a LargePositiveInteger less than
	2-to-the-30th (1073741824). Optional. See Object documentation whatIsAPrimitive."

	<primitive: 31>
	^super \\ anInteger! !

!LargePositiveInteger methodsFor: 'arithmetic' stamp: 'RAA 5/31/2000 13:21'!
\\\ anInteger 
	"a faster modulo method for use in DSA. Be careful if you try to use this elsewhere"

	^(self digitDiv: anInteger neg: false) second! !

!LargePositiveInteger methodsFor: 'arithmetic'!
abs! !

!LargePositiveInteger methodsFor: 'arithmetic'!
negated 
	^ (self copyto: (LargeNegativeInteger new: self digitLength))
		normalize  "Need to normalize to catch SmallInteger minVal"! !

!LargePositiveInteger methodsFor: 'arithmetic'!
quo: anInteger 
	"Primitive. Divide the receiver by the argument and return the result.
	Round the result down towards zero to make it a whole integer. Fail if
	the argument is 0. Fail if either the argument or the result is not a
	SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824). Optional. See
	Object documentation whatIsAPrimitive."

	<primitive: 33>
	^super quo: anInteger! !


!LargePositiveInteger methodsFor: 'bit manipulation'!
bitAnd: anInteger 
	"Primitive. Answer an Integer whose bits are the logical AND of the
	receiver's bits and those of the argument. Fail if the receiver or argument
	is greater than 32 bits. See Object documentation whatIsAPrimitive."
	<primitive: 14>
	^ super bitAnd: anInteger! !

!LargePositiveInteger methodsFor: 'bit manipulation'!
bitOr: anInteger 
	"Primitive. Answer an Integer whose bits are the logical OR of the
	receiver's bits and those of the argument. Fail if the receiver or argument
	is greater than 32 bits. See Object documentation whatIsAPrimitive."
	<primitive: 15>
	^ super bitOr: anInteger! !

!LargePositiveInteger methodsFor: 'bit manipulation'!
bitShift: anInteger 
	"Primitive. Answer an Integer whose value (in twos-complement 
	representation) is the receiver's value (in twos-complement
	representation) shifted left by the number of bits indicated by the
	argument. Negative arguments shift right. Zeros are shifted in from the
	right in left shifts. The sign bit is extended in right shifts.
	Fail if the receiver or result is greater than 32 bits.
	See Object documentation whatIsAPrimitive."
	<primitive: 17>
	^super bitShift: anInteger! !

!LargePositiveInteger methodsFor: 'bit manipulation'!
bitXor: anInteger 
	"Primitive. Answer an Integer whose bits are the logical XOR of the
	receiver's bits and those of the argument. Fail if the receiver or argument
	is greater than 32 bits. See Object documentation whatIsAPrimitive."
	<primitive: 16>
	^ super bitXor: anInteger! !

!LargePositiveInteger methodsFor: 'bit manipulation' stamp: 'sr 6/8/2000 02:11'!
highBit
	"Answer the index of the high order bit of the receiver, or zero if the  
	receiver is zero. Raise an error if the receiver is negative, since  
	negative integers are defined to have an infinite number of leading 1's 
	in 2's-complement arithmetic. Use >>highBitOfMagnitude if you want to  
	get the highest bit of the magnitude."
	^ self highBitOfMagnitude! !

!LargePositiveInteger methodsFor: 'bit manipulation' stamp: 'sr 6/8/2000 02:15'!
highBitOfMagnitude
	"Answer the index of the high order bit of the magnitude of the  
	receiver, or zero if the receiver is zero.  
	This method is used for LargeNegativeIntegers as well,  
	since Squeak's LargeIntegers are sign/magnitude."
	| realLength lastDigit |
	realLength _ self digitLength.
	[(lastDigit _ self digitAt: realLength) = 0]
		whileTrue: [(realLength _ realLength - 1) = 0 ifTrue: [^ 0]].
	^ lastDigit highBitOfPositiveReceiver + (8 * (realLength - 1))! !


!LargePositiveInteger methodsFor: 'testing' stamp: 'di 4/23/1998 11:18'!
negative
	"Answer whether the receiver is mathematically negative."

	^ false! !

!LargePositiveInteger methodsFor: 'testing' stamp: 'jm 3/27/98 06:19'!
sign
	"Optimization. Answer 1 since receiver is greater than 0."

	^ 1
! !


!LargePositiveInteger methodsFor: 'comparing'!
< anInteger 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is less than the argument. Otherwise answer false. Fail if the
	argument is not a SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824).
	Optional. See Object documentation whatIsAPrimitive."

	<primitive: 23>
	^super < anInteger! !

!LargePositiveInteger methodsFor: 'comparing'!
<= anInteger 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is less than or equal to the argument. Otherwise answer false.
	Fail if the argument is not a SmallInteger or a LargePositiveInteger less
	than 2-to-the-30th (1073741824). Optional. See Object documentation whatIsAPrimitive."

	<primitive: 25>
	^super <= anInteger! !

!LargePositiveInteger methodsFor: 'comparing'!
= anInteger 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is equal to the argument. Otherwise answer false. Fail if the
	receiver or argument is negative or greater than 32 bits.
	Optional. See Object documentation whatIsAPrimitive."

	<primitive: 7>
	^ super = anInteger! !

!LargePositiveInteger methodsFor: 'comparing'!
> anInteger 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is greater than the argument. Otherwise answer false. Fail if
	the argument is not a SmallInteger or a LargePositiveInteger less than
	2-to-the-30th (1073741824). Optional. See Object documentation whatIsAPrimitive."

	<primitive: 24>
	^super > anInteger! !

!LargePositiveInteger methodsFor: 'comparing'!
>= anInteger 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is greater than or equal to the argument. Otherwise answer
	false. Fail if the argument is not a SmallInteger or a LargePositiveInteger
	less than 2-to-the-30th (1073741824). Optional. See Object documentation whatIsAPrimitive."

	<primitive: 26>
	^super >= anInteger! !

!LargePositiveInteger methodsFor: 'comparing'!
~= anInteger 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is equal to the argument. Otherwise answer false. Fail if the
	receiver or argument is negative or greater than 32 bits.
	Optional. See Object documentation whatIsAPrimitive."

	<primitive: 8>
	^ super ~= anInteger! !


!LargePositiveInteger methodsFor: 'converting' stamp: 'ar 5/17/2000 16:09'!
normalize
	"Check for leading zeroes and return shortened copy if so"
	| sLen val len oldLen |
	<primitive: 'primNormalizePositive' module:'LargeIntegers'>
	"First establish len = significant length"
	len _ oldLen _ self digitLength.
	[len = 0 ifTrue: [^0].
	(self digitAt: len) = 0]
		whileTrue: [len _ len - 1].

	"Now check if in SmallInteger range"
	sLen _ SmallInteger maxVal digitLength.
	(len <= sLen
		and: [(self digitAt: sLen) <= (SmallInteger maxVal digitAt: sLen)])
		ifTrue: ["If so, return its SmallInt value"
				val _ 0.
				len to: 1 by: -1 do:
					[:i | val _ (val *256) + (self digitAt: i)].
				^ val].

	"Return self, or a shortened copy"
	len < oldLen
		ifTrue: [^ self growto: len]
		ifFalse: [^ self]! !


!LargePositiveInteger methodsFor: 'system primitives' stamp: 'tk 3/24/1999 20:28'!
digitAt: index 
	"Primitive. Answer the value of an indexable field in the receiver.   LargePositiveInteger uses bytes of base two number, and each is a 'digit' base 256.  Fail if the argument (the index) is not an Integer or is out of bounds. Essential.  See Object documentation whatIsAPrimitive."

	<primitive: 60>
	self digitLength < index
		ifTrue: [^0]
		ifFalse: [^super at: index]! !

!LargePositiveInteger methodsFor: 'system primitives'!
digitAt: index put: value 
	"Primitive. Store the second argument (value) in the indexable field of 
	the receiver indicated by index. Fail if the value is negative or is larger 
	than 255. Fail if the index is not an Integer or is out of bounds. Answer 
	the value that was stored. Essential. See Object documentation 
	whatIsAPrimitive."

	<primitive: 61>
	^super at: index put: value! !

!LargePositiveInteger methodsFor: 'system primitives'!
digitLength
	"Primitive. Answer the number of indexable fields in the receiver. This 
	value is the same as the largest legal subscript. Essential. See Object 
	documentation whatIsAPrimitive."

	<primitive: 62>
	self primitiveFailed! !

!LargePositiveInteger methodsFor: 'system primitives'!
replaceFrom: start to: stop with: replacement startingAt: repStart 
	"Primitive. This destructively replaces elements from start to stop in the receiver starting at index, repStart, in the collection, replacement. Answer the receiver. Range checks are performed in the primitive only. Optional. See Object documentation whatIsAPrimitive."
	<primitive: 105>
	^ super replaceFrom: start to: stop with: replacement startingAt: repStart! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

LargePositiveInteger class
	instanceVariableNames: ''!

!LargePositiveInteger class methodsFor: 'testing'!
test: n  "Time millisecondsToRun: [LargePositiveInteger test: 100] 1916"
	| f f1 |
	"Test and time mult, div, add, subtract"
	f _ n factorial.
	f1 _ f*(n+1).
	n timesRepeat: [f1 _ f1 - f].
	f1 = f ifFalse: [self halt].
	n timesRepeat: [f1 _ f1 + f].
	f1 // f = (n+1) ifFalse: [self halt].
	f1 negated = (Number readFrom: '-' , f1 printString) ifFalse: [self halt].

	"Check normalization and conversion to/from SmallInts"
	(SmallInteger maxVal + 1 - 1) == SmallInteger maxVal ifFalse: [self halt].
	(SmallInteger maxVal + 3 - 6) == (SmallInteger maxVal-3) ifFalse: [self halt].
	(SmallInteger minVal - 1 + 1) == SmallInteger minVal ifFalse: [self halt].
	(SmallInteger minVal - 3 + 6) == (SmallInteger minVal+3) ifFalse: [self halt].

	"Check bitShift from and back to SmallInts"
	1 to: 257 do: [:i | ((i bitShift: i) bitShift: 0-i) == i ifFalse: [self halt]].
! !

!LargePositiveInteger class methodsFor: 'testing' stamp: 'sr 6/10/2000 18:24'!
testTwoComplementRightShift
	"self testTwoComplementRightShift"
	| large small |
	small _ 2 << 16.
	large _ 2 << 32.
	"2-complement test"
	(small negated bitShift: -1) ~= ((small + 1) negated bitShift: -1)
		== ((large negated bitShift: -1) ~= ((large + 1) negated bitShift: -1))
		ifFalse: [^ self inform: 'ERROR: Two-complement shifts of negative Integers are NOT consistent!!'].
	(small bitShift: -1) ~= (small + 1 bitShift: -1)
		== ((large bitShift: -1) ~= (large + 1 bitShift: -1))
		ifFalse: [^ self inform: 'ERROR: Two-complement shifts of negative Integers are NOT consistent!!'].
	^ self inform: 'OK: Two-complement shifts of negative Integers are consistent!!'.! !


LargePositiveInteger variableByteSubclass: #LargeNegativeInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel-Numbers'!
!LargeNegativeInteger commentStamp: '<historical>' prior: 0!
Just like LargePositiveInteger, but represents a negative number.!


!LargeNegativeInteger methodsFor: 'arithmetic'!
abs
	^ self negated! !

!LargeNegativeInteger methodsFor: 'arithmetic'!
negated
	^ self copyto: (LargePositiveInteger new: self digitLength)! !


!LargeNegativeInteger methodsFor: 'bit manipulation' stamp: 'sr 6/8/2000 02:10'!
highBit
	"Answer the index of the high order bit of the receiver, or zero if the  
	receiver is zero. Raise an error if the receiver is negative, since  
	negative integers are defined to have an infinite number of leading 1's 
	in 2's-complement arithmetic. Use >>highBitOfMagnitude if you want to  
	get the highest bit of the magnitude."

	^ self shouldNotImplement! !


!LargeNegativeInteger methodsFor: 'converting' stamp: 'ar 5/17/2000 16:10'!
normalize
	"Check for leading zeroes and return shortened copy if so"
	| sLen val len oldLen minVal |
	<primitive: 'primNormalizeNegative' module:'LargeIntegers'>
	"First establish len = significant length"
	len _ oldLen _ self digitLength.
	[len = 0 ifTrue: [^0].
	(self digitAt: len) = 0]
		whileTrue: [len _ len - 1].

	"Now check if in SmallInteger range"
	sLen _ 4  "SmallInteger minVal digitLength".
	len <= sLen ifTrue:
		[minVal _ SmallInteger minVal.
		(len < sLen
			or: [(self digitAt: sLen) < minVal lastDigit])
			ifTrue: ["If high digit less, then can be small"
					val _ 0.
					len to: 1 by: -1 do:
						[:i | val _ (val *256) - (self digitAt: i)].
					^ val].
		1 to: sLen do:  "If all digits same, then = minVal"
			[:i | (self digitAt: i) = (minVal digitAt: i)
					ifFalse: ["Not so; return self shortened"
							len < oldLen
								ifTrue: [^ self growto: len]
								ifFalse: [^ self]]].
		^ minVal].

	"Return self, or a shortened copy"
	len < oldLen
		ifTrue: [^ self growto: len]
		ifFalse: [^ self]! !


!LargeNegativeInteger methodsFor: 'testing' stamp: 'di 4/23/1998 11:18'!
negative
	"Answer whether the receiver is mathematically negative."

	^ true! !

!LargeNegativeInteger methodsFor: 'testing' stamp: 'jm 3/27/98 06:19'!
sign
	"Optimization. Answer -1 since receiver is less than 0."

	^ -1
! !


Object subclass: #Collection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Collections-Abstract'!
!Collection commentStamp: '<historical>' prior: 0!
I am the abstract superclass of all classes that represent a group of elements.!


!Collection methodsFor: 'accessing' stamp: 'jm 11/9/2002 23:00'!
average
	"Answer the average of my elements. Assume I contain only numbers."

	^ self sum asFloat / self size
! !

!Collection methodsFor: 'accessing' stamp: 'jm 5/29/2003 19:32'!
contents
	"Compatibility with streams."

	^ self
! !

!Collection methodsFor: 'accessing' stamp: 'jm 5/29/2003 19:38'!
max
	"Answer the maximum element of this collection. Raise an error if the collection is empty."

	^ self inject: self anyOne into: [:max :each | max max: each]
! !

!Collection methodsFor: 'accessing' stamp: 'jm 5/29/2003 19:38'!
min
	"Answer the minimum element of this collection. Raise an error if the collection is empty."

	^ self inject: self anyOne into: [:min :each | min min: each]
! !

!Collection methodsFor: 'accessing' stamp: 'sma 5/12/2000 11:34'!
size
	"Answer how many elements the receiver contains."

	| tally |
	tally _ 0.
	self do: [:each | tally _ tally + 1].
	^ tally! !

!Collection methodsFor: 'accessing' stamp: 'jm 5/29/2003 19:44'!
sum
	"Answer the sum of the elements of this collection. Answer zero if the collection is empty."
	"Details: To allow collections of any kind of object that understands + and - to be summed, the inital sum is an arbitrary sample element (as opposed to 0). This initial value is then subtracted from the final sum."

	| sum sample |
	self size = 0 ifTrue: [^ 0].
	sample _ self anyOne.
	sum _ self inject: sample into: [:accum :each | accum + each].
	^ sum - sample
! !


!Collection methodsFor: 'adding'!
add: newObject 
	"Include newObject as one of the receiver's elements. Answer newObject. 
	ArrayedCollections cannot respond to this message."

	self subclassResponsibility! !

!Collection methodsFor: 'adding' stamp: 'sma 5/12/2000 17:26'!
addAll: aCollection 
	"Include all the elements of aCollection as the receiver's elements. Answer 
	aCollection. Actually, any object responding to #do: can be used as argument."

	aCollection do: [:each | self add: each].
	^ aCollection! !


!Collection methodsFor: 'comparing' stamp: 'sma 5/12/2000 12:08'!
hash
	"A default hash function for any collection.  Note that this method is 
	insensitive to contents when the size is greater than 10, so critical 
	applications that compare many large collections of the same length 
	will want to refine this behavior."

	| hash |
	hash _ self species hash.
	self size <= 10 ifTrue: [self do: [:elem | hash _ hash bitXor: elem hash]].
	^ hash bitXor: self size hash! !


!Collection methodsFor: 'converting' stamp: 'sma 5/6/2000 20:22'!
asArray
	"Answer an Array whose elements are the elements of the receiver.
	Implementation note: Cannot use ''Array withAll: self'' as that only
	works for SequenceableCollections which support the replacement 
	primitive."

	| array index |
	array _ Array new: self size.
	index _ 0.
	self do: [:each | array at: (index _ index + 1) put: each].
	^ array! !

!Collection methodsFor: 'converting' stamp: 'sma 5/6/2000 20:10'!
asBag
	"Answer a Bag whose elements are the elements of the receiver."

	^ Bag withAll: self! !

!Collection methodsFor: 'converting' stamp: 'sma 5/6/2000 20:22'!
asByteArray
	"Answer a ByteArray whose elements are the elements of the receiver.
	Implementation note: Cannot use ''ByteArray withAll: self'' as that only
	works for SequenceableCollections which support the replacement 
	primitive."

	| array index |
	array _ ByteArray new: self size.
	index _ 0.
	self do: [:each | array at: (index _ index + 1) put: each].
	^ array! !

!Collection methodsFor: 'converting' stamp: 'sma 5/6/2000 20:29'!
asSet
	"Answer a Set whose elements are the unique elements of the receiver."

	^ Set withAll: self! !

!Collection methodsFor: 'converting' stamp: 'sma 5/12/2000 17:44'!
asSortedCollection
	"Answer a SortedCollection whose elements are the elements of the 
	receiver. The sort order is the default less than or equal."

	^ self as: SortedCollection! !

!Collection methodsFor: 'converting' stamp: 'sma 5/12/2000 17:46'!
asSortedCollection: aSortBlock 
	"Answer a SortedCollection whose elements are the elements of the 
	receiver. The sort order is defined by the argument, aSortBlock."

	| aSortedCollection |
	aSortedCollection _ SortedCollection new: self size.
	aSortedCollection sortBlock: aSortBlock.
	aSortedCollection addAll: self.
	^ aSortedCollection! !


!Collection methodsFor: 'copying' stamp: 'sma 5/12/2000 14:41'!
copyWith: newElement
	"Answer a new collection with newElement added (as last
	element if sequenceable)."

	^ self copy
		add: newElement;
		yourself! !

!Collection methodsFor: 'copying' stamp: 'sma 5/12/2000 14:43'!
copyWithout: oldElement 
	"Answer a copy of the receiver that does not contain any
	elements equal to oldElement."

	^ self reject: [:each | each = oldElement]

"Examples:
	'fred the bear' copyWithout: $e
	#(2 3 4 5 5 6) copyWithout: 5
"! !


!Collection methodsFor: 'enumerating' stamp: 'sma 4/30/2000 11:17'!
anySatisfy: aBlock
	"Evaluate aBlock with the elements of the receiver.
	If aBlock returns true for any element return true.
	Otherwise return false."

	self do: [:each | (aBlock value: each) ifTrue: [^ true]].
	^ false! !

!Collection methodsFor: 'enumerating'!
associationsDo: aBlock
	"Evaluate aBlock for each of the receiver's elements (key/value 
	associations).  If any non-association is within, the error is not caught now,
	but later, when a key or value message is sent to it."

	self do: aBlock! !

!Collection methodsFor: 'enumerating' stamp: 'sma 5/12/2000 11:45'!
collect: aBlock 
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	Collect the resulting values into a collection like the receiver. Answer  
	the new collection."

	| newCollection |
	newCollection _ self species new.
	self do: [:each | newCollection add: (aBlock value: each)].
	^ newCollection! !

!Collection methodsFor: 'enumerating' stamp: 'sma 5/12/2000 11:20'!
detect: aBlock 
	"Evaluate aBlock with each of the receiver's elements as the argument. 
	Answer the first element for which aBlock evaluates to true."

	^ self detect: aBlock ifNone: [self errorNotFound: aBlock]! !

!Collection methodsFor: 'enumerating' stamp: 'sma 5/12/2000 11:52'!
detect: aBlock ifNone: exceptionBlock 
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	Answer the first element for which aBlock evaluates to true. If none  
	evaluate to true, then evaluate the argument, exceptionBlock."

	self do: [:each | (aBlock value: each) ifTrue: [^ each]].
	^ exceptionBlock value! !

!Collection methodsFor: 'enumerating'!
do: aBlock 
	"Evaluate aBlock with each of the receiver's elements as the argument."

	self subclassResponsibility! !

!Collection methodsFor: 'enumerating'!
inject: thisValue into: binaryBlock 
	"Accumulate a running value associated with evaluating the argument, 
	binaryBlock, with the current value of the argument, thisValue, and the 
	receiver as block arguments. For instance, to sum the numeric elements 
	of a collection, aCollection inject: 0 into: [:subTotal :next | subTotal + 
	next]."

	| nextValue |
	nextValue _ thisValue.
	self do: [:each | nextValue _ binaryBlock value: nextValue value: each].
	^nextValue! !

!Collection methodsFor: 'enumerating'!
occurrencesOf: anObject 
	"Answer how many of the receiver's elements are equal to anObject."

	| tally |
	tally _ 0.
	self do: [:each | anObject = each ifTrue: [tally _ tally + 1]].
	^tally! !

!Collection methodsFor: 'enumerating'!
reject: aBlock 
	"Evaluate aBlock with each of the receiver's elements as the argument. 
	Collect into a new collection like the receiver only those elements for 
	which aBlock evaluates to false. Answer the new collection."

	^self select: [:element | (aBlock value: element) == false]! !

!Collection methodsFor: 'enumerating'!
select: aBlock 
	"Evaluate aBlock with each of the receiver's elements as the argument. 
	Collect into a new collection like the receiver, only those elements for 
	which aBlock evaluates to true. Answer the new collection."

	| newCollection |
	newCollection _ self species new.
	self do: [:each | (aBlock value: each) ifTrue: [newCollection add: each]].
	^newCollection! !

!Collection methodsFor: 'enumerating' stamp: 'sma 5/12/2000 11:59'!
select: selectBlock thenCollect: collectBlock
	"Utility method to improve readability."

	^ (self select: selectBlock) collect: collectBlock! !


!Collection methodsFor: 'removing' stamp: 'sma 5/12/2000 11:22'!
remove: oldObject 
	"Remove oldObject from the receiver's elements. Answer oldObject 
	unless no element is equal to oldObject, in which case, raise an error.
	ArrayedCollections cannot respond to this message."

	^ self remove: oldObject ifAbsent: [self errorNotFound: oldObject]! !

!Collection methodsFor: 'removing' stamp: 'sma 5/12/2000 11:14'!
remove: oldObject ifAbsent: anExceptionBlock 
	"Remove oldObject from the receiver's elements. If several of the 
	elements are equal to oldObject, only one is removed. If no element is 
	equal to oldObject, answer the result of evaluating anExceptionBlock. 
	Otherwise, answer the argument, oldObject. ArrayedCollections cannot 
	respond to this message."

	self subclassResponsibility! !

!Collection methodsFor: 'removing' stamp: 'jm 5/29/2003 19:48'!
removeAll: aCollection 
	"Remove each element of aCollection which is present in the receiver from the receiver. Answer aCollection. No error is raised if an element isn't found. ArrayedCollections cannot respond to this message."

	aCollection do: [:each | self remove: each ifAbsent: []].
	^ aCollection
! !

!Collection methodsFor: 'removing' stamp: 'sma 5/12/2000 11:19'!
removeAllSuchThat: aBlock 
	"Evaluate aBlock for each element and remove all that elements from
	the receiver for that aBlock evaluates to true.  Use a copy to enumerate 
	collections whose order changes when an element is removed (i.e. Sets)."

	self copy do: [:each | (aBlock value: each) ifTrue: [self remove: each]]! !


!Collection methodsFor: 'testing' stamp: 'sma 5/12/2000 14:07'!
includes: anObject 
	"Answer whether anObject is one of the receiver's elements."

	^ self anySatisfy: [:each | each = anObject]! !

!Collection methodsFor: 'testing'!
includesAnyOf: aCollection 
	"Answer whether any element of aCollection is one of the receiver's elements."
	aCollection do: [:elem | (self includes: elem) ifTrue: [^ true]].
	^ false! !

!Collection methodsFor: 'testing' stamp: 'jm 1/1/2009 16:59'!
isCollection
	"Answer true if I represent a Collection."

	^ true
! !

!Collection methodsFor: 'testing'!
isEmpty
	"Answer whether the receiver contains any elements."

	^self size = 0! !

!Collection methodsFor: 'testing' stamp: 'sw 4/7/1999 17:28'!
isEmptyOrNil
	"Answer whether the receiver contains any elements, or is nil.  Useful in numerous situations where one wishes the same reaction to an empty collection or to nil"

	^ self size = 0! !


!Collection methodsFor: 'printing' stamp: 'sma 6/1/2000 09:39'!
printElementsOn: aStream
	aStream nextPut: $(.
	self do: [:element | aStream print: element; space].
	self isEmpty ifFalse: [aStream skip: -1].
	aStream nextPut: $)! !

!Collection methodsFor: 'printing' stamp: 'sma 6/1/2000 09:41'!
printNameOn: aStream
	super printOn: aStream! !

!Collection methodsFor: 'printing' stamp: 'sma 6/1/2000 09:41'!
printOn: aStream 
	"Append a sequence of characters that identify the receiver to aStream."

	self printNameOn: aStream.
	self printElementsOn: aStream! !

!Collection methodsFor: 'printing'!
storeOn: aStream 
	"Refer to the comment in Object|storeOn:."

	| noneYet |
	aStream nextPutAll: '(('.
	aStream nextPutAll: self class name.
	aStream nextPutAll: ' new)'.
	noneYet _ true.
	self do: 
		[:each | 
		noneYet
			ifTrue: [noneYet _ false]
			ifFalse: [aStream nextPut: $;].
		aStream nextPutAll: ' add: '.
		aStream store: each].
	noneYet ifFalse: [aStream nextPutAll: '; yourself'].
	aStream nextPut: $)! !


!Collection methodsFor: 'private' stamp: 'sma 5/12/2000 11:33'!
anyOne
	"Answer a representative sample of the receiver. This method can
	be helpful when needing to preinfer the nature of the contents of 
	semi-homogeneous collections."

	self emptyCheck.
	self do: [:each | ^ each]! !

!Collection methodsFor: 'private'!
emptyCheck

	self isEmpty ifTrue: [self errorEmptyCollection]! !

!Collection methodsFor: 'private'!
errorEmptyCollection

	self error: 'this collection is empty'! !

!Collection methodsFor: 'private'!
errorNoMatch

	self error: 'collection sizes do not match'! !

!Collection methodsFor: 'private' stamp: 'sma 5/12/2000 11:22'!
errorNotFound: anObject
	"Actually, this should raise a special Exception not just an error."

	self error: 'Object is not in the collection.'! !

!Collection methodsFor: 'private'!
errorNotKeyed

	self error: self class name, 's do not respond to keyed accessing messages.'! !

!Collection methodsFor: 'private'!
toBraceStack: itsSize 
	"Push receiver's elements onto the stack of thisContext sender.  Error if receiver does
	 not have itsSize elements or if receiver is unordered.
	 Do not call directly: this is called by {a. b} _ ... constructs."

	self size ~= itsSize ifTrue:
		[self error: 'Trying to store ', self size printString,
					' values into ', itsSize printString, ' variables.'].
	thisContext sender push: itsSize fromIndexable: self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Collection class
	instanceVariableNames: ''!

!Collection class methodsFor: 'instance creation' stamp: 'sma 5/6/2000 19:58'!
with: anObject 
	"Answer an instance of me containing anObject."

	^ self new
		add: anObject;
		yourself! !

!Collection class methodsFor: 'instance creation' stamp: 'sma 5/6/2000 20:01'!
with: firstObject with: secondObject 
	"Answer an instance of me containing the two arguments as elements."

	^ self new
		add: firstObject;
		add: secondObject;
		yourself! !

!Collection class methodsFor: 'instance creation' stamp: 'sma 5/6/2000 20:03'!
with: firstObject with: secondObject with: thirdObject 
	"Answer an instance of me containing the three arguments as elements."

	^ self new
		add: firstObject;
		add: secondObject;
		add: thirdObject;
		yourself! !

!Collection class methodsFor: 'instance creation' stamp: 'sma 5/6/2000 20:06'!
with: firstObject with: secondObject with: thirdObject with: fourthObject 
	"Answer an instance of me, containing the four arguments as the elements."

	^ self new
		add: firstObject;
		add: secondObject;
		add: thirdObject;
		add: fourthObject;
		yourself! !

!Collection class methodsFor: 'instance creation' stamp: 'sma 5/6/2000 20:06'!
with: firstObject with: secondObject with: thirdObject with: fourthObject with: fifthObject
	"Answer an instance of me, containing the five arguments as the elements."

	^ self new
		add: firstObject;
		add: secondObject;
		add: thirdObject;
		add: fourthObject;
		add: fifthObject;
		yourself! !

!Collection class methodsFor: 'instance creation' stamp: 'sma 5/6/2000 20:06'!
with: firstObject with: secondObject with: thirdObject with: fourthObject with: fifthObject with: sixthObject
	"Answer an instance of me, containing the six arguments as the elements."

	^ self new
		add: firstObject;
		add: secondObject;
		add: thirdObject;
		add: fourthObject;
		add: fifthObject;
		add: sixthObject;
		yourself! !

!Collection class methodsFor: 'instance creation' stamp: 'sma 5/6/2000 20:07'!
withAll: aCollection
	"Create a new collection containing all the elements from aCollection."

	^ (self new: aCollection size)
		addAll: aCollection;
		yourself! !


Collection subclass: #CharacterSet
	instanceVariableNames: 'map '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Collections-Text'!
!CharacterSet commentStamp: '<historical>' prior: 0!
A set of characters.  Lookups for inclusion are very fast.!


!CharacterSet methodsFor: 'collection ops' stamp: 'ls 8/17/1998 20:33'!
add: aCharacter
	map at: aCharacter asciiValue+1  put: 1.! !

!CharacterSet methodsFor: 'collection ops' stamp: 'ls 8/17/1998 20:41'!
do: aBlock
	"evaluate aBlock with each character in the set"

	Character allCharacters do: [ :c |
		(self includes: c) ifTrue: [ aBlock value: c ] ]
! !

!CharacterSet methodsFor: 'collection ops' stamp: 'ls 8/17/1998 20:31'!
includes: aCharacter
	^(map at: aCharacter asciiValue + 1) > 0! !

!CharacterSet methodsFor: 'collection ops' stamp: 'ls 8/17/1998 20:34'!
remove: aCharacter
	map at: aCharacter asciiValue + 1  put: 0! !


!CharacterSet methodsFor: 'conversion' stamp: 'ls 8/17/1998 20:39'!
complement
	"return a character set containing precisely the characters the receiver does not"
	| set |
	set _ CharacterSet allCharacters.
	self do: [ :c | set remove: c ].
	^set! !


!CharacterSet methodsFor: 'comparison' stamp: 'ls 8/17/1998 20:46'!
= anObject
	^self class == anObject class and: [
		self byteArrayMap = anObject byteArrayMap ]! !

!CharacterSet methodsFor: 'comparison' stamp: 'ls 8/17/1998 20:46'!
hash
	^self byteArrayMap hash! !


!CharacterSet methodsFor: 'private' stamp: 'ls 8/17/1998 20:35'!
byteArrayMap
	"return a ByteArray mapping each ascii value to a 1 if that ascii value is in the set, and a 0 if it isn't.  Intended for use by primitives only"
	^map! !

!CharacterSet methodsFor: 'private' stamp: 'ls 8/17/1998 20:30'!
initialize
	map _ ByteArray new: 256 withAll: 0.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

CharacterSet class
	instanceVariableNames: ''!

!CharacterSet class methodsFor: 'instance creation' stamp: 'ls 8/17/1998 20:42'!
allCharacters
	"return a set containing all characters"

	| set |
	set _ self empty.
	0 to: 255 do: [ :ascii | set add: (Character value: ascii) ].
	^set! !

!CharacterSet class methodsFor: 'instance creation' stamp: 'ls 8/17/1998 20:36'!
empty
 	"return an empty set of characters"
	^super new initialize! !

!CharacterSet class methodsFor: 'instance creation' stamp: 'ls 1/3/1999 12:52'!
newFrom: aCollection
	| newCollection |
	newCollection _ self new.
	newCollection addAll: aCollection.
	^newCollection! !

!CharacterSet class methodsFor: 'instance creation' stamp: 'ls 8/18/1998 00:40'!
nonSeparators
	"return a set containing everything but the whitespace characters"

	^self separators complement! !

!CharacterSet class methodsFor: 'instance creation' stamp: 'ls 8/18/1998 00:40'!
separators
	"return a set containing just the whitespace characters"

	| set |
	set _ self empty.
	set addAll: Character separators.
	^set! !


Collection subclass: #SequenceableCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Collections-Abstract'!
!SequenceableCollection commentStamp: '<historical>' prior: 0!
I am an abstract superclass for collections that have a well-defined order associated with their elements. Thus each element is externally-named by integers referred to as indices.!


!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 6/1/2000 15:34'!
allButFirst
	"Answer a copy of the receiver containing all but the first
	element. Raise an error if there are not enough elements."

	^ self allButFirst: 1! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 6/1/2000 15:35'!
allButFirst: n
	"Answer a copy of the receiver containing all but the first n
	elements. Raise an error if there are not enough elements."

	^ self copyFrom: n + 1 to: self size! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 6/1/2000 15:35'!
allButLast
	"Answer a copy of the receiver containing all but the last
	element. Raise an error if there are not enough elements."

	^ self allButLast: 1! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 6/1/2000 15:35'!
allButLast: n
	"Answer a copy of the receiver containing all but the last n
	elements. Raise an error if there are not enough elements."

	^ self copyFrom: 1 to: self size - n! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 5/12/2000 12:11'!
at: index ifAbsent: exceptionBlock 
	"Answer the element at my position index. If I do not contain an element 
	at index, answer the result of evaluating the argument, exceptionBlock."

	(index between: 1 and: self size) ifTrue: [^ self at: index].
	^ exceptionBlock value! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 5/12/2000 12:14'!
atAll: indexArray
	"Answer a new collection like the receiver which contains all elements
	of the receiver at the indices of indexArray."

	| newCollection |
	newCollection _ self species new: indexArray size.
	1 to: indexArray size do:
		[:index |
		newCollection at: index put: (self at: (indexArray at: index))].
	^ newCollection! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 5/12/2000 12:17'!
atAll: aCollection put: anObject 
	"Put anObject at every index specified by the elements of aCollection."

	aCollection do: [:index | self at: index put: anObject].
	^ anObject! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 4/22/2000 17:45'!
atAllPut: anObject 
	"Put anObject at every one of the receiver's indices."

	| size |
	(size _ self size) > 26 "first method faster from 27 accesses and on"
		ifTrue: [self from: 1 to: size put: anObject]
		ifFalse: [1 to: size do: [:index | self at: index put: anObject]]! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'di 11/6/1998 14:32'!
atPin: index 
	"Return the index'th element of me if possible.
	Return the first or last element if index is out of bounds."

	index < 1 ifTrue: [^ self first].
	index > self size ifTrue: [^ self last].
	^ self at: index! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 5/12/2000 12:50'!
atRandom: aGenerator
	"Answer a random element of the receiver.  Uses aGenerator which
	should be kept by the user in a variable and used every time. Use
	this instead of #atRandom for better uniformity of random numbers 
	because only you use the generator.  Causes an error if self has no 
	elements."

	^ self at: (aGenerator nextInt: self size)! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 5/12/2000 13:51'!
atWrap: index 
	"Answer the index'th element of the receiver.  If index is out of bounds,
	let it wrap around from the end to the beginning until it is in bounds."

	^ self at: index - 1 \\ self size + 1! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 5/12/2000 13:52'!
atWrap: index put: value
	"Store value into the index'th element of the receiver.  If index is out
	of bounds, let it wrap around from the end to the beginning until it 
	is in bounds. Answer value."

	^ self at: index  - 1 \\ self size + 1 put: value! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'jm 6/20/2003 10:01'!
fifth
	"Answer the fifth element of the receiver."

	^ self at: 5
! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'jm 6/20/2003 10:01'!
first
	"Answer the first element of the receiver."

	^ self at: 1
! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 6/1/2000 15:31'!
first: n
	"Answer the first n elements of the receiver.
	Raise an error if there are not enough elements."

	^ self copyFrom: 1 to: n! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'jm 6/20/2003 10:01'!
fourth
	"Answer the fourth element of the receiver."

	^ self at: 4
! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 4/22/2000 17:52'!
from: startIndex to: endIndex put: anObject
	"Put anObject in all indexes between startIndex 
	and endIndex. Very fast. Faster than to:do: for
	more than 26 positions. No range checks are 
	performed. Answer anObject."

	| written toWrite thisWrite |
	self at: startIndex put: anObject.
	written _ 1.
	toWrite _ endIndex - startIndex + 1.
	[written < toWrite] whileTrue:
		[thisWrite _ written min: toWrite - written.
		self 
			replaceFrom: startIndex + written
			to: startIndex + written + thisWrite - 1
			with: self startingAt: startIndex.
		written _ written + thisWrite].
	^ anObject! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'ar 8/14/1998 21:21'!
identityIndexOf: anElement ifAbsent: exceptionBlock
	"Answer the index of anElement within the receiver. If the receiver does 
	not contain anElement, answer the result of evaluating the argument, 
	exceptionBlock."
	1 to: self size do:
		[:i | (self at: i) == anElement ifTrue: [^ i]].
	^ exceptionBlock value! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 6/1/2000 15:46'!
indexOf: anElement
	"Answer the index of the first occurence of anElement within the  
	receiver. If the receiver does not contain anElement, answer 0."

	^ self indexOf: anElement ifAbsent: [0]! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 6/1/2000 15:47'!
indexOf: anElement ifAbsent: exceptionBlock
	"Answer the index of the first occurence of anElement within the  
	receiver. If the receiver does not contain anElement, answer the 
	result of evaluating the argument, exceptionBlock."

	^ self indexOf: anElement startingAt: 1 ifAbsent: exceptionBlock! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'sma 6/1/2000 15:47'!
indexOf: anElement startingAt: start ifAbsent: exceptionBlock
	"Answer the index of the first occurence of anElement after start
	within the receiver. If the receiver does not contain anElement, 
	answer the 	result of evaluating the argument, exceptionBlock."

	start to: self size do:
		[:index |
		(self at: index) = anElement ifTrue: [^ index]].
	^ exceptionBlock value! !

!SequenceableCollection methodsFor: 'accessing'!
indexOfSubCollection: aSubCollection startingAt: anIndex 
	"Answer the index of the receiver's first element, such that that element 
	equals the first element of aSubCollection, and the next elements equal 
	the rest of the elements of aSubCollection. Begin the search at element 
	anIndex of the receiver. If no such match is found, answer 0."

	^self
		indexOfSubCollection: aSubCollection
		startingAt: anIndex
		ifAbsent: [0]! !

!SequenceableCollection methodsFor: 'accessing'!
indexOfSubCollection: sub startingAt: start ifAbsent: exceptionBlock
	"Answer the index of the receiver's first element, such that that element 
	equals the first element of sub, and the next elements equal 
	the rest of the elements of sub. Begin the search at element 
	start of the receiver. If no such match is found, answer the result of 
	evaluating argument, exceptionBlock."
	| first index |
	sub isEmpty ifTrue: [^ exceptionBlock value].
	first _ sub first.
	start to: self size - sub size + 1 do:
		[:startIndex |
		(self at: startIndex) = first ifTrue:
			[index _ 1.
			[(self at: startIndex+index-1) = (sub at: index)]
				whileTrue:
				[index = sub size ifTrue: [^startIndex].
				index _ index+1]]].
	^ exceptionBlock value! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'di 6/2/2000 09:15'!
last
	"Answer the last element of the receiver.
	Raise an error if the collection is empty."

	| size |
	(size _ self size) = 0 ifTrue: [self errorEmptyCollection].
	^ self at: size! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'ar 1/20/98 16:22'!
replaceAll: oldObject with: newObject 
	"Replace all occurences of oldObject with newObject"
	| index |
	index _ self
				indexOf: oldObject
				startingAt: 1
				ifAbsent: [0].
	[index = 0]
		whileFalse: 
			[self at: index put: newObject.
			index _ self
						indexOf: oldObject
						startingAt: index + 1
						ifAbsent: [0]]! !

!SequenceableCollection methodsFor: 'accessing'!
replaceFrom: start to: stop with: replacement 
	"This destructively replaces elements from start to stop in the receiver. 
	Answer the receiver itself. Use copyReplaceFrom:to:with: for 
	insertion/deletion which may alter the size of the result."

	replacement size = (stop - start + 1)
		ifFalse: [self error: 'Size of replacement doesnt match'].
	^self replaceFrom: start to: stop with: replacement startingAt: 1! !

!SequenceableCollection methodsFor: 'accessing'!
replaceFrom: start to: stop with: replacement startingAt: repStart 
	"This destructively replaces elements from start to stop in the receiver 
	starting at index, repStart, in the sequenceable collection, 
	replacementCollection. Answer the receiver. No range checks are 
	performed."

	| index repOff |
	repOff _ repStart - start.
	index _ start - 1.
	[(index _ index + 1) <= stop]
		whileTrue: [self at: index put: (replacement at: repOff + index)]! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'jm 6/20/2003 10:02'!
second
	"Answer the second element of the receiver."

	^ self at: 2
! !

!SequenceableCollection methodsFor: 'accessing'!
swap: oneIndex with: anotherIndex 
	"Move the element at oneIndex to anotherIndex, and vice-versa."

	| element |
	element _ self at: oneIndex.
	self at: oneIndex put: (self at: anotherIndex).
	self at: anotherIndex put: element! !

!SequenceableCollection methodsFor: 'accessing' stamp: 'jm 6/20/2003 10:02'!
third
	"Answer the third element of the receiver."

	^ self at: 3
! !


!SequenceableCollection methodsFor: 'testing' stamp: 'sma 5/12/2000 14:08'!
includes: anObject
	"Answer whether anObject is one of the receiver's elements."

	^ (self indexOf: anObject) ~= 0! !


!SequenceableCollection methodsFor: 'comparing' stamp: 'sma 5/12/2000 14:04'!
= otherCollection 
	"Answer true if the receiver is equivalent to the otherCollection.
	First test for identity, then rule out different species and sizes of
	collections. As a last resort, examine each element of the receiver
	and the otherCollection."

	self == otherCollection ifTrue: [^ true].
	self species == otherCollection species ifFalse: [^ false].
	^ self hasEqualElements: otherCollection! !

!SequenceableCollection methodsFor: 'comparing' stamp: 'sma 5/12/2000 14:04'!
hasEqualElements: otherCollection
	"Answer whether the receiver's size is the same as otherCollection's
	size, and each of the receiver's elements equal the corresponding 
	element of otherCollection.
	This should probably replace the current definition of #= ."

	| size |
	(size _ self size) = otherCollection size ifFalse: [^ false].
	1 to: size do:
		[:index |
		(self at: index) = (otherCollection at: index) ifFalse: [^ false]].
	^ true! !

!SequenceableCollection methodsFor: 'comparing' stamp: 'di 11/24/1999 20:30'!
hash
"Answer an integer hash value for the receiver such that,
  -- the hash value of an unchanged object is constant over time, and
  -- two equal objects have equal hash values."
    | size |
	(size _ self size) = 0 ifTrue: [^ 17171].
	^ size + (self at: 1) hash + (self at: size) hash! !


!SequenceableCollection methodsFor: 'converting' stamp: 'sma 5/12/2000 17:32'!
asArray
	"Answer an Array whose elements are the elements of the receiver."

	^ Array withAll: self! !

!SequenceableCollection methodsFor: 'converting' stamp: 'sma 5/12/2000 17:36'!
asByteArray
	"Answer a ByteArray whose elements are the elements of the receiver."

	^ ByteArray withAll: self! !

!SequenceableCollection methodsFor: 'converting' stamp: 'ar 9/14/1998 23:47'!
asFloatArray
	"Answer a FloatArray whose elements are the elements of the receiver, in 
	the same order."

	| floatArray |
	floatArray _ FloatArray new: self size.
	1 to: self size do:[:i| floatArray at: i put: (self at: i) asFloat ].
	^floatArray! !

!SequenceableCollection methodsFor: 'converting' stamp: 'ar 10/10/1998 16:19'!
asIntegerArray
	"Answer an IntegerArray whose elements are the elements of the receiver, in 
	the same order."

	| intArray |
	intArray _ IntegerArray new: self size.
	1 to: self size do:[:i| intArray at: i put: (self at: i)].
	^intArray! !

!SequenceableCollection methodsFor: 'converting' stamp: 'djm 11/20/1998 05:44'!
asStringWithCr
	"Convert to a string with returns between items.  Elements are
usually strings.
	 Useful for labels for PopUpMenus."
	| labelStream |
	labelStream _ WriteStream on: (String new: 200).
	self do: [:each |
		(each isKindOf: String)
			ifTrue: [labelStream nextPutAll: each; cr]
			ifFalse: [each printOn: labelStream. labelStream cr]].
	self size > 0 ifTrue: [labelStream skip: -1].
	^ labelStream contents! !

!SequenceableCollection methodsFor: 'converting' stamp: 'ar 10/10/1998 16:20'!
asWordArray
	"Answer a WordArray whose elements are the elements of the receiver, in 
	the same order."

	| wordArray |
	wordArray _ WordArray new: self size.
	1 to: self size do:[:i| wordArray at: i put: (self at: i)].
	^wordArray! !

!SequenceableCollection methodsFor: 'converting' stamp: 'jm 4/27/98 04:09'!
reversed
	"Answer a copy of the receiver with element order reversed."
	"Example: 'frog' reversed"

	| n result src |
	n _ self size.
	result _ self species new: n.
	src _ n + 1.
	1 to: n do: [:i | result at: i put: (self at: (src _ src - 1))].
	^ result
! !


!SequenceableCollection methodsFor: 'copying' stamp: 'di 1/16/98 16:40'!
, otherCollection 
	"Concatenate two Strings or Collections."
	
	^ self copyReplaceFrom: self size + 1
		  to: self size
		  with: otherCollection
"
#(2 4 6 8) , #(who do we appreciate)
((2989 printStringBase: 16) copyFrom: 4 to: 6) , ' boy!!'
"! !

!SequenceableCollection methodsFor: 'copying' stamp: 'sma 6/1/2000 16:07'!
copyEmpty
	^ self species new: 0! !

!SequenceableCollection methodsFor: 'copying'!
copyFrom: start to: stop 
	"Answer a copy of a subset of the receiver, starting from element at 
	index start until element at index stop."

	| newSize |
	newSize _ stop - start + 1.
	^(self species new: newSize)
		replaceFrom: 1
		to: newSize
		with: self
		startingAt: start! !

!SequenceableCollection methodsFor: 'copying'!
copyReplaceAll: oldSubstring with: newSubstring 
	"Default is not to do token matching.
	See also String copyReplaceTokens:with:"
	^ self copyReplaceAll: oldSubstring with: newSubstring asTokens: false
	"'How now brown cow?' copyReplaceAll: 'ow' with: 'ello'"
	"'File asFile Files File''s File' copyReplaceTokens: 'File' with: 'Pile'"! !

!SequenceableCollection methodsFor: 'copying'!
copyReplaceFrom: start to: stop with: replacementCollection 
	"Answer a copy of the receiver satisfying the following conditions: If 
	stop is less than start, then this is an insertion; stop should be exactly 
	start-1, start = 1 means insert before the first character, start = size+1 
	means append after last character. Otherwise, this is a replacement; start 
	and stop have to be within the receiver's bounds."

	| newSequenceableCollection newSize endReplacement |
	newSize _ self size - (stop - start + 1) + replacementCollection size.
	endReplacement _ start - 1 + replacementCollection size.
	newSequenceableCollection _ self species new: newSize.
	newSequenceableCollection
		replaceFrom: 1
		to: start - 1
		with: self
		startingAt: 1.
	newSequenceableCollection
		replaceFrom: start
		to: endReplacement
		with: replacementCollection
		startingAt: 1.
	newSequenceableCollection
		replaceFrom: endReplacement + 1
		to: newSize
		with: self
		startingAt: stop + 1.
	^newSequenceableCollection! !

!SequenceableCollection methodsFor: 'copying' stamp: 'sma 6/1/2000 16:00'!
copyUpTo: anElement 
	"Answer all elements up to but not including anObject. If there
	is no such object, answer a copy of the receiver."

	^ self first: (self indexOf: anElement ifAbsent: [^ self copy]) - 1! !

!SequenceableCollection methodsFor: 'copying'!
copyWith: newElement 
	"Answer a copy of the receiver that is 1 bigger than the receiver and has 
	newElement at the last element."

	| newIC |
	newIC _ self species new: self size + 1.
	newIC 
		replaceFrom: 1
		to: self size
		with: self
		startingAt: 1.
	newIC at: newIC size put: newElement.
	^newIC! !

!SequenceableCollection methodsFor: 'copying' stamp: 'sma 4/22/2000 18:01'!
forceTo: length paddingWith: elem
	"Force the length of the collection to length, padding
	if necessary with elem.  Note that this makes a copy."

	| newCollection copyLen |
	newCollection _ self species new: length.
	copyLen _ self size min: length.
	newCollection replaceFrom: 1 to: copyLen with: self startingAt: 1.
	newCollection from: copyLen + 1 to: length put: elem.
	^ newCollection! !

!SequenceableCollection methodsFor: 'copying'!
shallowCopy

	^self copyFrom: 1 to: self size! !

!SequenceableCollection methodsFor: 'copying' stamp: 'djp 10/23/1999 22:12'!
shuffledBy: aRandom
	| copy | 
	copy _ self shallowCopy.
	copy size to: 1 by: -1 do: 
		[:i | copy swap: i with: ((1 to: i) atRandom: aRandom)].
	^ copy! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'tk 7/30/97 12:41'!
asDigitsToPower: anInteger do: aBlock
	"Repeatedly value aBlock with a single Array.  Adjust the collection
	so that aBlock is presented all (self size raisedTo: anInteger) possible 
	combinations of the receiver's elements taken as digits of an anInteger long number."
	"(0 to: 1) asDigitsToPower: 4 do: [:each | Transcript cr; show: each printString]"

	| aCollection |
	aCollection _ Array new: anInteger.
	self asDigitsAt: 1 in: aCollection do: aBlock! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'sma 5/12/2000 11:46'!
collect: aBlock 
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	Collect the resulting values into a collection like the receiver. Answer  
	the new collection."

	| newCollection |
	newCollection _ self species new: self size.
	1 to: self size do:
		[:index |
		newCollection at: index put: (aBlock value: (self at: index))].
	^ newCollection! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'sma 6/1/2000 11:47'!
collect: aBlock from: firstIndex to: lastIndex
	"Refer to the comment in Collection|collect:."

	| size result j |
	size _ lastIndex - firstIndex + 1.
	result _ self species new: size.
	j _ firstIndex.
	1 to: size do: [:i | result at: i put: (aBlock value: (self at: j)). j _ j + 1].
	^ result! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'tk 7/30/97 12:52'!
combinations: kk atATimeDo: aBlock
	"Take the items in the receiver, kk at a time, and evaluate the block for each combination.  Hand in an array of elements of self as the block argument.  Each combination only occurs once, and order of the elements does not matter.  There are (self size take: kk) combinations."
	" 'abcde' combinations: 3 atATimeDo: [:each | Transcript cr; show: each printString]"

	| aCollection |
	aCollection _ Array new: kk.
	self combinationsAt: 1 in: aCollection after: 0 do: aBlock! !

!SequenceableCollection methodsFor: 'enumerating'!
do: aBlock 
	"Refer to the comment in Collection|do:."
	1 to: self size do:
		[:index | aBlock value: (self at: index)]! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'di 7/13/97 09:43'!
doWithIndex: elementAndIndexBlock
	"Use the new version with consistent naming"
	^ self withIndexDo: elementAndIndexBlock! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'ar 6/3/2000 15:54'!
findBinaryIndex: aBlock
	"Search for an element in the receiver using binary search.
	The argument aBlock is a one-element block returning
		0 	- if the element is the one searched for
		<0	- if the search should continue in the first half
		>0	- if the search should continue in the second half
	If no matching element is found, raise an error.
	Examples:
		#(1 3 5 7 11 15 23) findBinaryIndex:[:arg| 11 - arg]
	"
	^self findBinaryIndex: aBlock ifNone: [self errorNotFound: aBlock]! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'ar 6/3/2000 15:54'!
findBinaryIndex: aBlock ifNone: exceptionBlock
	"Search for an element in the receiver using binary search.
	The argument aBlock is a one-element block returning
		0 	- if the element is the one searched for
		<0	- if the search should continue in the first half
		>0	- if the search should continue in the second half
	If no matching element is found, evaluate exceptionBlock."
	| index low high test |
	low _ 1.
	high _ self size.
	[index _ high + low // 2.
	low > high] whileFalse:[
		test _ aBlock value: (self at: index).
		test = 0 
			ifTrue:[^index]
			ifFalse:[test > 0
				ifTrue: [low _ index + 1]
				ifFalse: [high _ index - 1]]].
	^exceptionBlock value! !

!SequenceableCollection methodsFor: 'enumerating'!
findFirst: aBlock
	"Return the index of my first element for which aBlock evaluates as true."

	| index |
	index _ 0.
	[(index _ index + 1) <= self size] whileTrue:
		[(aBlock value: (self at: index)) ifTrue: [^index]].
	^ 0! !

!SequenceableCollection methodsFor: 'enumerating'!
findLast: aBlock
	"Return the index of my last element for which aBlock evaluates as true."

	| index |
	index _ self size + 1.
	[(index _ index - 1) >= 1] whileTrue:
		[(aBlock value: (self at: index)) ifTrue: [^index]].
	^ 0! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'sma 5/12/2000 18:13'!
keysAndValuesDo: aBlock 
	"Enumerate the receiver with all the keys (aka indices) and values."

	1 to: self size do: [:index | aBlock value: index value: (self at: index)]! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'di 11/12/1998 15:01'!
pairsDo: aBlock 
	"Evaluate aBlock with my elements taken two at a time.  If there's an odd number of items, ignore the last one.  Allows use of a flattened array for things that naturally group into pairs.  See also pairsCollect:"

	1 to: self size // 2 do:
		[:index | aBlock value: (self at: 2 * index - 1) value: (self at: 2 * index)]
"
#(1 'fred' 2 'charlie' 3 'elmer') pairsDo:
	[:a :b | Transcript cr; show: b, ' is number ', a printString]
"! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'ward 7/28/97 09:41'!
permutationsDo: aBlock
	"Repeatly value aBlock with a single copy of the receiver. Reorder the copy
	so that aBlock is presented all (self size factorial) possible permutations."
	"(1 to: 4) permutationsDo: [:each | Transcript cr; show: each printString]"

	self shallowCopy permutationsStartingAt: 1 do: aBlock! !

!SequenceableCollection methodsFor: 'enumerating'!
reverseDo: aBlock
	"Evaluate aBlock with each of the receiver's elements as the argument, 
	starting with the last element and taking each in sequence up to the 
	first. For SequenceableCollections, this is the reverse of the enumeration 
	for do:."

	self size to: 1 by: -1 do: [:index | aBlock value: (self at: index)]! !

!SequenceableCollection methodsFor: 'enumerating'!
reverseWith: aSequenceableCollection do: aBlock 
	"Evaluate aBlock with each of the receiver's elements, in reverse order, 
	along with the  
	corresponding element, also in reverse order, from 
	aSequencableCollection. "

	self size ~= aSequenceableCollection size ifTrue: [^ self errorNoMatch].
	self size
		to: 1
		by: -1
		do: [:index | aBlock value: (self at: index)
				value: (aSequenceableCollection at: index)]! !

!SequenceableCollection methodsFor: 'enumerating'!
select: aBlock 
	"Refer to the comment in Collection|select:."
	| aStream |
	aStream _ WriteStream on: (self species new: self size).
	1 to: self size do: 
		[:index |
		(aBlock value: (self at: index))
			ifTrue: [aStream nextPut: (self at: index)]].
	^ aStream contents! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'sma 6/1/2000 16:00'!
upTo: anObject
	"Deprecated. Use copyUpTo:"

	^ self copyUpTo: anObject! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'di 8/31/1999 13:13'!
with: otherCollection collect: twoArgBlock 
	"Collect and return the result of evaluating twoArgBlock with corresponding elements from this collection and otherCollection."
	| result |
	otherCollection size = self size ifFalse: [self error: 'otherCollection must be the same size'].
	result _ self species new: self size.
	1 to: self size do:
		[:index | result at: index put:
		(twoArgBlock
			value: (self at: index)
			value: (otherCollection at: index))].
	^ result! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'di 8/3/1999 15:26'!
with: otherCollection do: twoArgBlock 
	"Evaluate twoArgBlock with corresponding elements from this collection and otherCollection."
	otherCollection size = self size ifFalse: [self error: 'otherCollection must be the same size'].
	1 to: self size do:
		[:index |
		twoArgBlock value: (self at: index)
				value: (otherCollection at: index)]! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'di 5/17/1998 13:34'!
withIndexCollect: elementAndIndexBlock 
	"Just like with:collect: except that the iteration index supplies the second argument to the block."
	| result |
	result _ self species new: self size.
	1 to: self size do:
		[:index | result at: index put:
		(elementAndIndexBlock
			value: (self at: index)
			value: index)].
	^ result! !

!SequenceableCollection methodsFor: 'enumerating' stamp: 'di 7/13/97 09:35'!
withIndexDo: elementAndIndexBlock 
	"Just like with:do: except that the iteration index supplies the second argument to the block."
	1 to: self size do:
		[:index |
		elementAndIndexBlock
			value: (self at: index)
			value: index]! !


!SequenceableCollection methodsFor: 'removing'!
remove: oldObject ifAbsent: anExceptionBlock 
	"SequencableCollections cannot implement removing."

	self shouldNotImplement! !


!SequenceableCollection methodsFor: 'private' stamp: 'sma 5/12/2000 11:33'!
anyOne
	^ self first! !

!SequenceableCollection methodsFor: 'private' stamp: 'tk 7/30/97 12:42'!
asDigitsAt: anInteger in: aCollection do: aBlock
	"(0 to: 1) asDigitsToPower: 4 do: [:each | Transcript cr; show: each printString]"

	self do: 
		[:each | 
		aCollection at: anInteger put: each.
		anInteger = aCollection size 
			ifTrue: [aBlock value: aCollection]
			ifFalse: [self asDigitsAt: anInteger + 1 in: aCollection do: aBlock]].! !

!SequenceableCollection methodsFor: 'private' stamp: 'tk 7/30/97 12:42'!
combinationsAt: jj in: aCollection after: nn do: aBlock
	"Choose k of N items and put in aCollection.  jj-1 already chosen.  Indexes of items are in numerical order, to avoid the same combo being used twice.  In this slot, we are allowed to use items in self indexed by nn+1 to self size.  nn is the index used for position jj-1."
	"(1 to: 6) combinationsSize: 3 do: [:each | Transcript cr; show: each printString]"

nn+1 to: self size do: [:index | 
		aCollection at: jj put: (self at: index).
		jj = aCollection size 
			ifTrue: [aBlock value: aCollection]
			ifFalse: [self combinationsAt: jj + 1 in: aCollection after: index do: aBlock]].! !

!SequenceableCollection methodsFor: 'private' stamp: 'tk 1/7/98 10:57'!
copyReplaceAll: oldSubstring with: newSubstring asTokens: ifTokens
	"Answer a copy of the receiver in which all occurrences of
	oldSubstring have been replaced by newSubstring.
	ifTokens (valid for Strings only) specifies that the characters
	surrounding the recplacement must not be alphanumeric.
		Bruce Simth,  must be incremented by 1 and not 
	newSubstring if ifTokens is true.  See example below. "

	| aString startSearch currentIndex endIndex |
	(ifTokens and: [(self isKindOf: String) not])
		ifTrue: [(self isKindOf: Text) ifFalse: [
			self error: 'Token replacement only valid for Strings']].
	aString _ self.
	startSearch _ 1.
	[(currentIndex _ aString indexOfSubCollection: oldSubstring startingAt: startSearch)
			 > 0]
		whileTrue: 
		[endIndex _ currentIndex + oldSubstring size - 1.
		(ifTokens not
			or: [(currentIndex = 1
					or: [(aString at: currentIndex-1) isAlphaNumeric not])
				and: [endIndex = aString size
					or: [(aString at: endIndex+1) isAlphaNumeric not]]])
			ifTrue: [aString _ aString
					copyReplaceFrom: currentIndex
					to: endIndex
					with: newSubstring.
				startSearch _ currentIndex + newSubstring size]
			ifFalse: [
				ifTokens 
					ifTrue: [startSearch _ currentIndex + 1]
					ifFalse: [startSearch _ currentIndex + newSubstring size]]].
	^ aString

"Test case:
	'test te string' copyReplaceAll: 'te' with: 'longone' asTokens: true   "
! !

!SequenceableCollection methodsFor: 'private'!
errorOutOfBounds

	self error: 'indices are out of bounds'! !

!SequenceableCollection methodsFor: 'private' stamp: 'ward 7/28/97 09:38'!
permutationsStartingAt: anInteger do: aBlock
	"#(1 2 3 4) permutationsDo: [:each | Transcript cr; show: each printString]"

	anInteger > self size ifTrue: [^self].
	anInteger = self size ifTrue: [^aBlock value: self].
	anInteger to: self size do:
		[:i | self swap: anInteger with: i.
		self permutationsStartingAt: anInteger + 1 do: aBlock.
		self swap: anInteger with: i]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SequenceableCollection class
	instanceVariableNames: ''!

!SequenceableCollection class methodsFor: 'stream creation'!
streamContents: blockWithArg
	| stream |
	stream _ WriteStream on: (self new: 100).
	blockWithArg value: stream.
	^stream contents! !

!SequenceableCollection class methodsFor: 'stream creation' stamp: 'di 6/20/97 09:07'!
streamContents: blockWithArg limitedTo: sizeLimit
	| stream |
	stream _ LimitedWriteStream on: (self new: (100 min: sizeLimit)).
	stream setLimit: sizeLimit limitBlock: [^ stream contents].
	blockWithArg value: stream.
	^ stream contents
"
String streamContents: [:s | 1000 timesRepeat: [s nextPutAll: 'Junk']] limitedTo: 25
 'JunkJunkJunkJunkJunkJunkJ'
"! !


SequenceableCollection subclass: #ArrayedCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Collections-Abstract'!
!ArrayedCollection commentStamp: '<historical>' prior: 0!
I am an abstract collection of elements with a fixed range of integers (from 1 to n>=1) as external keys.!


!ArrayedCollection methodsFor: 'accessing' stamp: 'sma 5/12/2000 11:36'!
size
	"Answer how many elements the receiver contains."

	<primitive: 62>
	^ self basicSize! !


!ArrayedCollection methodsFor: 'adding' stamp: 'sma 5/12/2000 14:09'!
add: newObject
	self shouldNotImplement! !


!ArrayedCollection methodsFor: 'printing'!
storeOn: aStream

	aStream nextPutAll: '(('.
	aStream nextPutAll: self class name.
	aStream nextPutAll: ' new: '.
	aStream store: self size.
	aStream nextPut: $).
	(self storeElementsFrom: 1 to: self size on: aStream)
		ifFalse: [aStream nextPutAll: '; yourself'].
	aStream nextPut: $)! !


!ArrayedCollection methodsFor: 'private'!
defaultElement

	^nil! !

!ArrayedCollection methodsFor: 'private'!
storeElementsFrom: firstIndex to: lastIndex on: aStream

	| noneYet defaultElement arrayElement |
	noneYet _ true.
	defaultElement _ self defaultElement.
	firstIndex to: lastIndex do: 
		[:index | 
		arrayElement _ self at: index.
		arrayElement = defaultElement
			ifFalse: 
				[noneYet
					ifTrue: [noneYet _ false]
					ifFalse: [aStream nextPut: $;].
				aStream nextPutAll: ' at: '.
				aStream store: index.
				aStream nextPutAll: ' put: '.
				aStream store: arrayElement]].
	^noneYet! !


!ArrayedCollection methodsFor: 'sorting' stamp: 'sma 6/1/2000 11:57'!
isSorted
	"Return true if the receiver is sorted by the given criterion.
	Optimization for isSortedBy: [:a :b | a <= b]."

	| lastElm elm |
	self isEmpty ifTrue: [^ true].
	lastElm _ self first.
	2 to: self size do: 
		[:index | 
		elm _ self at: index.
		lastElm <= elm ifFalse: [^ false].
		lastElm _ elm].
	^ true! !

!ArrayedCollection methodsFor: 'sorting' stamp: 'sma 6/1/2000 11:58'!
isSortedBy: aBlock
	"Return true if the receiver is sorted by the given criterion."

	| lastElm elm |
	self isEmpty ifTrue: [^ true].
	lastElm _ self first.
	2 to: self size do: 
		[:index | 
		elm _ self at: index.
		(aBlock value: lastElm value: elm) ifFalse: [^ false].
		lastElm _ elm].
	^ true! !

!ArrayedCollection methodsFor: 'sorting' stamp: 'sma 5/12/2000 14:28'!
mergeFirst: first middle: middle last: last into: dst by: aBlock
	"Private. Merge the sorted ranges [first..middle] and [middle+1..last] 
	of the receiver into the range [first..last] of dst."

	| i1 i2 val1 val2 out |
	i1 _ first.
	i2 _ middle + 1.
	val1 _ self at: i1.
	val2 _ self at: i2.
	out _ first - 1.  "will be pre-incremented"

	"select 'lower' half of the elements based on comparator"
	[(i1 <= middle) and: [i2 <= last]] whileTrue:
		[(aBlock value: val1 value: val2)
			ifTrue: [dst at: (out _ out + 1) put: val1.
					val1 _ self at: (i1 _ i1 + 1)]
			ifFalse: [dst at: (out _ out + 1) put: val2.
					i2 _ i2 + 1.
					i2 <= last ifTrue: [val2 _ self at: i2]]].

	"copy the remaining elements"
	i1 <= middle
		ifTrue: [dst replaceFrom: out + 1 to: last with: self startingAt: i1]
		ifFalse: [dst replaceFrom: out + 1 to: last with: self startingAt: i2]! !

!ArrayedCollection methodsFor: 'sorting' stamp: 'sma 5/12/2000 14:25'!
mergeSortFrom: startIndex to: stopIndex by: aBlock
	"Sort the given range of indices using the mergesort algorithm.
	Mergesort is a worst-case O(N log N) sorting algorithm that usually
	does only half as many comparisons as heapsort or quicksort."

	"Details: recursively split the range to be sorted into two halves,
	mergesort each half, then merge the two halves together. An extra 
	copy of the data is used as temporary storage and successive merge 
	phases copy data back and forth between the receiver and this copy.
	The recursion is set up so that the final merge is performed into the
	receiver, resulting in the receiver being completely sorted."

	self size <= 1 ifTrue: [^ self].  "nothing to do"
	startIndex = stopIndex ifTrue: [^ self].
	self assert: [startIndex >= 1 and: [startIndex < stopIndex]]. "bad start index"
	self assert: [stopIndex <= self size]. "bad stop index"
	self
		mergeSortFrom: startIndex
		to: stopIndex 
		src: self clone 
		dst: self 
		by: aBlock! !

!ArrayedCollection methodsFor: 'sorting' stamp: 'sma 5/12/2000 14:26'!
mergeSortFrom: first to: last src: src dst: dst by: aBlock
	"Private. Split the range to be sorted in half, sort each half, and 
	merge the two half-ranges into dst."

	| middle |
	first = last ifTrue: [^ self].
	middle _ (first + last) // 2.
	self mergeSortFrom: first to: middle src: dst dst: src by: aBlock.
	self mergeSortFrom: middle + 1 to: last src: dst dst: src by: aBlock.
	src mergeFirst: first middle: middle last: last into: dst by: aBlock! !

!ArrayedCollection methodsFor: 'sorting' stamp: 'sma 5/12/2000 14:22'!
sort
	"Sort this array into ascending order using the '<=' operator."

	self sort: [:a :b | a <= b]! !

!ArrayedCollection methodsFor: 'sorting' stamp: 'sma 5/12/2000 14:21'!
sort: aSortBlock 
	"Sort this array using aSortBlock. The block should take two arguments
	and return true if the first element should preceed the second one."

	self
		mergeSortFrom: 1
		to: self size
		by: aSortBlock! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ArrayedCollection class
	instanceVariableNames: ''!

!ArrayedCollection class methodsFor: 'instance creation'!
new
	"Answer a new instance of me, with size = 0."

	^self new: 0! !

!ArrayedCollection class methodsFor: 'instance creation'!
new: size withAll: value 
	"Answer an instance of me, with number of elements equal to size, each 
	of which refers to the argument, value."

	^(self new: size) atAllPut: value! !

!ArrayedCollection class methodsFor: 'instance creation'!
newFrom: aCollection 
	"Answer an instance of me containing the same elements as aCollection."
	| newArray |
	newArray _ self new: aCollection size.
	1 to: aCollection size do: [:i | newArray at: i put: (aCollection at: i)].
	^ newArray

"	Array newFrom: {1. 2. 3}
	{1. 2. 3} as: Array
	{1. 2. 3} as: ByteArray
	{$c. $h. $r} as: String
	{$c. $h. $r} as: Text
"! !

!ArrayedCollection class methodsFor: 'instance creation'!
with: anObject 
	"Answer a new instance of me, containing only anObject."

	| newCollection |
	newCollection _ self new: 1.
	newCollection at: 1 put: anObject.
	^newCollection! !

!ArrayedCollection class methodsFor: 'instance creation'!
with: firstObject with: secondObject 
	"Answer a new instance of me, containing firstObject and secondObject."

	| newCollection |
	newCollection _ self new: 2.
	newCollection at: 1 put: firstObject.
	newCollection at: 2 put: secondObject.
	^newCollection! !

!ArrayedCollection class methodsFor: 'instance creation'!
with: firstObject with: secondObject with: thirdObject 
	"Answer a new instance of me, containing only the three arguments as
	elements."

	| newCollection |
	newCollection _ self new: 3.
	newCollection at: 1 put: firstObject.
	newCollection at: 2 put: secondObject.
	newCollection at: 3 put: thirdObject.
	^newCollection! !

!ArrayedCollection class methodsFor: 'instance creation'!
with: firstObject with: secondObject with: thirdObject with: fourthObject 
	"Answer a new instance of me, containing only the three arguments as
	elements."

	| newCollection |
	newCollection _ self new: 4.
	newCollection at: 1 put: firstObject.
	newCollection at: 2 put: secondObject.
	newCollection at: 3 put: thirdObject.
	newCollection at: 4 put: fourthObject.
	^newCollection! !

!ArrayedCollection class methodsFor: 'instance creation'!
with: firstObject with: secondObject with: thirdObject with: fourthObject with: fifthObject
	"Answer a new instance of me, containing only the five arguments as
	elements."

	| newCollection |
	newCollection _ self new: 5.
	newCollection at: 1 put: firstObject.
	newCollection at: 2 put: secondObject.
	newCollection at: 3 put: thirdObject.
	newCollection at: 4 put: fourthObject.
	newCollection at: 5 put: fifthObject.
	^newCollection! !

!ArrayedCollection class methodsFor: 'instance creation' stamp: 'sw 10/24/1998 22:22'!
with: firstObject with: secondObject with: thirdObject with: fourthObject with: fifthObject with: sixthObject
	"Answer a new instance of me, containing only the 6 arguments as elements."

	| newCollection |
	newCollection _ self new: 6.
	newCollection at: 1 put: firstObject.
	newCollection at: 2 put: secondObject.
	newCollection at: 3 put: thirdObject.
	newCollection at: 4 put: fourthObject.
	newCollection at: 5 put: fifthObject.
	newCollection at: 6 put: sixthObject.
	^ newCollection! !

!ArrayedCollection class methodsFor: 'instance creation' stamp: 'sma 5/12/2000 17:37'!
withAll: aCollection
	"Create a new collection containing all the elements from aCollection."

	^ (self new: aCollection size) replaceFrom: 1 to: aCollection size with: aCollection! !

Collection initialize!

ArrayedCollection variableSubclass: #Array
	instanceVariableNames: ''
	classVariableNames: 'EmptyArray '
	poolDictionaries: ''
	category: 'Collections-Arrayed'!
!Array commentStamp: '<historical>' prior: 0!
I present an ArrayedCollection whose elements are objects.!


!Array methodsFor: 'converting' stamp: 'sma 5/12/2000 17:32'!
asArray
	"Answer with the receiver itself."

	^ self! !

!Array methodsFor: 'converting' stamp: 'di 3/28/1999 10:22'!
elementsExchangeIdentityWith: otherArray
	"This primitive performs a bulk mutation, causing all pointers to the elements of this array to be replaced by pointers to the corresponding elements of otherArray.  At the same time, all pointers to the elements of otherArray are replaced by pointers to the corresponding elements of this array.  The identityHashes remain with the pointers rather than with the objects so that objects in hashed structures should still be properly indexed after the mutation."
	<primitive: 128>
	self primitiveFailed! !

!Array methodsFor: 'converting' stamp: 'di 3/28/1999 10:23'!
elementsForwardIdentityTo: otherArray
	"This primitive performs a bulk mutation, causing all pointers to the elements of this array to be replaced by pointers to the corresponding elements of otherArray.  The identityHashes remain with the pointers rather than with the objects so that the objects in this array should still be properly indexed in any existing hashed structures after the mutation."
	<primitive: 72>
	self primitiveFailed! !

!Array methodsFor: 'converting'!
evalStrings
	   "Allows you to construct literal arrays.
    #(true false nil '5@6' 'Set new' '''text string''') evalStrings
    gives an array with true, false, nil, a Point, a Set, and a String
    instead of just a bunch of Symbols"
    | it |

    ^ self collect: [:each |
        it _ each.
        each == #true ifTrue: [it _ true].
		      each == #false ifTrue: [it _ false].
        each == #nil ifTrue: [it _ nil].
        each class == String ifTrue: [
			it _ Compiler evaluate: each].
        each class == Array ifTrue: [it _ it evalStrings].
        it]! !


!Array methodsFor: 'printing' stamp: 'jm 5/29/2003 18:49'!
isLiteral

	self do: [:each | each isLiteral ifFalse: [^ false]].
	^ true
! !

!Array methodsFor: 'printing' stamp: 'jm 3/23/2005 10:08'!
printOn: aStream

	self printElementsOn: aStream.
! !

!Array methodsFor: 'printing'!
storeOn: aStream 
	"Use the literal form if possible."

	self isLiteral
		ifTrue: 
			[aStream nextPut: $#; nextPut: $(.
			self do: 
				[:element | 
				element printOn: aStream.
				aStream space].
			aStream nextPut: $)]
		ifFalse: [super storeOn: aStream]! !


!Array methodsFor: 'private' stamp: 'sma 6/3/2000 21:39'!
hasLiteral: literal
	"Answer true if literal is identical to any literal in this array, even 
	if imbedded in further array structure. This method is only intended 
	for private use by CompiledMethod hasLiteralSymbol:"

	| lit |
	1 to: self size do: 
		[:index | 
		(lit _ self at: index) == literal ifTrue: [^ true].
		(lit class == Array and: [lit hasLiteral: literal]) ifTrue: [^ true]].
	^ false! !

!Array methodsFor: 'private' stamp: 'di 8/15/97 09:55'!
hasLiteralSuchThat: litBlock
	"Answer true if litBlock returns true for any literal in this array, even if imbedded in further array structure.  This method is only intended for private use by CompiledMethod hasLiteralSuchThat:"
	| lit |
	1 to: self size do:
		[:index | lit _ self at: index.
		(litBlock value: lit) ifTrue: [^ true].
		(lit class == Array and: [lit hasLiteralSuchThat: litBlock]) ifTrue: [^ true]].
	^false! !

!Array methodsFor: 'private'!
replaceFrom: start to: stop with: replacement startingAt: repStart 
	"Primitive. This destructively replaces elements from start to stop in the receiver starting at index, repStart, in the collection, replacement. Answer the receiver. Range checks are performed in the primitive only. Optional. See Object documentation whatIsAPrimitive."
	<primitive: 105>
	super replaceFrom: start to: stop with: replacement startingAt: repStart! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Array class
	instanceVariableNames: ''!

!Array class methodsFor: 'class initialization' stamp: 'jm 10/13/2002 17:31'!
initialize

	"This empty array object can be shared, since it is immutable:"
	EmptyArray _ Array new.
! !


!Array class methodsFor: 'constants' stamp: 'jm 10/13/2002 17:32'!
empty

	^ EmptyArray
! !


!Array class methodsFor: 'brace support' stamp: 'di 11/18/1999 22:53'!
braceStream: nElements
	"This method is used in compilation of brace constructs.
	It MUST NOT be deleted or altered."

	^ WriteStream basicNew braceArray: (self new: nElements)
! !

!Array class methodsFor: 'brace support' stamp: 'di 11/19/1999 08:16'!
braceWith: a
	"This method is used in compilation of brace constructs.
	It MUST NOT be deleted or altered."

	| array |
	array _ self new: 1.
	array at: 1 put: a.
	^ array! !

!Array class methodsFor: 'brace support' stamp: 'di 11/19/1999 08:15'!
braceWith: a with: b 
	"This method is used in compilation of brace constructs.
	It MUST NOT be deleted or altered."

	| array |
	array _ self new: 2.
	array at: 1 put: a.
	array at: 2 put: b.
	^ array! !

!Array class methodsFor: 'brace support' stamp: 'di 11/19/1999 08:17'!
braceWith: a with: b with: c 
	"This method is used in compilation of brace constructs.
	It MUST NOT be deleted or altered."

	| array |
	array _ self new: 3.
	array at: 1 put: a.
	array at: 2 put: b.
	array at: 3 put: c.
	^ array! !

!Array class methodsFor: 'brace support' stamp: 'di 11/19/1999 08:17'!
braceWith: a with: b with: c with: d
	"This method is used in compilation of brace constructs.
	It MUST NOT be deleted or altered."

	| array |
	array _ self new: 4.
	array at: 1 put: a.
	array at: 2 put: b.
	array at: 3 put: c.
	array at: 4 put: d.
	^ array! !

!Array class methodsFor: 'brace support' stamp: 'di 11/19/1999 08:16'!
braceWithNone
	"This method is used in compilation of brace constructs.
	It MUST NOT be deleted or altered."

	^ self new: 0! !


ArrayedCollection variableByteSubclass: #ByteArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Collections-Arrayed'!
!ByteArray commentStamp: '<historical>' prior: 0!
I represent an ArrayedCollection whose elements are integers between 0 and 255.
!


!ByteArray methodsFor: 'accessing' stamp: 'sma 4/22/2000 17:47'!
atAllPut: value
	"Fill the receiver with the given value"

	<primitive: 145>
	super atAllPut: value! !

!ByteArray methodsFor: 'accessing' stamp: 'ar 12/5/1998 14:52'!
byteAt: index
	<primitive: 60>
	^self at: index! !

!ByteArray methodsFor: 'accessing' stamp: 'ar 12/5/1998 14:52'!
byteAt: index put: value
	<primitive: 61>
	^self at: index put: value! !

!ByteArray methodsFor: 'accessing' stamp: 'tk 3/13/2000 14:46'!
bytesPerElement
	"Number of bytes in each item.  This multiplied by (self size)*8 gives the number of bits stored."
	^ 1! !


!ByteArray methodsFor: 'converting' stamp: 'sma 5/12/2000 17:35'!
asByteArray
	^ self! !

!ByteArray methodsFor: 'converting'!
asString
	"Convert to a String with Characters for each byte.
	Fast code uses primitive that avoids character conversion"

	^ (String new: self size) replaceFrom: 1 to: self size with: self! !


!ByteArray methodsFor: 'private'!
defaultElement

	^0! !

!ByteArray methodsFor: 'private'!
replaceFrom: start to: stop with: replacement startingAt: repStart 
	"Primitive. This destructively replaces elements from start to stop in the receiver starting at index, repStart, in the collection, replacement. Answer the receiver. Range checks are performed in the primitive only. Optional. See Object documentation whatIsAPrimitive."
	<primitive: 105>
	super replaceFrom: start to: stop with: replacement startingAt: repStart! !


!ByteArray methodsFor: 'comparing' stamp: 'jm 8/3/1999 09:33'!
hash
	"Make sure that equal (=) ByteArrays hash equally."

	self size = 0 ifTrue: [^ 2001].
	^ ((self at: 1) bitShift: 8) + (self at: self size)
! !


Magnitude subclass: #LookupKey
	instanceVariableNames: 'key '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Collections-Support'!
!LookupKey commentStamp: '<historical>' prior: 0!
I represent a key for looking up entries in a data structure. Subclasses of me, such as Association, typically represent dictionary entries.!


!LookupKey methodsFor: 'accessing'!
key
	"Answer the lookup key of the receiver."

	^key! !

!LookupKey methodsFor: 'accessing'!
key: anObject 
	"Store the argument, anObject, as the lookup key of the receiver."

	key _ anObject! !


!LookupKey methodsFor: 'comparing'!
< aLookupKey 
	"Refer to the comment in Magnitude|<."

	^key < aLookupKey key! !

!LookupKey methodsFor: 'comparing'!
= aLookupKey

	self species = aLookupKey species
		ifTrue: [^key = aLookupKey key]
		ifFalse: [^false]! !

!LookupKey methodsFor: 'comparing'!
hash
	"Hash is reimplemented because = is implemented."

	^key hash! !


!LookupKey methodsFor: 'printing'!
printOn: aStream

	key printOn: aStream! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

LookupKey class
	instanceVariableNames: ''!

!LookupKey class methodsFor: 'instance creation'!
key: aKey 
	"Answer an instance of me with the argument as the lookup up."

	^self new key: aKey! !


LookupKey subclass: #Association
	instanceVariableNames: 'value '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Collections-Support'!
!Association commentStamp: '<historical>' prior: 0!
I represent a pair of associated objects--a key and a value. My instances can serve as entries in a dictionary.!


!Association methodsFor: 'accessing'!
key: aKey value: anObject 
	"Store the arguments as the variables of the receiver."

	key _ aKey.
	value _ anObject! !

!Association methodsFor: 'accessing'!
value
	"Answer the value of the receiver."

	^value! !

!Association methodsFor: 'accessing'!
value: anObject 
	"Store the argument, anObject, as the value of the receiver."

	value _ anObject! !


!Association methodsFor: 'printing'!
printOn: aStream

	super printOn: aStream.
	aStream nextPutAll: '->'.
	value printOn: aStream! !

!Association methodsFor: 'printing'!
storeOn: aStream
	"Store in the format (key->value)"
	aStream nextPut: $(.
	key storeOn: aStream.
	aStream nextPutAll: '->'.
	value storeOn: aStream.
	aStream nextPut: $)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Association class
	instanceVariableNames: ''!

!Association class methodsFor: 'instance creation'!
key: newKey value: newValue
	"Answer an instance of me with the arguments as the key and value of 
	the association."

	^(super key: newKey) value: newValue! !


Collection subclass: #Set
	instanceVariableNames: 'tally array '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Collections-Unordered'!

!Set methodsFor: 'accessing'!
size
	^ tally! !


!Set methodsFor: 'adding' stamp: 'sma 5/12/2000 17:28'!
add: newObject
	"Include newObject as one of the receiver's elements, but only if
	not already present. Answer newObject."

	| index |
	newObject ifNil: [self error: 'Sets cannot meaningfully contain nil as an element'].
	index _ self findElementOrNil: newObject.
	(array at: index) ifNil: [self atNewIndex: index put: newObject].
	^ newObject! !


!Set methodsFor: 'converting' stamp: 'ar 11/20/1998 16:34'!
asSet
	^self! !


!Set methodsFor: 'copying' stamp: 'sma 5/12/2000 14:54'!
copy
	^ self shallowCopy withArray: array shallowCopy! !


!Set methodsFor: 'enumerating' stamp: 'sma 5/12/2000 11:49'!
collect: aBlock 
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	Collect the resulting values into a collection like the receiver. Answer  
	the new collection."

	| newSet |
	newSet _ Set new: self size.
	array do: [:each | each ifNotNil: [newSet add: (aBlock value: each)]].
	^ newSet! !

!Set methodsFor: 'enumerating' stamp: 'sma 5/12/2000 14:36'!
do: aBlock 
	tally = 0 ifTrue: [^ self].
	1 to: array size do:
		[:index |
		| each |
		(each _ array at: index) ifNotNil: [aBlock value: each]]! !

!Set methodsFor: 'enumerating'!
doWithIndex: aBlock2
	"Support Set enumeration with a counter, even though not ordered"
	| index |
	index _ 0.
	self do: [:item | aBlock2 value: item value: (index _ index+1)]! !


!Set methodsFor: 'private'!
array
	^ array! !

!Set methodsFor: 'private'!
atNewIndex: index put: anObject
	array at: index put: anObject.
	tally _ tally + 1.
	self fullCheck! !

!Set methodsFor: 'private'!
findElementOrNil: anObject
	"Answer the index of a first slot containing either a nil (indicating an empty slot) or an element that matches the given object. Answer the index of that slot or zero. Fail if neither a match nor an empty slot is found."
	| index |
	index _ self scanFor: anObject.
	index > 0 ifTrue: [ ^ index ].

	"Bad scene.  Neither have we found a matching element
	nor even an empty slot.  No hashed set is ever supposed to get
	completely full."
	self error: 'There is no free space in this set!!'.! !

!Set methodsFor: 'private'!
fixCollisionsFrom: index
	"The element at index has been removed and replaced by nil.
	This method moves forward from there, relocating any entries
	that had been placed below due to collisions with this one"
	| length oldIndex newIndex element |
	oldIndex _ index.
	length _ array size.
	[oldIndex = length
			ifTrue: [oldIndex _  1]
			ifFalse: [oldIndex _  oldIndex + 1].
	(element _ self keyAt: oldIndex) == nil]
		whileFalse: 
			[newIndex _ self findElementOrNil: element.
			oldIndex = newIndex ifFalse: [self swap: oldIndex with: newIndex]]! !

!Set methodsFor: 'private' stamp: 'di 11/4/97 20:11'!
fullCheck
	"Keep array at least 1/4 free for decent hash behavior"
	array size - tally < (array size // 4 max: 1)
		ifTrue: [self grow]! !

!Set methodsFor: 'private'!
grow
	"Grow the elements array and reinsert the old elements"
	| oldElements |
	oldElements _ array.
	array _ Array new: array size + self growSize.
	tally _ 0.
	oldElements do:
		[:each | each == nil ifFalse: [self noCheckAdd: each]]! !

!Set methodsFor: 'private'!
growSize
	^ array size max: 2! !

!Set methodsFor: 'private'!
init: n
	"Initialize array to an array size of n"
	array _ Array new: n.
	tally _ 0! !

!Set methodsFor: 'private'!
keyAt: index
	"May be overridden by subclasses so that fixCollisions will work"
	^ array at: index! !

!Set methodsFor: 'private'!
noCheckAdd: anObject
	array at: (self findElementOrNil: anObject) put: anObject.
	tally _ tally + 1! !

!Set methodsFor: 'private'!
rehash
	| newSelf |
	newSelf _ self species new: self size.
	self do: [:each | newSelf noCheckAdd: each].
	array _ newSelf array! !

!Set methodsFor: 'private'!
scanFor: anObject
	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."
	| element start finish |
	start _ (anObject hash \\ array size) + 1.
	finish _ array size.

	"Search from (hash mod size) to the end."
	start to: finish do:
		[:index | ((element _ array at: index) == nil or: [element = anObject])
			ifTrue: [^ index ]].

	"Search from 1 to where we started."
	1 to: start-1 do:
		[:index | ((element _ array at: index) == nil or: [element = anObject])
			ifTrue: [^ index ]].

	^ 0  "No match AND no empty slot"! !

!Set methodsFor: 'private'!
swap: oneIndex with: otherIndex
	"May be overridden by subclasses so that fixCollisions will work"

	array swap: oneIndex with: otherIndex
! !

!Set methodsFor: 'private'!
withArray: anArray
	"private -- for use only in copy"
	array _ anArray! !


!Set methodsFor: 'removing' stamp: 'sma 5/12/2000 14:45'!
copyWithout: oldElement 
	"Answer a copy of the receiver that does not contain any
	elements equal to oldElement."

	^ self copy
		remove: oldElement ifAbsent: [];
		yourself! !

!Set methodsFor: 'removing'!
remove: oldObject ifAbsent: aBlock

	| index |
	index _ self findElementOrNil: oldObject.
	(array at: index) == nil ifTrue: [ ^ aBlock value ].
	array at: index put: nil.
	tally _ tally - 1.
	self fixCollisionsFrom: index.
	^ oldObject! !


!Set methodsFor: 'testing'!
= aSet
	(aSet isKindOf: Set) ifFalse: [^ false].
	self size = aSet size ifFalse: [^ false].
	self do: [:each | (aSet includes: each) ifFalse: [^ false]].
	^ true! !

!Set methodsFor: 'testing'!
includes: anObject 
	^ (array at: (self findElementOrNil: anObject)) ~~ nil! !

!Set methodsFor: 'testing' stamp: 'sma 5/12/2000 14:46'!
occurrencesOf: anObject 
	^ (self includes: anObject) ifTrue: [1] ifFalse: [0]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Set class
	instanceVariableNames: ''!

!Set class methodsFor: 'instance creation'!
new
	^ self new: 4! !

!Set class methodsFor: 'instance creation'!
new: nElements
	"Create a Set large enough to hold nElements without growing"
	^ super new init: (self sizeFor: nElements)! !

!Set class methodsFor: 'instance creation'!
newFrom: aCollection 
	"Answer an instance of me containing the same elements as aCollection."
	| newCollection |
	newCollection _ self new: aCollection size.
	newCollection addAll: aCollection.
	^ newCollection
"
	Set newFrom: {1. 2. 3}
	{1. 2. 3} as: Set
"! !

!Set class methodsFor: 'instance creation'!
sizeFor: nElements
	"Large enough size to hold nElements with some slop (see fullCheck)"
	nElements <= 0 ifTrue: [^ 1].
	^ nElements+1*4//3! !


!Set class methodsFor: 'initialization'!
rehashAllSets  "Set rehashAllSets"
	| insts |
	self withAllSubclassesDo:
		[:c | insts _ c allInstances.
		insts isEmpty ifFalse:
		['Rehashing instances of ' , c name
			displayProgressAt: Sensor cursorPoint
			from: 1 to: insts size
			during: [:bar |
			1 to: insts size do:
				[:x | bar value: x.
				(insts at: x) rehash]]]]! !


Set subclass: #Dictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Collections-Unordered'!
!Dictionary commentStamp: '<historical>' prior: 0!
I represent a set of elements that can be viewed from one of two perspectives: a set of associations, or a set of values that are externally named where the name can be any object that responds to =. The external name is referred to as the key.!


!Dictionary methodsFor: 'accessing'!
associationAt: key 
	^ self associationAt: key ifAbsent: [self errorKeyNotFound]! !

!Dictionary methodsFor: 'accessing'!
associationAt: key ifAbsent: aBlock 
	"Answer the association with the given key.
	If key is not found, return the result of evaluating aBlock."

	| index assoc |
	index _ self findElementOrNil: key.
	assoc _ array at: index.
	nil == assoc ifTrue: [ ^ aBlock value ].
	^ assoc! !

!Dictionary methodsFor: 'accessing'!
at: key 
	"Answer the value associated with the key."

	^ self at: key ifAbsent: [self errorKeyNotFound]! !

!Dictionary methodsFor: 'accessing' stamp: 'sma 5/12/2000 14:59'!
at: key ifAbsent: aBlock 
	"Answer the value associated with the key or, if key isn't found,
	answer the result of evaluating aBlock."

	| assoc |
	assoc _ array at: (self findElementOrNil: key).
	assoc ifNil: [^ aBlock value].
	^ assoc value! !

!Dictionary methodsFor: 'accessing' stamp: 'sma 5/12/2000 15:01'!
at: key ifAbsentPut: aBlock 
	"Return the value at the given key. 
	If key is not included in the receiver store the result 
	of evaluating aBlock as new value."

	^ self at: key ifAbsent: [self at: key put: aBlock value]! !

!Dictionary methodsFor: 'accessing' stamp: 'jm 5/15/1998 07:20'!
at: key ifPresent: aBlock
	"Lookup the given key in the receiver. If it is present, answer the value of evaluating the given block with the value associated with the key. Otherwise, answer nil."

	| v |
	v _ self at: key ifAbsent: [^ nil].
	^ aBlock value: v
! !

!Dictionary methodsFor: 'accessing' stamp: 'sma 5/12/2000 15:00'!
at: key put: anObject 
	"Set the value at key to be anObject.  If key is not found, create a
	new entry for key and set is value to anObject. Answer anObject."

	| index assoc |
	index _ self findElementOrNil: key.
	assoc _ array at: index.
	assoc
		ifNil: [self atNewIndex: index put: (Association key: key value: anObject)]
		ifNotNil: [assoc value: anObject].
	^ anObject! !

!Dictionary methodsFor: 'accessing' stamp: 'ar 2/13/1999 21:16'!
keyAtIdentityValue: value 
	"Answer the key that is the external name for the argument, value. If 
	there is none, answer nil.
	Note: There can be multiple keys with the same value. Only one is returned."

	^self keyAtIdentityValue: value ifAbsent: [self errorValueNotFound]! !

!Dictionary methodsFor: 'accessing' stamp: 'ar 2/13/1999 21:16'!
keyAtIdentityValue: value ifAbsent: exceptionBlock
	"Answer the key that is the external name for the argument, value. If 
	there is none, answer the result of evaluating exceptionBlock.
	Note: There can be multiple keys with the same value. Only one is returned."
 
	self associationsDo: 
		[:association | value == association value ifTrue: [^association key]].
	^exceptionBlock value! !

!Dictionary methodsFor: 'accessing'!
keyAtValue: value 
	"Answer the key that is the external name for the argument, value. If 
	there is none, answer nil."

	^self keyAtValue: value ifAbsent: [self errorValueNotFound]! !

!Dictionary methodsFor: 'accessing' stamp: 'tk 2/18/97'!
keyAtValue: value ifAbsent: exceptionBlock
	"Answer the key that is the external name for the argument, value. If 
	there is none, answer the result of evaluating exceptionBlock.
	: Use =, not ==, so stings like 'this' can be found.  Note that MethodDictionary continues to use == so it will be fast."
 
	self associationsDo: 
		[:association | value = association value ifTrue: [^association key]].
	^exceptionBlock value! !

!Dictionary methodsFor: 'accessing'!
keys
	"Answer a Set containing the receiver's keys."
	| aSet |
	aSet _ Set new: self size.
	self keysDo: [:key | aSet add: key].
	^ aSet! !

!Dictionary methodsFor: 'accessing' stamp: 'di 3/8/2000 09:12'!
keysSortedSafely
	"Answer a SortedCollection containing the receiver's keys."
	| sortedKeys |
	sortedKeys _ SortedCollection new: self size.
	sortedKeys sortBlock:
		[ :x :y |  "Should really be use <obj, string, num> compareSafely..."
		(((x isKindOf: String) & (y isKindOf: String))
		or: [(x isKindOf: Number) & (y isKindOf: Number)])
			ifTrue: [ x < y]
			ifFalse: [ (x class = y class)
				ifTrue: [ x printString < y printString]
				ifFalse: [ x class name < y class name ] ] ].
	self keysDo:
		[ :aKey | sortedKeys add: aKey. ].
	^ sortedKeys
! !

!Dictionary methodsFor: 'accessing' stamp: 'ar 7/11/1999 07:28'!
values
	"Answer a Collection containing the receiver's values."
	| out |
	out _ WriteStream on: (Array new: self size).
	self valuesDo: [:value | out nextPut: value].
	^ out contents! !


!Dictionary methodsFor: 'testing'!
includes: anObject

	self do: [:each | anObject = each ifTrue: [^true]].
	^false! !

!Dictionary methodsFor: 'testing'!
includesKey: key 
	"Answer whether the receiver has a key equal to the argument, key."
	| index |
	index _ self findElementOrNil: key.
	(array at: index) == nil	
		ifTrue: [^ false]
		ifFalse: [^ true]! !

!Dictionary methodsFor: 'testing'!
occurrencesOf: anObject 
	"Answer how many of the receiver's elements are equal to anObject."

	| count |
	count _ 0.
	self do: [:each | anObject = each ifTrue: [count _ count + 1]].
	^count! !


!Dictionary methodsFor: 'adding'!
add: anAssociation
	| index element |
	index _ self findElementOrNil: anAssociation key.
	element _ array at: index.
	element == nil
		ifTrue: [self atNewIndex: index put: anAssociation]
		ifFalse: [element value: anAssociation value].
	^ anAssociation! !

!Dictionary methodsFor: 'adding'!
declare: key from: aDictionary 
	"Add key to the receiver. If key already exists, do nothing. If aDictionary 
	includes key, then remove it from aDictionary and use its association as 
	the element of the receiver."

	(self includesKey: key) ifTrue: [^ self].
	(aDictionary includesKey: key)
		ifTrue: 
			[self add: (aDictionary associationAt: key).
			aDictionary removeKey: key]
		ifFalse: 
			[self add: key -> nil]! !


!Dictionary methodsFor: 'removing' stamp: 'di 4/4/2000 11:47'!
keysAndValuesRemove: keyValueBlock
	"Removes all entries for which keyValueBlock returns true."
	"When removing many items, you must not do it while iterating over the dictionary, since it may be changing.  This method takes care of tallying the removals in a first pass, and then performing all the deletions afterward.  Many places in the sytem could be simplified by using this method."

	| removals |
	removals _ OrderedCollection new.
	self associationsDo:
		[:assoc | (keyValueBlock value: assoc key value: assoc value)
			ifTrue: [removals add: assoc key]].
 	removals do:
		[:aKey | self removeKey: aKey]! !

!Dictionary methodsFor: 'removing'!
remove: anObject

	self shouldNotImplement! !

!Dictionary methodsFor: 'removing'!
remove: anObject ifAbsent: exceptionBlock

	self shouldNotImplement! !

!Dictionary methodsFor: 'removing'!
removeKey: key 
	"Remove key from the receiver.
	If key is not in the receiver, notify an error."

	^ self removeKey: key ifAbsent: [self errorKeyNotFound]! !

!Dictionary methodsFor: 'removing'!
removeKey: key ifAbsent: aBlock 
	"Remove key (and its associated value) from the receiver. If key is not in 
	the receiver, answer the result of evaluating aBlock. Otherwise, answer 
	the value externally named by key."

	| index assoc |
	index _ self findElementOrNil: key.
	assoc _ array at: index.
	assoc == nil ifTrue: [ ^ aBlock value ].
	array at: index put: nil.
	tally _ tally - 1.
	self fixCollisionsFrom: index.
	^ assoc value! !

!Dictionary methodsFor: 'removing'!
removeUnreferencedKeys   "Undeclared removeUnreferencedKeys"

	^ self unreferencedKeys do: [:key | self removeKey: key].! !

!Dictionary methodsFor: 'removing'!
unreferencedKeys		"TextConstants unreferencedKeys"
	| n |
	^ 'Scanning for references . . .'
		displayProgressAt: Sensor cursorPoint
		from: 0 to: self size
		during:
		[:bar | n _ 0.
		self keys select:
			[:key | bar value: (n _ n+1).
			(Smalltalk allCallsOn: (self associationAt: key)) isEmpty]]! !


!Dictionary methodsFor: 'enumerating'!
associationsDo: aBlock 
	"Evaluate aBlock for each of the receiver's elements (key/value 
	associations)."

	super do: aBlock! !

!Dictionary methodsFor: 'enumerating'!
collect: aBlock 
	"Evaluate aBlock with each of my values as the argument.  Collect the
	resulting values into a collection that is like me. Answer with the new
	collection."
	| newCollection |
	newCollection _ OrderedCollection new: self size.
	self do: [:each | newCollection add: (aBlock value: each)].
	^ newCollection! !

!Dictionary methodsFor: 'enumerating'!
do: aBlock

	super do: [:assoc | aBlock value: assoc value]! !

!Dictionary methodsFor: 'enumerating' stamp: 'ar 7/11/1999 08:04'!
keysAndValuesDo: aBlock
	^self associationsDo:[:assoc|
		aBlock value: assoc key value: assoc value].! !

!Dictionary methodsFor: 'enumerating'!
keysDo: aBlock 
	"Evaluate aBlock for each of the receiver's keys."

	self associationsDo: [:association | aBlock value: association key]! !

!Dictionary methodsFor: 'enumerating'!
select: aBlock 
	"Evaluate aBlock with each of my values as the argument. Collect into a
	new dictionary, only those associations for which aBlock evaluates to
	true."

	| newCollection |
	newCollection _ self species new.
	self associationsDo: 
		[:each | 
		(aBlock value: each value) ifTrue: [newCollection add: each]].
	^newCollection! !

!Dictionary methodsFor: 'enumerating' stamp: 'ar 7/11/1999 07:29'!
valuesDo: aBlock 
	"Evaluate aBlock for each of the receiver's keys."

	self associationsDo: [:association | aBlock value: association value]! !


!Dictionary methodsFor: 'printing' stamp: 'sma 6/1/2000 09:52'!
printElementsOn: aStream
	aStream nextPut: $(.
	self keysSortedSafely do:
		[:key | aStream print: key; nextPutAll: '->'; print: (self at: key); space].
	aStream nextPut: $)! !

!Dictionary methodsFor: 'printing'!
storeOn: aStream
	| noneYet |
	aStream nextPutAll: '(('.
	aStream nextPutAll: self class name.
	aStream nextPutAll: ' new)'.
	noneYet _ true.
	self associationsDo: 
			[:each | 
			noneYet
				ifTrue: [noneYet _ false]
				ifFalse: [aStream nextPut: $;].
			aStream nextPutAll: ' add: '.
			aStream store: each].
	noneYet ifFalse: [aStream nextPutAll: '; yourself'].
	aStream nextPut: $)! !


!Dictionary methodsFor: 'private' stamp: 'tk 8/21/97 16:12'!
copy
	"Must copy the associations, or later store will effect both the
original and the copy"

	^ self shallowCopy withArray:
		(array collect: [:assoc |
			assoc ifNil: [nil]
				ifNotNil: [Association key: assoc key
value: assoc value]])! !

!Dictionary methodsFor: 'private'!
errorKeyNotFound

	self error: 'key not found'! !

!Dictionary methodsFor: 'private'!
errorValueNotFound

	self error: 'value not found'! !

!Dictionary methodsFor: 'private'!
keyAt: index
	"May be overridden by subclasses so that fixCollisions will work"
	| assn |
	assn _ array at: index.
	assn == nil ifTrue: [^ nil]
				ifFalse: [^ assn key]! !

!Dictionary methodsFor: 'private'!
noCheckAdd: anObject
	"Must be defined separately for Dictionary because (self findElementOrNil:) expects a key, not an association.  9/7/96 tk"

	array at: (self findElementOrNil: anObject key) put: anObject.
	tally _ tally + 1! !

!Dictionary methodsFor: 'private'!
rehash
	"Smalltalk rehash."
	| newSelf |
	newSelf _ self species new: self size.
	self associationsDo: [:each | newSelf noCheckAdd: each].
	array _ newSelf array! !

!Dictionary methodsFor: 'private'!
scanFor: anObject
	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."
	| element start finish |
	start _ (anObject hash \\ array size) + 1.
	finish _ array size.

	"Search from (hash mod size) to the end."
	start to: finish do:
		[:index | ((element _ array at: index) == nil or: [element key = anObject])
			ifTrue: [^ index ]].

	"Search from 1 to where we started."
	1 to: start-1 do:
		[:index | ((element _ array at: index) == nil or: [element key = anObject])
			ifTrue: [^ index ]].

	^ 0  "No match AND no empty slot"! !

!Dictionary methodsFor: 'private'!
valueAtNewKey: aKey put: anObject atIndex: index declareFrom: aDictionary 
	"Support for coordinating class variable and global declarations
	with variables that have been put in Undeclared so as to
	redirect all references to the undeclared variable."

	(aDictionary includesKey: aKey)
		ifTrue: 
			[self atNewIndex: index 
				put: ((aDictionary associationAt: aKey) value: anObject).
			aDictionary removeKey: aKey]
		ifFalse: 
			[self atNewIndex: index put: (Association key: aKey value: anObject)]! !


!Dictionary methodsFor: 'user interface' stamp: 'tk 4/12/1998 08:54'!
inspect
	"Open a DictionaryInspector on the receiver.  Use basicInspect to get a normal (less useful) type of inspector."

	DictionaryInspector openOn: self withEvalPane: true! !

!Dictionary methodsFor: 'user interface' stamp: 'tk 4/12/1998 08:54'!
inspectWithLabel: aLabel
	"Open a DictionaryInspector on the receiver. Use basicInspect to get a normal (less useful) type of inspector."

	DictionaryInspector openOn: self withEvalPane: true withLabel: aLabel! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Dictionary class
	instanceVariableNames: ''!

!Dictionary class methodsFor: 'instance creation'!
newFrom: aDict 
	"Answer an instance of me containing the same associations as aDict.
	 Error if any key appears twice."
	| newDictionary |
	newDictionary _ self new: aDict size.
	aDict associationsDo:
		[:x |
		(newDictionary includesKey: x key)
			ifTrue: [self error: 'Duplicate key: ', x key printString]
			ifFalse: [newDictionary add: x]].
	^ newDictionary

"	NewDictionary newFrom: {1->#a. 2->#b. 3->#c}
	{1->#a. 2->#b. 3->#c} as: NewDictionary
	NewDictionary newFrom: {1->#a. 2->#b. 1->#c}
	{1->#a. 2->#b. 1->#c} as: NewDictionary
"! !


Dictionary subclass: #IdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Collections-Unordered'!

!IdentityDictionary methodsFor: 'private' stamp: 'di 12/1/1999 20:54'!
keyAtValue: value ifAbsent: exceptionBlock
	"Answer the key that is the external name for the argument, value. If 
	there is none, answer the result of evaluating exceptionBlock."
 
	self associationsDo: 
		[:association | value == association value ifTrue: [^ association key]].
	^ exceptionBlock value! !

!IdentityDictionary methodsFor: 'private' stamp: 'di 10/1/97 20:51'!
keys
	"Answer a Set containing the receiver's keys."
	| aSet |
	aSet _ IdentitySet new: self size.
	self keysDo: [:key | aSet add: key].
	^ aSet! !

!IdentityDictionary methodsFor: 'private' stamp: 'jm 2/18/98 13:18'!
scanFor: anObject
	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."
	| finish hash start element |
	finish _ array size.
	finish > 4096
		ifTrue: [hash _ anObject identityHash * (finish // 4096)]
		ifFalse: [hash _ anObject identityHash].
	start _ (hash \\ array size) + 1.

	"Search from (hash mod size) to the end."
	start to: finish do:
		[:index | ((element _ array at: index) == nil or: [element key == anObject])
			ifTrue: [^ index ]].

	"Search from 1 to where we started."
	1 to: start-1 do:
		[:index | ((element _ array at: index) == nil or: [element key == anObject])
			ifTrue: [^ index ]].

	^ 0  "No match AND no empty slot"! !


IdentityDictionary subclass: #SystemDictionary
	instanceVariableNames: 'cachedClassNames '
	classVariableNames: 'LastImageName LastQuitLogPosition LowSpaceProcess LowSpaceSemaphore StartupStamp SystemChanges VersionString '
	poolDictionaries: ''
	category: 'System-Support'!
!SystemDictionary commentStamp: '<historical>' prior: 0!
I represent a special dictionary that supports protocol for asking questions about the structure of the system. Other than class names, I contain (print this)...
	Smalltalk keys select: [:k | ((Smalltalk at: k) isKindOf: Class) not]
			thenCollect: [:k | k -> (Smalltalk at: k) class]
!


!SystemDictionary methodsFor: 'dictionary access' stamp: 'di 12/6/1999 12:42'!
associationAtOrAbove: varName ifAbsent: absentBlock 
	"Compatibility with environment protocol."

	^ self associationAt: varName ifAbsent: absentBlock! !

!SystemDictionary methodsFor: 'dictionary access'!
at: aKey put: anObject 
	"Override from Dictionary to check Undeclared and fix up
	references to undeclared variables."
	| index element |
	(self includesKey: aKey) ifFalse: 
		[self declare: aKey from: Undeclared.
		self flushClassNameCache].
	super at: aKey put: anObject.
	^ anObject! !

!SystemDictionary methodsFor: 'dictionary access' stamp: 'di 12/21/1999 12:00'!
atOrAbove: key ifAbsent: absentBlock
	"Compatibility with environment protocol."

	^ self at: key ifAbsent: absentBlock! !

!SystemDictionary methodsFor: 'dictionary access' stamp: 'di 12/6/1999 13:43'!
atOrBelow: key ifAbsent: absentBlock
	"Compatibility with environment protocol."

	^ self at: key ifAbsent: absentBlock! !

!SystemDictionary methodsFor: 'dictionary access' stamp: 'di 12/21/1999 12:00'!
includesKeyOrAbove: key
	"Compatibility with environment protocol."

	self atOrAbove: key ifAbsent: [^ false].
	^ true! !

!SystemDictionary methodsFor: 'dictionary access' stamp: 'di 12/19/1999 21:17'!
scopeFor: varName from: lower envtAndPathIfFound: envtAndPathBlock
	"Null compatibility with partitioning into environments."

	(self includesKey: varName)
		ifTrue: [^ envtAndPathBlock value: self value: String new]
		ifFalse: [^ nil]! !


!SystemDictionary methodsFor: 'browsing' stamp: 'di 9/5/97 16:05'!
browseAllCallsOn: aLiteral 
	"Create and schedule a message browser on each method that refers to
	aLiteral. For example, Smalltalk browseAllCallsOn: #open:label:."
	(aLiteral isKindOf: LookupKey)
		ifTrue: [self browseMessageList: (self allCallsOn: aLiteral) asSortedCollection
					name: 'Users of ' , aLiteral key
					autoSelect: aLiteral key]
		ifFalse: [self browseMessageList: (self allCallsOn: aLiteral) asSortedCollection
					name: 'Senders of ' , aLiteral
					autoSelect: aLiteral keywords first]! !

!SystemDictionary methodsFor: 'browsing'!
browseAllImplementorsOf: selector
	"Create and schedule a message browser on each method that implements 
	the message whose selector is the argument, selector. For example, 
	Smalltalk browseAllImplementorsOf: #at:put:."

	^self browseMessageList: (self allImplementorsOf: selector) name: 'Implementors of ' , selector! !

!SystemDictionary methodsFor: 'browsing'!
browseAllImplementorsOfList: selectorList title: aTitle
	"Create and schedule a message browser on each method that implements the message whose selector is in the argument selectorList. For example,  Smalltalk browseAllImplementorsOf: #(at:put: size).
	1/16/96 sw: this variant adds the title argument.
	1/24/96 sw: use a SortedCollection
	2/1/96 sw: show normal cursor"

	| implementorLists flattenedList |

	implementorLists _ selectorList collect: [:each | self allImplementorsOf: each].
	flattenedList _ SortedCollection new.
	implementorLists do: [:each | flattenedList addAll: each].
	Cursor normal show.
	^ self browseMessageList: flattenedList name: aTitle! !

!SystemDictionary methodsFor: 'browsing'!
browseAllMethodsInCategory: category 
	^self browseMessageList: (self allMethodsInCategory: category)
		name: category! !

!SystemDictionary methodsFor: 'browsing' stamp: 'di 5/4/1999 13:52'!
browseAllObjectReferencesTo: anObject except: objectsToExclude ifNone: aBlock
	"Bring up a list inspector on the objects that point to anObject.
	If there are none, then evaluate aBlock on anObject.  "

	| aList shortName |
	aList _ Smalltalk pointersTo: anObject except: objectsToExclude.
	aList size > 0 ifFalse: [^ aBlock value: anObject].
	shortName _ (anObject name ifNil: [anObject printString]) contractTo: 20.
	OrderedCollectionInspector openOn: aList withEvalPane: false
		withLabel: 'Objects pointing to ', shortName.! !

!SystemDictionary methodsFor: 'browsing'!
browseAllSelect: aBlock
	"Create and schedule a message browser on each method that, when used 
	as the block argument to aBlock gives a true result. For example, 
	Smalltalk browseAllSelect: [:method | method numLiterals > 10]."

	^self browseMessageList: (self allSelect: aBlock) name: 'selected messages'! !

!SystemDictionary methodsFor: 'browsing' stamp: 'sw 8/15/97 15:32'!
browseAllSelect: aBlock name: aName autoSelect: autoSelectString
	"Create and schedule a message browser on each method that, when used 
	as the block argument to aBlock gives a true result.   Do not return an #DoIt traces."

	"Smalltalk browseAllSelect: [:method | method numLiterals > 10] name: 'Methods with more than 10 literals' autoSelect: 'isDigit'"

	^ self browseMessageList: (self allSelectNoDoits: aBlock) name: aName autoSelect: autoSelectString! !

!SystemDictionary methodsFor: 'browsing'!
browseAllUnSentMessages
	"Create and schedule a message browser on each method whose message is 
	not sent in any method in the system."

	^self browseMessageList: self allUnSentMessages name: 'UnSent Messages'! !

!SystemDictionary methodsFor: 'browsing'!
browseAllUnimplementedCalls
	"Create and schedule a message browser on each method that includes a 
	message that is not implemented in any object in the system."

	^self browseMessageList: self allUnimplementedCalls name: 'Unimplemented calls'! !

!SystemDictionary methodsFor: 'browsing'!
browseMessageList: messageList name: label 
	"Create and schedule a MessageSet browser on messageList."
	^ self browseMessageList: messageList name: label autoSelect: nil! !

!SystemDictionary methodsFor: 'browsing' stamp: 'sw 9/21/1999 11:38'!
browseMessageList: messageList name: labelString autoSelect: autoSelectString
	| title aSize |
	"Create and schedule a MessageSet browser on the message list."

	messageList size = 0 ifTrue: 
		[^ (PopUpMenu labels: ' OK ')
				startUpWithCaption: 'There are no
' , labelString].

	title _ (aSize _ messageList size) > 1
		ifFalse:	[labelString]
		ifTrue:	[ labelString, ' [', aSize printString, ']'].

	MessageSet openMessageList: messageList name: title autoSelect: autoSelectString! !

!SystemDictionary methodsFor: 'browsing'!
browseMethodsWhoseNamesContain: aString
	"Launch a browser on all methods whose names contain the given string; case-insensitive.  This takes a long time right now.  1/16/96 sw"

	| aList |
	aList _ Symbol selectorsContaining: aString.
	aList size > 0 ifTrue: 
		[self browseAllImplementorsOfList: aList asSortedCollection title: 'Methods whose names contain ''', aString, '''']! !

!SystemDictionary methodsFor: 'browsing' stamp: 'di 11/23/1998 12:05'!
browseMethodsWithSourceString: aString
	"Smalltalk browseMethodsWithSourceString: 'SourceString' "
	"Launch a browser on all methods whose source code contains aString as a substring."

	| caseSensitive suffix |
	(caseSensitive _ Sensor shiftPressed)
		ifTrue: [suffix _ ' (case-sensitive)']
		ifFalse: [suffix _ ' (use shift for case-sensitive)'].
	^ self browseMessageList: (self allMethodsWithSourceString: aString
									matchCase: caseSensitive)
		name: 'Methods containing ' , aString printString , suffix autoSelect: aString! !

!SystemDictionary methodsFor: 'browsing' stamp: 'di 11/23/1998 12:05'!
browseMethodsWithString: aString
	"Launch a browser on all methods that contain string literals with aString as a substring. The search is case-insensitive, unless the shift key is pressed, in which case the search is case-sensitive."

	| caseSensitive suffix |
	(caseSensitive _ Sensor shiftPressed)
		ifTrue: [suffix _ ' (case-sensitive)']
		ifFalse: [suffix _ ' (use shift for case-sensitive)'].
	self browseAllSelect:
			[:method |
				method  hasLiteralSuchThat: [:lit |
					lit class == String and:
					[lit includesSubstring: aString caseSensitive: caseSensitive]]]
		name:  'Methods with string ', aString printString, suffix
		autoSelect: aString.
! !

!SystemDictionary methodsFor: 'browsing' stamp: 'tk 6/24/1999 11:28'!
browseObsoleteReferences   "Smalltalk browseObsoleteReferences"
	| references |
	references _ OrderedCollection new.
	(Association allSubInstances select:
		[:x | ((x value isKindOf: Behavior) and: ['AnOb*' match: x value name]) or:
		['AnOb*' match: x value class name]]) 
		do: [:x | references addAll: (Smalltalk allCallsOn: x)].
	Smalltalk browseMessageList: references name: 'References to Obsolete Classes'! !

!SystemDictionary methodsFor: 'browsing' stamp: 'di 4/15/98 09:41'!
showMenuOf: selectorCollection withFirstItem: firstItem ifChosenDo: choiceBlock
	"Show a sorted menu of the given selectors, preceded by firstItem, and all
	abbreviated to 40 characters.  Evaluate choiceBlock if a message is chosen."
	| index menuLabels sortedList |
	sortedList _ selectorCollection asSortedCollection.
	menuLabels _ String streamContents: 
		[:strm | strm nextPutAll: (firstItem contractTo: 40).
		sortedList do: [:sel | strm cr; nextPutAll: (sel contractTo: 40)]].
	index _ (PopUpMenu labels: menuLabels lines: #(1)) startUp.
	index = 1 ifTrue: [choiceBlock value: firstItem].
	index > 1 ifTrue: [choiceBlock value: (sortedList at: index-1)]! !


!SystemDictionary methodsFor: 'retrieving' stamp: 'jm 5/18/2003 15:03'!
allBehaviorsDo: aBlock 
	"Evaluate the argument, aBlock, for each kind of Behavior in the system (that is, Object and its subclasses)."
	"ar 7/15/1999: The code below will not enumerate any obsolete or anonymous behaviors for which the following can be executed:
		Smalltalk allObjectsDo: [:obj | obj isBehavior ifTrue: [aBlock value: obj]].
	but what follows is way faster than enumerating all objects."

	aBlock value: Object.
	Object allSubclassesDo: aBlock.

	"Classes outside the Object hierarchy"
	Class subclassesDo: [:aClass |
		false & aClass isMeta ifTrue: [
			"Enumerate the non-meta class and its subclasses"
			aBlock value: aClass soleInstance.
			aClass soleInstance allSubclassesDo: aBlock]].
! !

!SystemDictionary methodsFor: 'retrieving' stamp: 'ls 10/10/1999 13:22'!
allCallsOn: aLiteral   "Smalltalk browseAllCallsOn: #open:label:."
	"Answer a Collection of all the methods that call on aLiteral."
	| aCollection special thorough aList byte |

	#(23 48 'fred' (new open:label:)) size.
		"Example above should find #open:label:, though it is deeply embedded
here."
	aCollection _ OrderedCollection new.
	special _ self hasSpecialSelector: aLiteral ifTrueSetByte: [:b | byte _
b ].
	thorough _ (aLiteral isMemberOf: Symbol)
				and: ["Possibly search for symbols imbedded in literal arrays"
					Preferences thoroughSenders].
	Cursor wait showWhile: 
		[self allBehaviorsDo: 
			[:class |
				aList _ thorough
					ifTrue:
			 			[(class thoroughWhichSelectorsReferTo: aLiteral special: special
byte: byte)]
					ifFalse:
						[class whichSelectorsReferTo: aLiteral special: special byte:
byte].
				aList do: 
					[:sel | sel ~~ #DoIt
						ifTrue: [aCollection add: class name , ' ' , sel]]]].
	^ aCollection! !

!SystemDictionary methodsFor: 'retrieving'!
allClassesDo: aBlock
	"Evaluate the argument, aBlock, for each class in the system."

	(self classNames collect: [:name | Smalltalk at: name]) do: aBlock! !

!SystemDictionary methodsFor: 'retrieving'!
allClassesImplementing: aSelector  
	"Answer an Array of all classes that implement the message aSelector."

	| aCollection |
	aCollection _ ReadWriteStream on: Array new.
	self allBehaviorsDo:
		[:class | (class includesSelector: aSelector)
			ifTrue: [aCollection nextPut: class]].
	^ aCollection contents! !

!SystemDictionary methodsFor: 'retrieving' stamp: 'bf 9/22/1999 16:56'!
allImplementedMessages
	"Answer a Set of all the messages that are sent by a method in the system 
	but are not implemented."

	| aSet |
	aSet _ IdentitySet new: Symbol instanceCount.
	Cursor wait showWhile: 
		[self allBehaviorsDo: [:cl | cl selectorsDo: [:aSelector | aSet add: aSelector]]].
	^aSet! !

!SystemDictionary methodsFor: 'retrieving'!
allImplementorsOf: aSelector  
	"Answer a SortedCollection of all the methods that implement the message 
	aSelector."

	| aCollection |
	aCollection _ SortedCollection new.
	Cursor wait showWhile:
		[self allBehaviorsDo:
			[:class |
			(class includesSelector: aSelector)
				ifTrue: [aCollection add: class name, ' ', aSelector]]].
	^aCollection! !

!SystemDictionary methodsFor: 'retrieving'!
allMethodsInCategory: category 
	| aCollection |
	aCollection _ SortedCollection new.
	Cursor wait showWhile:
		[self allBehaviorsDo:
			[:x | (x organization listAtCategoryNamed: category) do:
				[:sel | aCollection add: x name , ' ' , sel]]].
	^aCollection! !

!SystemDictionary methodsFor: 'retrieving' stamp: 'di 11/23/1998 12:02'!
allMethodsWithSourceString: aString matchCase: caseSensitive
	"Answer a SortedCollection of all the methods that contain, in source code, aString as a substring.  The search is case-insensitive."
	| list classCount |
	list _ Set new.
'Searching all source code...'
displayProgressAt: Sensor cursorPoint
from: 0 to: Smalltalk classNames size
during:
	[:bar | classCount _ 0.
	Smalltalk allClassesDo:
		[:class | bar value: (classCount _ classCount + 1).
		(Array with: class with: class class) do:
			[:cl | cl selectorsDo:
				[:sel | 
				((cl sourceCodeAt: sel) findString: aString startingAt: 1 caseSensitive: caseSensitive) > 0
					ifTrue:
					[sel == #DoIt ifFalse: [list add: cl name , ' ' , sel]]]]]].
	^ list asSortedCollection! !

!SystemDictionary methodsFor: 'retrieving' stamp: 'sw 8/12/97 20:57'!
allMethodsWithString: aString 
	"Answer a SortedCollection of all the methods that contain, in a string literal, aString as a substring.  2/1/96 sw.  The search is case-sensitive, and does not dive into complex literals, confining itself to string constants.
	5/2/96 sw: fixed so that duplicate occurrences of aString in the same method don't result in duplicated entries in the browser"

	| aStringSize list lits |

	aStringSize _ aString size.
	list _ Set new.

	Cursor wait showWhile: [self allBehaviorsDo: 
		[:class | class selectorsDo:
			[:sel | sel ~~ #DoIt ifTrue:
				[lits _ (class compiledMethodAt: sel) literals.
				lits do:
					[:aLiteral | ((aLiteral isMemberOf: String) and:
						[aLiteral size >= aStringSize])
							ifTrue:
								[(aLiteral findString: aString startingAt: 1)  > 0 ifTrue:
									[list add: class name , ' ' , sel]]]]]]].
	^ list asSortedCollection! !

!SystemDictionary methodsFor: 'retrieving'!
allObjectsDo: aBlock 
	"Evaluate the argument, aBlock, for each object in the system
	 excluding SmallIntegers."

	| object |
	object _ self someObject.
	[0 == object] whileFalse: [
		aBlock value: object.
		object _ object nextObject.
	].! !

!SystemDictionary methodsFor: 'retrieving'!
allPrimitiveMessages
	"Answer an OrderedCollection of all the methods that are implemented by 
	primitives."

	| aColl aSelector method | 
	aColl _ OrderedCollection new: 200.
	Cursor execute showWhile: 
		[self allBehaviorsDo: 
			[:class | class selectorsDo: 
				[:sel | 
				method _ class compiledMethodAt: sel.
				method primitive ~= 0
					ifTrue: [aColl addLast: class name , ' ' , sel 
									, ' ' , method primitive printString]]]].
	^aColl! !

!SystemDictionary methodsFor: 'retrieving'!
allSelect: aBlock 
	"Answer a SortedCollection of each method that, when used as the block 
	argument to aBlock, gives a true result."

	| aCollection |
	aCollection _ SortedCollection new.
	Cursor execute showWhile: 
		[self allBehaviorsDo: 
			[:class | class selectorsDo: 
				[:sel | (aBlock value: (class compiledMethodAt: sel))
					ifTrue: [aCollection add: class name , ' ' , sel]]]].
	^aCollection! !

!SystemDictionary methodsFor: 'retrieving' stamp: 'sw 8/15/97 15:31'!
allSelectNoDoits: aBlock 
	"Like allSelect:, but strip out Doits"

	| aCollection |
	aCollection _ SortedCollection new.
	Cursor execute showWhile: 
		[self allBehaviorsDo: 
			[:class | class selectorsDo: 
				[:sel | ((sel ~~ #DoIt) and: [(aBlock value: (class compiledMethodAt: sel))])
					ifTrue: [aCollection add: class name , ' ' , sel]]]].
	^aCollection! !

!SystemDictionary methodsFor: 'retrieving' stamp: 'bf 9/22/1999 16:39'!
allSentMessages
	"Answer the set of selectors which are sent somewhere in the system."
	| sent |
	sent _ IdentitySet new: CompiledMethod instanceCount.
	Cursor execute showWhile: 
		[self allBehaviorsDo: 
			[:cl | cl selectorsDo: 
				[:sel | "Include all sels, but not if sent by self"
			(cl compiledMethodAt: sel) literals do: 
				[:m | 
				(m isMemberOf: Symbol) ifTrue:  "might be sent"
					[m == sel ifFalse: [sent add: m]].
				(m isMemberOf: Array) ifTrue:  "might be performed"
					[m do: [:x | (x isMemberOf: Symbol) ifTrue:
						[x == sel ifFalse: [sent add: x]]]]]]].
		"The following may be sent without being in any literal frame"
		1 to: self specialSelectorSize do: 
			[:index | 
			sent add: (self specialSelectorAt: index)]].
	^ sent! !

!SystemDictionary methodsFor: 'retrieving'!
allUnSentMessages   "Smalltalk allUnSentMessages"
	"Answer the set of selectors that are implemented by some object
	in the system but not sent by any."
	| sent unsent |
	sent _ self allSentMessages.
	unsent _ Set new.
	self allImplementedMessages do:
		[:sel | (sent includes: sel) ifFalse: [unsent add: sel]].
	^ unsent
"
 | f cl lastClass |
f _ FileStream newFileNamed: 'UnsentMessages.txt'.
lastClass _ 'xx'.
methods _ SortedCollection new.
Smalltalk allUnSentMessages do:
	[:sel | methods addAll: (Smalltalk allImplementorsOf: sel)].
methods do:
	[:m | cl _ m copyUpTo: $ . 
	cl = lastClass
		ifTrue: [f nextPutAll: (m copyFrom: lastClass size+1 to: m size)]
		ifFalse: [f cr; cr; nextPutAll: m.  lastClass _ cl]].
f close.
"! !

!SystemDictionary methodsFor: 'retrieving' stamp: 'di 12/15/1998 21:47'!
allUnSentMessagesIn: selectorSet
	"Answer the subset of selectorSet which are not sent anywhere in the system.
	Factored out from#allUnSentMessages "
	|  all |
	all _ selectorSet copy.
	Cursor execute showWhile: 
		[self allBehaviorsDo: 
			[:cl | cl selectorsDo: 
				[:sel | 
				(cl compiledMethodAt: sel) literals do: 
					[:lit |
					(lit isMemberOf: Symbol)  "might be sent"
						ifTrue: [all remove: lit ifAbsent: []].
					(lit isMemberOf: Array)  "might be performed"
						ifTrue: [lit do:
								[:elt |
								(elt isMemberOf: Array)
									ifTrue: [elt do: [:e | all remove: e ifAbsent: []]]
									ifFalse: [all remove: elt ifAbsent: []]]].
					]]].
		"The following may be sent without being in any literal frame"
		1 to: self specialSelectorSize do: 
			[:index | 
			all remove: (self specialSelectorAt: index) ifAbsent: []]].
	^ all! !

!SystemDictionary methodsFor: 'retrieving'!
allUnimplementedCalls 
	"Answer an Array of each message that is sent by an expression in a 
	method but is not implemented by any object in the system."

	| aStream secondStream all  |
	all _ self allImplementedMessages.
	aStream _ WriteStream on: (Array new: 50).
	Cursor execute showWhile:
		[self allBehaviorsDo:
			[:cl |
			 cl selectorsDo:
				[:sel |
				 secondStream _ WriteStream on: (String new: 5).
				(cl compiledMethodAt: sel) messages do:
					[:m | (all includes: m) ifFalse: [secondStream nextPutAll: m; space]].
				secondStream position = 0 ifFalse:
					[aStream nextPut: cl name , ' ' , sel , ' calls: ', secondStream contents]]]].
	^aStream contents! !

!SystemDictionary methodsFor: 'retrieving'!
pointersTo: anObject
	"Find all occurrences in the system of pointers to the argument anObject."
	"(Smalltalk pointersTo: Browser) inspect."

	^ self pointersTo: anObject except: #()
! !

!SystemDictionary methodsFor: 'retrieving' stamp: 'jm 5/16/2003 10:01'!
pointersTo: anObject except: objectsToExclude
	"Find all occurrences in the system of pointers to the argument anObject. Remove objects in the exclusion list from the results."

	| results anObj |
	Smalltalk garbageCollect.
	"big collection shouldn't grow, so it's contents array is always the same"
	results _ OrderedCollection new: 1000.

	"allObjectsDo: is expanded inline to keep spurious
	 method and block contexts out of the results"
	anObj _ self someObject.
	[0 == anObj] whileFalse: [
		(anObj pointsTo: anObject) ifTrue: [
			"exclude the results collector and contexts in call chain"
			((anObj ~~ results collector) and:
			 [(anObj ~~ objectsToExclude) and:
			 [(anObj ~~ thisContext) and:
			 [(anObj ~~ thisContext sender) and:
			 [anObj ~~ thisContext sender sender]]]])
				 ifTrue: [results add: anObj]].
		anObj _ anObj nextObject].

	objectsToExclude do: [:obj | results removeAllSuchThat: [:el | el == obj]].
	^ results asArray
! !

!SystemDictionary methodsFor: 'retrieving'!
pointersToItem: index of: anArray
	"Find all occurrences in the system of pointers to the given element of the given array. This is useful for tracing up a pointer chain from an inspector on the results of a previous call of pointersTo:. To find out who points to the second element of the results, one would evaluate:

	Smalltalk pointersToItem: 2 of: self

in the inspector."

	^ self pointersTo: (anArray at: index) except: (Array with: anArray)! !

!SystemDictionary methodsFor: 'retrieving' stamp: 'jm 10/31/2002 10:43'!
unimplemented
	"Answer an Array of each message that is sent by an expression in a method but is not implemented by any object in the system."

	| all unimplemented entry |
	all _ IdentitySet new: Symbol instanceCount * 2.
	Cursor wait showWhile: 
		[self allBehaviorsDo: [:cl | cl selectorsDo: [:aSelector | all add: aSelector]]].

	unimplemented _ IdentityDictionary new.
	Cursor execute showWhile: [
		self allBehaviorsDo: [:cl |
			 cl selectorsDo: [:sel |
				(cl compiledMethodAt: sel) messages do: [:m |
					(all includes: m) ifFalse: [
						entry _ unimplemented at: m ifAbsent: [Array new].
						entry _ entry copyWith: (cl name, '>', sel).
						unimplemented at: m put: entry]]]]].

	"remove some clutter from the results:"
	#(DoItIn: primitiveFail uniformWindowColors macOptionKeyAllowed)
		do: [:sel | unimplemented removeKey: sel ifAbsent: []].

	^ unimplemented
! !


!SystemDictionary methodsFor: 'class names' stamp: 'di 3/26/2000 09:06'!
classNamed: className 
	"className is either a class name or a class name followed by ' class'.
	Answer the class or metaclass it names"

	| meta baseName baseClass |
	(className endsWith: ' class')
		ifTrue: [meta _ true.
				baseName _ className copyFrom: 1 to: className size - 6]
		ifFalse: [meta _ false.
				baseName _ className].
	baseClass _ Smalltalk at: baseName asSymbol ifAbsent: [^ nil].
	meta
		ifTrue: [^ baseClass class]
		ifFalse: [^ baseClass]! !

!SystemDictionary methodsFor: 'class names' stamp: 'jm 5/16/2003 09:58'!
classNames
	"Answer a SortedCollection of all class names."

	| names |
	cachedClassNames ifNil: [
		names _ OrderedCollection new: self size.
		self do: [:cl |
			((cl isKindOf: Class) and:
			 [(cl name beginsWith: 'AnObsolete') not])
				ifTrue: [names add: cl name]].
		cachedClassNames _ names asSortedCollection].
	^ cachedClassNames
! !

!SystemDictionary methodsFor: 'class names' stamp: 'di 2/16/2000 10:28'!
flushClassNameCache
	"Smalltalk flushClassNameCache"
	"Forse recomputation of the cached list of class names."

	cachedClassNames _ nil! !

!SystemDictionary methodsFor: 'class names' stamp: 'di 2/3/1999 22:21'!
removeClassFromSystem: aClass
	"Delete the class, aClass, from the system."

	aClass wantsChangeSetLogging ifTrue:
		[SystemChanges noteRemovalOf: aClass].
	aClass acceptsLoggingOfCompilation ifTrue:
		[Smalltalk logChange:  'Smalltalk removeClassNamed: #', aClass name].
	self removeClassFromSystemUnlogged: aClass
! !

!SystemDictionary methodsFor: 'class names' stamp: 'jm 1/1/2004 10:09'!
removeClassFromSystemUnlogged: aClass
	"Delete the class, aClass, from the system, but log the removal neither to the current change set nor to the changes log"

	SystemOrganization removeElement: aClass name.
	self removeKey: aClass name ifAbsent: [].
	self flushClassNameCache.
! !

!SystemDictionary methodsFor: 'class names' stamp: 'sw 9/5/97 18:30'!
removeClassNamed: aName
	"Invoked from fileouts:  if there is currently a class in the system named aName, then remove it.  If anything untoward happens, report it in the Transcript.  "

	| oldClass |
	(oldClass _ self at: aName asSymbol ifAbsent: [nil]) == nil
		ifTrue:
			[Transcript cr; show: 'Removal of class named ', aName, ' ignored because ', aName, ' does not exist.'.
			^ self].

	oldClass removeFromSystem! !

!SystemDictionary methodsFor: 'class names' stamp: 'jm 1/1/2004 10:56'!
renameClass: aClass as: newName 
	"Rename the class, aClass, to have the title newName."

	| oldref |
	SystemOrganization classify: newName under: aClass category.
	SystemOrganization removeElement: aClass name.
	SystemChanges renameClass: aClass as: newName.
	oldref _ self associationAt: aClass name.
	self removeKey: aClass name.
	oldref key: newName.
	self add: oldref.  "Old association preserves old refs"
	self flushClassNameCache.
! !

!SystemDictionary methodsFor: 'class names' stamp: 'sw 10/28/96'!
renameClassNamed: oldName as: newName
	"Invoked from fileouts:  if there is currently a class in the system named oldName, then rename it to newName.  If anything untoward happens, report it in the Transcript.  "

	| oldClass |
	(oldClass _ self at: oldName asSymbol ifAbsent: [nil]) == nil
		ifTrue:
			[Transcript cr; show: 'Class-rename for ', oldName, ' ignored because ', oldName, ' does not exist.'.
			^ self].

	oldClass rename: newName! !


!SystemDictionary methodsFor: 'shrinking' stamp: 'wod 11/3/1998 15:41'!
abandonSources    "Smalltalk abandonSources"
	"Replaces every method by a copy with the 4-byte source pointer 
	replaced by a string of all arg and temp names, followed by its length.
	These names can then be used to inform the decompiler.  See stats below"
	"wod 11/3/1998: zap the organization before rather than after condensing changes."
	 | oldCodeString argsAndTemps bTotal bCount oldMethods newMethods m |
	(self confirm:  '-- CAUTION --
If you have backed up your system and
are prepared to face the consequences of
abandoning source code files, hit Yes.
If you have any doubts, hit No,
to back out with no harm done.')
		==  true ifFalse: [^ self inform: 'Okay - no harm done'].
	Smalltalk forgetDoIts.
	oldMethods _ OrderedCollection new: CompiledMethod instanceCount.
	newMethods _ OrderedCollection new: CompiledMethod instanceCount.
	bTotal _ 0.  bCount _ 0.
	Smalltalk allBehaviorsDo: [: b | bTotal _ bTotal + 1].
'Saving temp names for better decompilation...'
	displayProgressAt: Sensor cursorPoint
	from: 0 to: bTotal
	during: [:bar |
	Smalltalk allBehaviorsDo:    "for test:  (Array with: Arc with: Arc class) do: "
		[:cl |  bar value: (bCount _ bCount + 1).
		cl selectors do:
			[:selector |
			m _ cl compiledMethodAt: selector.
			m fileIndex > 0 ifTrue:
			[oldCodeString _ cl sourceCodeAt: selector.
			argsAndTemps _ (cl compilerClass new
				parse: oldCodeString in: cl notifying: nil)
				tempNames.
			oldMethods addLast: m.
			newMethods addLast: (m copyWithTempNames: argsAndTemps)]]]].
	oldMethods asArray elementsExchangeIdentityWith: newMethods asArray.
	Smalltalk allBehaviorsDo: [: b | b zapOrganization].
	Smalltalk condenseChanges.
	Preferences disable: #warnIfNoSourcesFile.
"
In a system with 7780 methods, we got 83k of temp names, or around 100k with spaces between.  The order of letter frequency was eatrnoislcmdgpSub, with about 60k falling in the first 11.  This suggests that we could encode in 4 bits, with 0-11 beng most common chars, and 12-15 contributing 2 bits to the next nibble for 6 bits, enough to cover all alphaNumeric with upper and lower case.  If we get 3/4 in 4 bits and 1/4 in 8, then we get 5 bits per char, or about 38% savings (=38k in this case).

Summary: about 13 bytes of temp names per method, or 8 with simple compression, plus 1 for the size.  This would be 5 bytes more than the current 4-byte trailer.
"! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'jm 11/1/1998 08:31'!
abandonTempNames
	"Replaces every method by a copy with no source pointer or encoded temp names."
	"Smalltalk abandonTempNames"

	 | continue oldMethods newMethods n m |
	continue _ (self confirm:  '-- CAUTION --
If you have backed up your system and
are prepared to face the consequences of
abandoning all source code, hit Yes.
If you have any doubts, hit No,
to back out with no harm done.').
	continue ifFalse: [^ self inform: 'Okay - no harm done'].

	Smalltalk forgetDoIts; garbageCollect.
	oldMethods _ OrderedCollection new.
	newMethods _ OrderedCollection new.
	n _ 0.
	'Removing temp names to save space...'
		displayProgressAt: Sensor cursorPoint
		from: 0 to: CompiledMethod instanceCount
		during: [:bar |
			Smalltalk allBehaviorsDo: [:cl |
				cl selectors do: [:sel |
					bar value: (n _ n + 1).
					m _ cl compiledMethodAt: sel.
					oldMethods addLast: m.
					newMethods addLast: (m copyWithTrailerBytes: #(0))]]].
	oldMethods asArray elementsExchangeIdentityWith: newMethods asArray.
	Smalltalk closeSourceFiles.
	Preferences disable: #warnIfNoChangesFile.
	Preferences disable: #warnIfNoSourcesFile.
! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'jm 5/16/1998 10:18'!
discardMIDI
	"Discard support the MIDI score player and the underlying MIDI support."

	Smalltalk removeClassNamed: #ScorePlayerMorph.
	SystemOrganization removeCategoriesMatching: 'Music-Scores'.
! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'TPR 8/3/2000 23:36'!
discardMVC
   "Smalltalk discardMVC"

	| keepers |
	Smalltalk isMorphic ifFalse:
		[PopUpMenu notify: 'You must be in a Morphic project to discard MVC.'.
		^ self].
	"Check that there are no MVC Projects"
	(Project allInstances inject: true into: [:ok :proj | ok & proj isMorphic]) ifFalse:
		[(self confirm: 'Would you like a chance to remove your
MVC projects in an orderly manner?')
					ifTrue: [^ self].
		(self confirm: 'If you wish, I can remove all MVC projects,
make this project be the top project, and place
all orphaned sub-projects of MVC parents here.
Would you like be to do this
and proceed to discard all MVC classes?')
					ifTrue: [self zapMVCprojects]
					ifFalse: [^ self]].
	Smalltalk reclaimDependents.

	"Remove old Paragraph classes and View classes."
	(ChangeSet superclassOrder: Paragraph withAllSubclasses asArray) reverseDo: 
		[:c | c removeFromSystem].
	(ChangeSet superclassOrder: View withAllSubclasses asArray) reverseDo: 
		[:c | c removeFromSystem].

	"Get rid of ParagraphEditor's ScrollController dependence"
	#(markerDelta viewDelta scrollAmount scrollBar computeMarkerRegion) do:
			[:sel | ParagraphEditor removeSelector: sel].
	ParagraphEditor compile: 'updateMarker'.
	ParagraphEditor superclass: MouseMenuController .

	"Get rid of all Controller classes not needed by ParagraphEditor and ScreenController"
	keepers _ TextMorphEditor withAllSuperclasses copyWith: ScreenController.
	(ChangeSet superclassOrder: Controller withAllSubclasses asArray) reverseDo: 
		[:c | (keepers includes: c) ifFalse: [c removeFromSystem]].

	SystemOrganization removeCategoriesMatching: 'ST80-Paths'.
	SystemOrganization removeCategoriesMatching: 'ST80-Pluggable Views'.

	Smalltalk removeClassNamed: 'FormButtonCache'.
	Smalltalk removeClassNamed: 'WindowingTransformation'.
	Smalltalk removeClassNamed: 'ControlManager'.
	Smalltalk removeClassNamed: 'DisplayTextView'.

	ScheduledControllers _ nil.
	Undeclared removeUnreferencedKeys.
	SystemOrganization removeEmptyCategories.
	Symbol rehash.
! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'jm 7/3/2004 18:07'!
discardMorphic
   "Smalltalk discardMorphic"
	"Discard Morphic.
Updated for 2.8 TPR"

	| subs |
	"Check that we are in an MVC Project and that there are no Morphic Projects
		or WorldMorphViews."
	subs _ OrderedCollection new.
	Morph allSubclassesWithLevelDo: [:c :i | subs addFirst: c]
		startingLevel: 0.
	subs do: [:c | c removeFromSystem].
	Smalltalk removeClassNamed: #CornerRounder.
	Smalltalk removeKey: #BalloonEngineConstants ifAbsent: [].
	SystemOrganization removeCategoriesMatching: 'Balloon-*'.
	SystemOrganization removeCategoriesMatching: 'Morphic-*'.
	SystemOrganization removeSystemCategory: 'Graphics-Transformations'.
	SystemOrganization removeSystemCategory: 'ST80-Morphic'.
! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'jm 12/15/2005 13:57'!
discardOddsAndEnds
	"This method throws out lots of classes that are not frequently used."
	"Smalltalk discardOddsAndEnds"

	SystemOrganization removeSystemCategory: 'System-Serial Port'.
	SystemOrganization removeSystemCategory: 'ST80-Symbols'.
	SystemOrganization removeSystemCategory: 'Tools-File Contents Browser'.
	SystemOrganization removeSystemCategory: 'System-Compression'.
	SystemOrganization removeSystemCategory: 'Tools-Explorer'.
	SystemOrganization removeSystemCategory: 'System-Digital Signatures'.

	Smalltalk at: #FormView ifPresent:
		[:c | c compile: 'defaultControllerClass  ^ NoController'
			classified: 'controller access'].
	Smalltalk removeClassNamed: #FormEditorView.
	Smalltalk removeClassNamed: #FormEditor.
	SystemOrganization removeSystemCategory: 'ST80-Paths'.

	"bit editor (remove Form editor first):"
	Form removeSelector: #bitEdit.
	Form removeSelector: #bitEditAt:scale:.
	StrikeFont removeSelector: #edit:.
	Smalltalk removeClassNamed: #FormButtonCache.
	Smalltalk removeClassNamed: #FormMenuController.
	Smalltalk removeClassNamed: #FormMenuView.
	Smalltalk removeClassNamed: #BitEditor.

	"inspector for Dictionaries of Forms"
	Dictionary removeSelector: #inspectFormsWithLabel:.
	SystemDictionary removeSelector: #viewImageImports.
	ScreenController removeSelector: #viewImageImports.
	Smalltalk removeClassNamed: #FormHolderView.
	Smalltalk removeClassNamed: #FormInspectView.

	"experimental hand-drawn character recoginizer:"
	ParagraphEditor removeSelector: #recognizeCharacters.
	ParagraphEditor removeSelector: #recognizer:.
	ParagraphEditor removeSelector: #recognizeCharactersWhileMouseIn:.
	Smalltalk removeClassNamed: #CharRecog.

	"experimental updating object viewer:"
	Object removeSelector: #evaluate:wheneverChangeIn:.
	Smalltalk removeClassNamed: #ObjectViewer.
	Smalltalk removeClassNamed: #ObjectTracer.

	"miscellaneous classes:"
	Smalltalk removeClassNamed: #Array2D.
	Smalltalk removeClassNamed: #DriveACar.
	Smalltalk removeClassNamed: #EventRecorder.
	Smalltalk removeClassNamed: #FindTheLight.
	Smalltalk removeClassNamed: #PluggableTest.
	Smalltalk removeClassNamed: #SystemMonitor.
	Smalltalk removeClassNamed: #DocLibrary.

	Smalltalk removeClassNamed: #ProtocolBrowser.
	Smalltalk removeClassNamed: #ObjectExplorerWrapper.
	Smalltalk removeClassNamed: #HierarchyBrowser.
	Smalltalk removeClassNamed: #LinkedMessageSet.
	Smalltalk removeClassNamed: #ObjectExplorer.
	Smalltalk removeClassNamed: #PackageBrowser.
	Smalltalk removeClassNamed: #AbstractHierarchicalList.
	Smalltalk removeClassNamed: #ChangeList.
	Smalltalk removeClassNamed: #VersionsBrowser.
	Smalltalk removeClassNamed: #ChangeRecord.
	Smalltalk removeClassNamed: #SelectorBrowser.
	Smalltalk removeClassNamed: #HtmlFileStream.
	Smalltalk removeClassNamed: #CrLfFileStream.
	Smalltalk removeClassNamed: #FXGrafPort.
	Smalltalk removeClassNamed: #FXBlt.

	Smalltalk at: #SampledSound ifPresent: [:c |c initialize].
	#(Helvetica Palatino Courier ComicBold ComicPlain) do:
		[:k | TextConstants removeKey: k ifAbsent: []].

Preferences setButtonFontTo:	(StrikeFont fontName: #NewYork size: 12).

#(GZipConstants ZipConstants KlattResonatorIndices ) do:
	[:k | Smalltalk removeKey: k ifAbsent: []].
! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'jm 12/1/2005 17:05'!
discardSoundSynthesis
	"Discard the sound synthesis facilities, and the methods and classes that use it. This also discards MIDI."

	Smalltalk discardMIDI.
	SystemOrganization removeCategoriesMatching: 'Sound-Interface'.
	Smalltalk at: #GraphMorph ifPresent: [:graphMorph |
		#(playOnce readDataFromFile)
			do: [:sel | graphMorph removeSelector: sel]].
	SystemOrganization removeCategoriesMatching: 'Sound-Synthesis'.
	SystemOrganization removeCategoriesMatching: 'Sound-Scores'.
! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'TPR 8/3/2000 19:21'!
discardSpeech
	"Discard support for speech synthesis"

	SystemOrganization removeCategoriesMatching: 'Speech*'.
! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'di 1/12/2000 13:05'!
lastRemoval  "Smalltalk lastRemoval" 
	#(abandonSources browseAllSelect: printSpaceAnalysis browseObsoleteReferences  lastRemoval) do:
		[:sel | SystemDictionary removeSelector: sel].
	[self removeAllUnSentMessages > 0] whileTrue.
	Set withAllSubclassesDo:
		[:cls | cls allInstances do: [:s | s rehash]].
	Smalltalk allClassesDo: [:c | c zapOrganization].
	Smalltalk changes initialize.! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'jm 12/1/2005 17:03'!
majorShrink    "Smalltalk majorShrink; abandonSources; lastRemoval"
	"This method throws out lots of the system that is not needed for, eg, operation in a hand-held PC.  majorShrink produces a 999k image in Squeak 2.8"

	Smalltalk isMorphic ifTrue: [^ self error: 'You can only run majorShrink in MVC'].
	Project current isTopProject ifFalse: [^ self error: 'You can only run majorShrink in the top project'].
	(Smalltalk confirm: 'All sub-projects will be deleted from this image.
You should already have made a backup copy,
or you must save with a different name after shrinking.
Shall we proceed to discard most of the content in this image?')
		ifFalse: [^ PopUpMenu notify: 'No changes have been made.'].

	"Remove all projects but the current one.  - saves 522k"
	ProjectView allInstancesDo: [:pv | pv controller closeAndUnscheduleNoTerminate].
	Project current setParent: Project current.
	MorphWorldView allInstancesDo: [:pv | pv topView controller closeAndUnscheduleNoTerminate].

	Smalltalk discardSoundSynthesis.  "544k"
	Smalltalk discardOddsAndEnds.  "227k"
	SystemOrganization removeCategoriesMatching: 'Network-*'.
	Smalltalk discardMorphic.  "1372k"
	Symbol rehash.  "40k"
	"Above by itself saves about 4,238k"

	"Remove references to a few classes to be deleted, so that they won't leave obsolete versions around."
	FileList removeSelector: #fileIntoNewChangeSet.
	ChangeSet class compile: 'defaultName
		^ ''Changes'' ' classified: 'initialization'.
	ScreenController removeSelector: #openChangeManager.
	ScreenController removeSelector: #exitProject.
	ScreenController removeSelector: #openProject.
	ScreenController removeSelector: #viewImageImports.

	"Now delete various other classes.."
	SystemOrganization removeSystemCategory: 'Graphics-Files'.
	SystemOrganization removeSystemCategory: 'System-Object Storage'.
	Smalltalk removeClassNamed: #ProjectController.
	Smalltalk removeClassNamed: #ProjectView.
	"Smalltalk removeClassNamed: #Project."
	Smalltalk removeClassNamed: #Environment.
	Smalltalk removeClassNamed: #Component1.

	Smalltalk removeClassNamed: #FormSetFont.
	Smalltalk removeClassNamed: #FontSet.
	Smalltalk removeClassNamed: #InstructionPrinter.
	Smalltalk removeClassNamed: #ChangeSorter.
	Smalltalk removeClassNamed: #DualChangeSorter.
	Smalltalk removeClassNamed: #EmphasizedMenu.
	Smalltalk removeClassNamed: #MessageTally.

	StringHolder class removeSelector: #originalWorkspaceContents.
	CompiledMethod removeSelector: #symbolic.

	RemoteString removeSelector: #makeNewTextAttVersion.
	Utilities class removeSelector: #absorbUpdatesFromServer.
	Smalltalk removeClassNamed: #PenPointRecorder.
	Smalltalk removeClassNamed: #Path.
	Smalltalk removeClassNamed: #Base64MimeConverter.
	Smalltalk removeClassNamed: #RWBinaryOrTextStream.
	Smalltalk removeClassNamed: #AttributedTextStream.
	Smalltalk removeClassNamed: #WordNet.
	Smalltalk removeClassNamed: #SelectorBrowser.

	TextStyle allSubInstancesDo:
		[:ts | ts newFontArray: (ts fontArray copyFrom: 1 to: (2 min: ts fontArray size))].
	ListParagraph initialize.
	PopUpMenu initialize.
	StandardSystemView initialize.

	Smalltalk noChanges.
	ChangeSorter classPool at: #AllChangeSets 
		put: (OrderedCollection with: Smalltalk changes).
	SystemDictionary removeSelector: #majorShrink.

	[Smalltalk removeAllUnSentMessages > 0]
		whileTrue:
		[Smalltalk unusedClasses do: [:c | (Smalltalk at: c) removeFromSystem]].
	SystemOrganization removeEmptyCategories.
	Smalltalk allClassesDo: [:c | c zapOrganization].
	MethodDictionary allInstances do: [:d | d rehash].
	Smalltalk changes initialize.
	Symbol rehash.
! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'di 6/20/1998 12:33'!
printSpaceAnalysis	"Smalltalk printSpaceAnalysis"

	^ Smalltalk printSpaceAnalysis: 0 on: 'STspace.text'
! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'di 9/26/1999 11:32'!
printSpaceAnalysis: threshold on: fileName
	"Smalltalk printSpaceAnalysis: 1000 on: 'STspace.text0'"

	"If threshold > 0, then only those classes with more than that number
	of instances will be shown, and they will be sorted by total instance space.
	If threshold = 0, then all classes will appear, sorted by name."
	| f codeSpace instCount instSpace totalCodeSpace totalInstCount totalInstSpace eltSize n stats totalPercent percent |
	Smalltalk garbageCollect.
	totalCodeSpace _ totalInstCount _ totalInstSpace _ n _ 0.
	stats _ OrderedCollection new.
'Taking statistics...'
	displayProgressAt: Sensor cursorPoint
	from: 0 to: self classNames size
	during: [:bar |
	self allClassesDo:
		[:cl | codeSpace _ cl spaceUsed.
		bar value: (n _ n+1).
		Smalltalk garbageCollectMost.
		instCount _ cl instanceCount.
		instSpace _ (cl indexIfCompact > 0 ifTrue: [4] ifFalse: [8])*instCount. "Object headers"
		cl isVariable
			ifTrue: [eltSize _ cl isBytes ifTrue: [1] ifFalse: [4].
					cl allInstancesDo: [:x | instSpace _ instSpace + (x basicSize*eltSize)]]
			ifFalse: [instSpace _ instSpace + (cl instSize*instCount*4)].
		stats add: (Array with: cl name with: codeSpace) , (Array with: instCount with: instSpace).
		totalCodeSpace _ totalCodeSpace + codeSpace.
		totalInstCount _ totalInstCount + instCount.
		totalInstSpace _ totalInstSpace + instSpace]].
	totalPercent _ 0.0.

	f _ FileStream newFileNamed: fileName.
	f timeStamp.
	f nextPutAll: ('Class' padded: #right to: 30 with: $ );
			nextPutAll: ('code space' padded: #left to: 12 with: $ );
			nextPutAll: ('# instances' padded: #left to: 12 with: $ );
			nextPutAll: ('inst space' padded: #left to: 12 with: $ );
			nextPutAll: ('percent' padded: #left to: 8 with: $ ); cr.

	threshold > 0 ifTrue:
		["If inst count threshold > 0, then sort by space"
		stats _ (stats select: [:s | s third >= threshold or: [s fourth > (totalInstSpace // 500)]])
				asSortedCollection: [:s :s2 | s fourth > s2 fourth]].

	stats do:
		[:s | f nextPutAll: (s first padded: #right to: 30 with: $ );
			nextPutAll: (s second printString padded: #left to: 12 with: $ );
			nextPutAll: (s third printString padded: #left to: 12 with: $ );
			nextPutAll: (s fourth printString padded: #left to: 14 with: $ ).
		percent _ s fourth*100.0/totalInstSpace roundTo: 0.1.
		totalPercent _ totalPercent + percent.
		percent >= 0.1 ifTrue:
			[f nextPutAll: (percent printString padded: #left to: 8 with: $ )].
		f cr].

	f cr; nextPutAll: ('Total' padded: #right to: 30 with: $ );
		nextPutAll: (totalCodeSpace printString padded: #left to: 12 with: $ );
		nextPutAll: (totalInstCount printString padded: #left to: 12 with: $ );
		nextPutAll: (totalInstSpace printString padded: #left to: 14 with: $ );
		nextPutAll: ((totalPercent roundTo: 0.1) printString padded: #left to: 8 with: $ ).
	f close! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'di 6/20/1998 12:37'!
printSpaceDifferenceFrom: fileName1 to: fileName2
	"For differential results, run printSpaceAnalysis twice with different fileNames,
	then run this method...
		Smalltalk printSpaceAnalysis: 0 on: 'STspace.text1'.
			--- do something that uses space here ---
		Smalltalk printSpaceAnalysis: 0 on: 'STspace.text2'.
		Smalltalk printSpaceDifferenceFrom: 'STspace.text1' to: 'STspace.text2'
"
	| f coll1 coll2 item |
	f _ FileStream oldFileNamed: fileName1.
	coll1 _ OrderedCollection new.
	[f atEnd] whileFalse: [coll1 add: (f upTo: Character cr)].
	f close.
	f _ FileStream oldFileNamed: fileName2.
	coll2 _ OrderedCollection new.
	[f atEnd] whileFalse:
		[item _ (f upTo: Character cr).
		((coll1 includes: item) and: [(item endsWith: 'percent') not])
			ifTrue: [coll1 remove: item]
			ifFalse: [coll2 add: item]].
	f close.
	(StringHolder new contents: (String streamContents: 
			[:s | 
			s nextPutAll: fileName1; cr.
			coll1 do: [:x | s nextPutAll: x; cr].
			s cr; cr.
			s nextPutAll: fileName2; cr.
			coll2 do: [:x | s nextPutAll: x; cr]]))
		openLabel: 'Differential Space Analysis'.
! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'di 8/16/2000 14:20'!
removeAllUnSentMessages   "Smalltalk removeAllUnSentMessages"
	"[Smalltalk unusedClasses do: [:c | (Smalltalk at: c) removeFromSystem].
		Smalltalk removeAllUnSentMessages > 0] whileTrue." 

	"Remove all implementations of unsent messages."
	| sels n |
	sels _ self allUnSentMessages.

	"The following should be preserved for doIts, etc"
	#(browseAllSelect: printSpaceAnalysis lastRemoval
		scrollBarValue: scrollBarMenuButtonPressed: 
		withSelectionFrom:  to: removeClassNamed:
		dragon: hilberts: mandala: web test3 factorial tinyBenchmarks benchFib
		newDepth: restoreAfter: forgetDoIts zapAllMethods obsoleteClasses
		removeAllUnSentMessages abandonSources removeUnreferencedKeys
		reclaimDependents zapOrganization condenseChanges browseObsoleteReferences
		subclass:instanceVariableNames:classVariableNames:poolDictionaries:category:
		methodsFor:stamp: methodsFor:stamp:prior: instanceVariableNames:
		startTimerInterruptWatcher unusedClasses) do:
		[:sel | sels remove: sel ifAbsent: []].
	"The following may be sent by perform: in dispatchOnChar..."
	(ParagraphEditor classPool at: #CmdActions) asSet do:
		[:sel | sels remove: sel ifAbsent: []].
	(ParagraphEditor classPool at: #ShiftCmdActions) asSet do:
		[:sel | sels remove: sel ifAbsent: []].
	sels size = 0 ifTrue: [^ 0].

	n _ 0. Smalltalk allBehaviorsDo: [:x | n _ n+1].
	'Removing ', sels size printString , ' messages . . .'
		displayProgressAt: Sensor cursorPoint
		from: 0 to: n
		during:
		[:bar |
		n _ 0.
		self allBehaviorsDo:
			[:class | bar value: (n _ n+1).
			sels do:
				[:sel | class removeSelectorSimply: sel]]].
	^ sels size! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'di 4/20/1999 12:24'!
unusedClasses
	"Warning: Slow!! Enumerates all classes in the system and returns a list of those that are apparently unused. A class is considered in use if it (a) has subclasses (b) has instances or (c) is referred to by some method. Obsolete classes are not included in this list."
	"Smalltalk unusedClasses"

	| unused c n |
	unused _ SortedCollection new.

'Scanning for unused classes...'
	displayProgressAt: Sensor cursorPoint
	from: 0 to: Metaclass instanceCount
	during: [:bar | n _ 0.

	Metaclass allInstancesDo: [:meta | bar value: (n _ n+1).
		c _ meta soleInstance.
		((c ~~ nil) and:
		 [('AnOb*' match: c name asString) not]) ifTrue: [
			((c subclasses size = 0) and:
			 [(c inheritsFrom: FileDirectory) not & (c instanceCount = 0) and:
			 [(Smalltalk includesKey: c name) and: [(Smalltalk allCallsOn: (Smalltalk associationAt: c name)) size = 0]]])
				ifTrue: [unused add: c name]]]].

	^ unused asArray
! !

!SystemDictionary methodsFor: 'shrinking' stamp: 'di 9/26/1999 21:44'!
zapMVCprojects   "Smalltalk zapMVCprojects"

	| window |
	Smalltalk garbageCollect.  "So allInstances is precise"
	Project allSubInstancesDo:
		[:proj |
		proj isTopProject
		ifTrue: [proj isMorphic ifFalse:
					["Root project is MVC -- we must become the root"
					Project current setParent: Project current]]
		ifFalse: [proj parent isMorphic
				ifFalse: [proj isMorphic ifTrue:
							["Remove Morphic projects from MVC views"
							"... and add them back here."
							window _ (SystemWindow labelled: proj name) model: proj.
							window addMorph: (ProjectViewMorph on: proj)
									frame: (0@0 corner: 1.0@1.0).
							window openInWorld.
							proj setParent: Project current]].
				proj isMorphic
					ifFalse: ["Remove MVC projects from Morphic views"
							Project allInstancesDo: [:p | p deletingProject: proj].
							ProjectViewMorph allInstancesDo: [:p | p deletingProject: proj]]]
		]! !


!SystemDictionary methodsFor: 'memory space'!
bytesLeft
	"Answer the number of bytes of space available. Does a full garbage collection."

	^ self garbageCollect
! !

!SystemDictionary methodsFor: 'memory space'!
createStackOverflow
	"For testing the low space handler..."
	"Smalltalk installLowSpaceWatcher; createStackOverflow"

	self createStackOverflow.  "infinite recursion"! !

!SystemDictionary methodsFor: 'memory space'!
garbageCollect
	"Primitive. Reclaims all garbage and answers the number of bytes of available space."

	<primitive: 130>
	^ self primBytesLeft! !

!SystemDictionary methodsFor: 'memory space'!
garbageCollectMost
	"Primitive. Reclaims recently created garbage (which is usually most of it) fairly quickly and answers the number of bytes of available space."

	<primitive: 131>
	^ self primBytesLeft! !

!SystemDictionary methodsFor: 'memory space'!
installLowSpaceWatcher
	"Start a process to watch for low-space conditions."
	"Smalltalk installLowSpaceWatcher"

	self primSignalAtBytesLeft: 0.  "disable low-space interrupts"
	LowSpaceProcess == nil ifFalse: [LowSpaceProcess terminate].
	LowSpaceProcess _ [self lowSpaceWatcher] newProcess.
	LowSpaceProcess priority: Processor lowIOPriority.
	LowSpaceProcess resume.

! !

!SystemDictionary methodsFor: 'memory space' stamp: 'jm 10/14/2002 18:53'!
lowSpaceThreshold 
	"Return the low space threshold. When the amount of free memory (after garbage collection) falls below this limit, the system is in serious danger of completely exhausting memory and crashing. This limit should be made high enough to allow the user open a debugger to diagnose a problem or to save the image."

	^ 250000
! !

!SystemDictionary methodsFor: 'memory space' stamp: 'jm 10/4/2002 11:00'!
lowSpaceWatcher
	"Wait until the low space semaphore is signalled, then take appropriate actions."

	self garbageCollectMost <= self lowSpaceThreshold ifTrue: [
		self garbageCollect <= self lowSpaceThreshold ifTrue: [
			"free space must be above threshold before starting low space watcher"
			^ self beep]].

	LowSpaceSemaphore _ Semaphore new.
	self primLowSpaceSemaphore: LowSpaceSemaphore.
	self primSignalAtBytesLeft: self lowSpaceThreshold.  "enable low space interrupts"

	LowSpaceSemaphore wait.  "wait for a low space condition..."

	self primSignalAtBytesLeft: 0.  "disable low space interrupts"
	self primLowSpaceSemaphore: nil.
	LowSpaceProcess _ nil.
	"Note: user is now unprotected until the low space watcher is re-installed"

	Smalltalk isMorphic
		ifTrue: [Project current interruptName: 'Space is low']
		ifFalse: [ScheduledControllers interruptName: 'Space is low'].
! !

!SystemDictionary methodsFor: 'memory space'!
okayToProceedEvenIfSpaceIsLow
	"Return true if either there is enough memory to do so safely or if the user gives permission after being given fair warning."

	self garbageCollectMost > self lowSpaceThreshold ifTrue: [^ true].  "quick"
	self garbageCollect > self lowSpaceThreshold ifTrue: [^ true].  "work harder"

	^ self confirm:
'WARNING: There is not enough space to start the low space watcher.
If you proceed, you will not be warned again, and the system may
run out of memory and crash. If you do proceed, you can start the
low space notifier when more space becomes available simply by
opening and then closing a debugger (e.g., by hitting Cmd-period.)
Do you want to proceed?'
! !

!SystemDictionary methodsFor: 'memory space'!
primBytesLeft
	"Primitive. Answer the number of bytes available for new object data.
	Not accurate unless preceded by
		Smalltalk garbageCollectMost (for reasonable accuracy), or
		Smalltalk garbageCollect (for real accuracy).
	See Object documentation whatIsAPrimitive."

	<primitive: 112>
	^ 0! !

!SystemDictionary methodsFor: 'memory space'!
primLowSpaceSemaphore: aSemaphore
	"Primitive. Register the given Semaphore to be signalled when the
	number of free bytes drops below some threshold. Disable low-space
	interrupts if the argument is nil."

	<primitive: 124>
	self primitiveFailed! !

!SystemDictionary methodsFor: 'memory space'!
primSignalAtBytesLeft: numBytes
	"Tell the interpreter the low-space threshold in bytes. When the free
	space falls below this threshold, the interpreter will signal the low-space
	semaphore, if one has been registered.  Disable low-space interrupts if the
	argument is zero.  Fail if numBytes is not an Integer."

	<primitive: 125>
	self primitiveFailed! !

!SystemDictionary methodsFor: 'memory space'!
signalLowSpace
	"Signal the low-space semaphore to alert the user that space is running low."

	LowSpaceSemaphore signal.! !

!SystemDictionary methodsFor: 'memory space'!
useUpMemory
	"For testing the low space handler..."
	"Smalltalk installLowSpaceWatcher; useUpMemory"

	| lst |
	lst _ nil.
	[true] whileTrue: [
		lst _ Link new nextLink: lst; yourself.
	].! !

!SystemDictionary methodsFor: 'memory space' stamp: 'di 8/18/2000 21:15'!
useUpMemoryWithArrays 
	"For testing the low space handler..."
	"Smalltalk installLowSpaceWatcher; useUpMemoryWithArrays"

	| b |  "First use up most of memory."
	b _ String new: self bytesLeft - self lowSpaceThreshold - 100000.
	b _ b.  "Avoid unused value warning"
	(1 to: 10000) collect: [:i | Array new: 10000]! !

!SystemDictionary methodsFor: 'memory space' stamp: 'di 8/18/2000 16:49'!
useUpMemoryWithContexts 
	"For testing the low space handler..."
	"Smalltalk installLowSpaceWatcher; useUpMemoryWithContexts"

	self useUpMemoryWithContexts! !

!SystemDictionary methodsFor: 'memory space' stamp: 'di 8/18/2000 16:50'!
useUpMemoryWithTinyObjects 
	"For testing the low space handler..."
	"Smalltalk installLowSpaceWatcher; useUpMemoryWithTinyObjects"

	| b |  "First use up most of memory."
	b _ String new: self bytesLeft - self lowSpaceThreshold - 100000.
	b _ b.  "Avoid unused value warning"
	(1 to: 10000) collect: [:i | BitBlt new]! !


!SystemDictionary methodsFor: 'special objects' stamp: 'JMM 6/6/2000 20:36'!
clearExternalObjects
	"Clear the array of objects that have been registered for use in non-Smalltalk code."
	"Smalltalk clearExternalObjects"

	ExternalSemaphoreTable clearExternalObjects
! !

!SystemDictionary methodsFor: 'special objects'!
compactClassesArray  "Smalltalk compactClassesArray"
	"Return the array of 31 classes whose instances may be
	represented compactly"
	^ Smalltalk specialObjectsArray at: 29! !

!SystemDictionary methodsFor: 'special objects' stamp: 'JMM 6/6/2000 21:01'!
externalObjects
	"Return an array of objects that have been registered for use in non-Smalltalk code. Smalltalk objects should be referrenced by external code only via indirection through this array, thus allowing the objects to move during compaction. This array can be cleared when the VM re-starts, since variables in external code do not survive snapshots. Note that external code should not attempt to access a Smalltalk object, even via this mechanism, while garbage collection is in progress."
	"Smalltalk externalObjects"

	^ ExternalSemaphoreTable externalObjects
! !

!SystemDictionary methodsFor: 'special objects'!
hasSpecialSelector: aLiteral ifTrueSetByte: aBlock

	1 to: self specialSelectorSize do:
		[:index | 
		(self specialSelectorAt: index) == aLiteral
			ifTrue: [aBlock value: index + 16rAF. ^true]].
	^false! !

!SystemDictionary methodsFor: 'special objects' stamp: 'jm 10/7/2002 05:33'!
recreateSpecialObjectsArray    "Smalltalk recreateSpecialObjectsArray"
	"The Special Objects Array is an array of object pointers used by the Smalltalk virtual machine.  Its contents are critical and unchecked, so don't even think of playing here unless you know what you are doing."

	| newArray |
	newArray _ Array new: 48.
	"Nil false and true get used throughout the interpreter"
	newArray at: 1 put: nil.
	newArray at: 2 put: false.
	newArray at: 3 put: true.
	"This association holds the active process (a ProcessScheduler)"
	newArray at: 4 put: (Smalltalk associationAt: #Processor).
	"Numerous classes below used for type checking and instantiation"
	newArray at: 5 put: Bitmap.
	newArray at: 6 put: SmallInteger.
	newArray at: 7 put: String.
	newArray at: 8 put: Array.
	newArray at: 9 put: Smalltalk. 
	newArray at: 10 put: Float.
	newArray at: 11 put: MethodContext.
	newArray at: 12 put: BlockContext.
	newArray at: 13 put: Point.
	newArray at: 14 put: LargePositiveInteger.
	newArray at: 15 put: Display.
	newArray at: 16 put: Message.
	newArray at: 17 put: CompiledMethod.
	newArray at: 18 put: (self specialObjectsArray at: 18)  "(low space Semaphore)".
	newArray at: 19 put: Semaphore.
	newArray at: 20 put: Character.
	newArray at: 21 put: #doesNotUnderstand:.
	newArray at: 22 put: #cannotReturn:.
	newArray at: 23 put: nil.  "*unused*"
	"An array of the 32 selectors that are compiled as special bytecodes,
	paired alternately with the number of arguments each takes."
	newArray at: 24 put: #(+ 1 - 1 < 1 > 1 <= 1 >= 1 = 1 ~= 1 * 1 / 1 \\ 1 @ 1 bitShift: 1 // 1 bitAnd: 1 bitOr: 1 at: 1 at:put: 2 size 0 next 0 nextPut: 1 atEnd 0 == 1 class 0 blockCopy: 1 value 0 value: 1 do: 1 new 0 new: 1 x 0 y 0 ).
	"An array of the 255 Characters in ascii order."
	newArray at: 25 put: ((0 to: 255) collect: [:ascii | Character value: ascii]).
	newArray at: 26 put: #mustBeBoolean.
	newArray at: 27 put: ByteArray.
	newArray at: 28 put: Process.
	"An array of up to 31 classes whose instances will have compact headers"
	newArray at: 29 put: self compactClassesArray.
	newArray at: 30 put: (self specialObjectsArray at: 30)   "(delay Semaphore)".
	newArray at: 31 put: (self specialObjectsArray at: 31)   "(user input Semaphore)".

	"Prototype instances that can be copied for fast initialization"
	newArray at: 32 put: (Float new: 2).
	newArray at: 33 put: (LargePositiveInteger new: 4).
	newArray at: 34 put: Point new.
	newArray at: 35 put: #cannotInterpret:.
	"Note: This must be fixed once we start using context prototypes"
	newArray at: 36 put: (self specialObjectsArray at: 36). 
						"(MethodContext new: CompiledMethod fullFrameSize)."
	newArray at: 37 put: nil.
	newArray at: 38 put: (self specialObjectsArray at: 38). 
						"(BlockContext new: CompiledMethod fullFrameSize)."

	newArray at: 39 put: Array new.  "array of objects referred to by external code"

	newArray at: 40 put: nil.  "was PseudoContext"
	newArray at: 41 put: nil.  "was TranslatedMethod"

	"finalization Semaphore"
	newArray at: 42 put: ((self specialObjectsArray at: 42) ifNil:[Semaphore new]).

	newArray at: 43 put: LargeNegativeInteger.

	"External objects for callout.
	Note: Written so that one can actually completely remove the FFI."
	newArray at: 44 put: (Smalltalk at: #ExternalAddress ifAbsent:[nil]).
	newArray at: 45 put: (Smalltalk at: #ExternalStructure ifAbsent:[nil]).
	newArray at: 46 put: (Smalltalk at: #ExternalData ifAbsent:[nil]).
	newArray at: 47 put: (Smalltalk at: #ExternalFunction ifAbsent:[nil]).
	newArray at: 48 put: (Smalltalk at: #ExternalLibrary ifAbsent:[nil]).

	"Now replace the interpreter's reference in one atomic operation"
	self specialObjectsArray become: newArray! !

!SystemDictionary methodsFor: 'special objects' stamp: 'JMM 6/6/2000 20:39'!
registerExternalObject: anObject
	"Register the given object in the external objects array and return its index. If it is already there, just return its index."

	^ExternalSemaphoreTable registerExternalObject: anObject! !

!SystemDictionary methodsFor: 'special objects'!
specialNargsAt: anInteger 
	"Answer the number of arguments for the special selector at: anInteger."

	^ (self specialObjectsArray at: 24) at: anInteger * 2! !

!SystemDictionary methodsFor: 'special objects'!
specialObjectsArray  "Smalltalk specialObjectsArray at: 1"
	<primitive: 129>
	^ self primitiveFailed! !

!SystemDictionary methodsFor: 'special objects'!
specialSelectorAt: anInteger 
	"Answer the special message selector from the interleaved specialSelectors array."

	^ (self specialObjectsArray at: 24) at: anInteger * 2 - 1! !

!SystemDictionary methodsFor: 'special objects'!
specialSelectorSize
	"Answer the number of special selectors in the system."

	^ (self specialObjectsArray at: 24) size // 2! !

!SystemDictionary methodsFor: 'special objects' stamp: 'JMM 6/6/2000 20:40'!
unregisterExternalObject: anObject
	"Unregister the given object in the external objects array. Do nothing if it isn't registered."

	ExternalSemaphoreTable unregisterExternalObject: anObject! !


!SystemDictionary methodsFor: 'image, changes name' stamp: 'jm 3/27/98 08:20'!
changesName
	"Answer the local name for the changes file corresponding to the image file name."
	"Smalltalk changesName"

	| imName |
	imName _ FileDirectory baseNameFor:
		(FileDirectory localNameFor: self imageName).
	^ imName, FileDirectory dot, 'changes'
! !

!SystemDictionary methodsFor: 'image, changes name'!
imageName
	"Answer the full path name for the current image."
	"Smalltalk imageName"

	<primitive: 121>
	self primitiveFailed! !

!SystemDictionary methodsFor: 'image, changes name'!
imageName: newName
	"Set the the full path name for the current image.  All further snapshots will use this."

	<primitive: 121>
	^ self primitiveFailed! !

!SystemDictionary methodsFor: 'image, changes name' stamp: 'di 5/22/1998 15:51'!
sourcesName
	"Answer the full path to the version-stable source code"
	^ self vmPath , 'SqueakV2' , FileDirectory dot , 'sources'! !

!SystemDictionary methodsFor: 'image, changes name'!
vmPath
	"Answer the path for the directory containing the Smalltalk virtual machine. Return the empty string if this primitive is not implemented."
	"Smalltalk vmPath"

	<primitive: 142>
	^ ''! !


!SystemDictionary methodsFor: 'sources, change log' stamp: 'jm 5/31/2003 17:08'!
aboutThisSystem 
	"Identify software version"

	^ self inform: self systemInformationString
! !

!SystemDictionary methodsFor: 'sources, change log' stamp: 'di 2/11/2000 17:23'!
assureStartupStampLogged
	"If there is a startup stamp not yet actually logged to disk, do it now."
	| changesFile |
	StartupStamp ifNil: [^ self].
	(SourceFiles isNil or: [(changesFile _ SourceFiles at: 2) == nil]) ifTrue: [^ self].

	changesFile setToEnd; cr; cr.
	changesFile nextChunkPut: StartupStamp asString; cr.
	StartupStamp _ nil.
	self forceChangesToDisk.! !

!SystemDictionary methodsFor: 'sources, change log'!
changes
	"Answer the current system ChangeSet."

	^SystemChanges! !

!SystemDictionary methodsFor: 'sources, change log'!
closeSourceFiles
	"Shut down the source files if appropriate.  1/29/96 sw: changed so that the closing and nilification only take place if the entry was a FileStream, thus allowing stringified sources to remain in the saved image file"

	1 to: 2 do: [:i |
		((SourceFiles at: i) isKindOf: FileStream)
			ifTrue:
				[(SourceFiles at: i) close.
				SourceFiles at: i put: nil]]! !

!SystemDictionary methodsFor: 'sources, change log' stamp: 'sw 2/15/1999 16:32'!
currentChangeSetString
	"Smalltalk currentChangeSetString"
	^ 'Current Change Set: ', self changes name! !

!SystemDictionary methodsFor: 'sources, change log' stamp: 'JMM 8/10/2000 15:15'!
externalizeSources   
	"Write the sources and changes streams onto external files."
 	"Smalltalk externalizeSources"

	| sourcesName changesName aFile |
	sourcesName _ self sourcesName.
	(FileDirectory default fileExists: sourcesName)
		ifTrue: [^ self inform:
'Sorry, you must first move or remove the
file named ', sourcesName].
	changesName _ self changesName.
	(FileDirectory default fileExists: changesName)
		ifTrue: [^ self inform:
'Sorry, you must first move or remove the
file named ', changesName].

	aFile _  FileStream newFileNamed: sourcesName.
	aFile nextPutAll: SourceFiles first originalContents.
	aFile close.
	"On Mac, set the file type and creator (noop on other platforms)"
	FileDirectory default
		setMacFileNamed: sourcesName
		type: 'STch'
		creator: 'FAST'.
	SourceFiles at: 1 put: (FileStream readOnlyFileNamed: sourcesName).

	aFile _ FileStream newFileNamed: self changesName.
	aFile nextPutAll: SourceFiles last contents.
	aFile close.
	"On Mac, set the file type and creator (noop on other platforms)"
	FileDirectory default
		setMacFileNamed: self changesName
		type: 'STch'
		creator: 'FAST'.
	SourceFiles at: 2 put: (FileStream oldFileNamed: changesName).

	self inform: 'Sources successfully externalized'.
! !

!SystemDictionary methodsFor: 'sources, change log'!
forceChangesToDisk
	"Ensure that the changes file has been fully written to disk by closing and re-opening it. This makes the system more robust in the face of a power failure or hard-reboot."

	| changesFile |
	changesFile _ SourceFiles at: 2.
	(changesFile isKindOf: FileStream) ifTrue: [
		changesFile flush.
		changesFile close.
		changesFile open: changesFile name forWrite: true.
		changesFile setToEnd.
	].
! !

!SystemDictionary methodsFor: 'sources, change log' stamp: 'jm 12/5/97 15:30'!
internalizeChangeLog    
		"Smalltalk internalizeChangeLog"
	"Bring the changes file into a memory-resident filestream, for faster access and freedom from external file system.  1/31/96 sw"

	| reply aName aFile |
	reply _ self confirm:  'CAUTION -- do not undertake this lightly!!
If you have backed up your system and
are prepared to face the consequences of
the requested internalization of sources,
hit Yes.  If you have any doubts, hit No
to back out with no harm done.'.

	(reply ==  true) ifFalse:
		[^ self inform: 'Okay - abandoned'].

	aName _ self changesName.
	(aFile _ SourceFiles last) == nil ifTrue:
		[(FileDirectory default fileExists: aName)
			ifFalse: [^ self halt: 'Cannot locate ', aName, ' so cannot proceed.'].
		aFile _ FileStream readOnlyFileNamed: aName].
	SourceFiles at: 2 put: (ReadWriteStream with: aFile contentsOfEntireFile).

	self inform: 'Okay, changes file internalized'! !

!SystemDictionary methodsFor: 'sources, change log' stamp: 'jm 12/5/97 15:30'!
internalizeSources    
		"Smalltalk internalizeSources"
	"Bring the sources and changes files into memory-resident filestreams, for faster access and freedom from file-system interface.  1/29/96 sw"

	| reply aName aFile |
	reply _ self confirm:  'CAUTION -- do not undertake this lightly!!
If you have backed up your system and
are prepared to face the consequences of
the requested internalization of sources,
hit Yes.  If you have any doubts, hit No
to back out with no harm done.'.

	(reply ==  true) ifFalse:
		[^ self inform: 'Okay - abandoned'].

	aName _ self sourcesName.
	(aFile _ SourceFiles first) == nil ifTrue:
		[(FileDirectory default fileExists: aName)
			ifFalse: [^ self halt: 'Cannot locate ', aName, ' so cannot proceed.'].
		aFile _ FileStream readOnlyFileNamed: aName].
	SourceFiles at: 1 put: (ReadWriteStream with: aFile contentsOfEntireFile).

	aName _ self changesName.
	(aFile _ SourceFiles last) == nil ifTrue:
		[(FileDirectory default fileExists: aName)
			ifFalse: [^ self halt: 'Cannot locate ', aName, ' so cannot proceed.'].
		aFile _ FileStream readOnlyFileNamed: aName].
	SourceFiles at: 2 put: (ReadWriteStream with: aFile contentsOfEntireFile).

	self inform: 'Okay, sources internalized'! !

!SystemDictionary methodsFor: 'sources, change log' stamp: 'jm 12/3/2003 11:12'!
isBigEndian
	"Answer true if the underlying processor is 'big-endian.' A big-endian processor stores the most significant byte of a 32-bit integer first when accessing memory as a sequence of bytes. A little-endian processor stores the least-significant byte first."
	"Details: Use BitBlt to copy the integer '1' from a Bitmap (i.e., a 32-bit word array) into a ByteArray. On a big-endian machine, the 1 will be in the first byte of the ByteArray. On a little-endian machine, it will be in the last byte."
	"Smalltalk isBigEndian"

	| src dstBytes dst |
	src _ Form extent: 4@1 depth: 8.
	src bits at: 1 put: 1.
	dstBytes _ ByteArray withAll: #(0 0 0 0).
	dst _ Form new hackBits: dstBytes.
	(BitBlt toForm: dst) copyForm: src to: 0@0 rule: Form over.
	^ dstBytes last = 1
! !

!SystemDictionary methodsFor: 'sources, change log' stamp: 'sma 2/12/2000 12:42'!
lastUpdateString
	"Smalltalk lastUpdateString"
	| aNumber |
	aNumber _ (Smalltalk
		at: #ChangeSorter
		ifAbsent: [^ 'Update # unknown']) highestNumberedChangeSet.
	^ (aNumber notNil and: [aNumber > 0])
		ifTrue: ['latest update: #' , aNumber printString]
		ifFalse: ['No updates present.']! !

!SystemDictionary methodsFor: 'sources, change log' stamp: 'sw 2/12/1999 17:18'!
logChange: aStringOrText 
	"Write the argument, aString, onto the changes file."
	| aString changesFile |
	(SourceFiles isNil or: [(SourceFiles at: 2) == nil]) ifTrue: [^ self].
	self assureStartupStampLogged.

	aStringOrText isText
		ifTrue: [aString _ aStringOrText string]
		ifFalse: [aString _ aStringOrText].
	(aString isMemberOf: String)
		ifFalse: [self error: 'can''t log this change'].
	(aString findFirst: [:char | char isSeparator not]) = 0
		ifTrue: [^ self].  "null doits confuse replay"
	(changesFile _ SourceFiles at: 2) setToEnd; cr; cr.
	changesFile nextChunkPut: aString.
		"If want style changes in DoIt, use nextChunkPutWithStyle:, and allow Texts to get here"
	self forceChangesToDisk.! !

!SystemDictionary methodsFor: 'sources, change log' stamp: 'jm 10/7/2002 06:34'!
newChanges: aChangeSet 
	"Set the system ChangeSet to be the argument, aChangeSet. Tell the current project that aChangeSet is now its change set. When called from Project enter:, the setChangeSet: call is redundant but harmless; when called from code that changes the current change set from within a project, it's vital"

	SystemChanges _ aChangeSet.

	"following code still works after removal of Projects:"
	Smalltalk at: #Project ifPresent:
		[:projClass | projClass current setChangeSet: aChangeSet].
! !

!SystemDictionary methodsFor: 'sources, change log'!
noChanges 
	"Initialize the system ChangeSet."

	SystemChanges initialize! !

!SystemDictionary methodsFor: 'sources, change log' stamp: 'di 4/28/2000 13:01'!
openSourceFiles
	self imageName = LastImageName ifFalse:
		["Reset the author initials to blank when the image gets moved"
		LastImageName _ self imageName.
		Utilities setAuthorInitials: ''].
	FileDirectory
		openSources: self sourcesName
		andChanges: self changesName
		forImage: LastImageName.
	StandardSourceFileArray install! !

!SystemDictionary methodsFor: 'sources, change log' stamp: 'jm 5/31/2003 17:08'!
systemInformationString
	"Identify the Squeak image version."
	"Smalltalk systemInformationString"

	^ self version, String cr, self currentChangeSetString
! !

!SystemDictionary methodsFor: 'sources, change log' stamp: 'sw 9/27/1999 10:41'!
timeStamp: aStream 
	"Writes system version and current time on stream aStream."

	| dateTime |
	dateTime _ Time dateAndTimeNow.
	aStream nextPutAll: 'From ', Smalltalk version, ' [', Smalltalk lastUpdateString, '] on ', (dateTime at: 1) printString,
						' at ', (dateTime at: 2) printString! !

!SystemDictionary methodsFor: 'sources, change log' stamp: 'jm 5/31/2003 17:07'!
version
	"Answer the version of this release."
	"VersionString _ 'MIT Squeak 0.9.4 (June 1, 2003)'"

	^ VersionString
! !


!SystemDictionary methodsFor: 'snapshot and quit' stamp: 'sma 4/30/2000 09:17'!
isMorphic
	"Answer true if the user interface is running in Morphic rathern than 
	MVC.  By convention the gloabl variable World is set to nil when MVC is 
	running.  ScheduledControllers could be set to nil when Morphic is 
	running, but this symmetry is not yet in effect."

	^ World ~~ nil! !

!SystemDictionary methodsFor: 'snapshot and quit'!
lastQuitLogPosition
	^ LastQuitLogPosition! !

!SystemDictionary methodsFor: 'snapshot and quit' stamp: 'jm 10/29/2008 13:21'!
processShutDownList
	"Send #shutDown to each class that needs to do something when starting up."

	#(
		SoundPlayer
		Delay
		FileDirectory
		Color
		StrikeFont
		ControlManager
		Form
		DisplayScreen
		ScratchTranslator
	) do: [:cName |
		Smalltalk at: cName ifPresent: [:cl | cl shutDown]].
! !

!SystemDictionary methodsFor: 'snapshot and quit' stamp: 'jm 6/26/2008 12:14'!
processStartUpList
	"Send #startUp to each class that needs to do something when starting up."

	#(
		DisplayScreen
		Cursor
		InputSensor
		ProcessorScheduler
		Delay
		FileDirectory
		CrLfFileStream
		ControlManager
		PasteUpMorph
		SoundBuffer
		ScratchTranslator
	) do: [:cName |
		Smalltalk at: cName ifPresent: [:cl | cl startUp]].
! !

!SystemDictionary methodsFor: 'snapshot and quit'!
quitPrimitive
	"Primitive. Exit to another operating system on the host machine, if one
	exists. All state changes in the object space since the last snapshot are lost.
	Essential. See Object documentation whatIsAPrimitive."

	<primitive: 113>
	self primitiveFailed! !

!SystemDictionary methodsFor: 'snapshot and quit' stamp: 'jm 5/31/2003 16:09'!
readDocumentFile
	"Hook for starting up an application by double-clicking."

	StartupStamp _ '----STARTUP----', Time dateAndTimeNow printString, ' as ', Smalltalk imageName.
! !

!SystemDictionary methodsFor: 'snapshot and quit' stamp: 'jm 3/5/2005 08:51'!
saveAs

	| dir newName newImageName newChangesName |
	dir _ FileDirectory default.
	newName _ FillInTheBlank
		request: 'New File Name?'
		initialAnswer: (FileDirectory localNameFor: self imageName).
	newName isEmpty ifTrue: [^ self].
	newName _ FileDirectory baseNameFor: newName.

	newImageName _ newName, '.image'.
	newChangesName _ newName, '.changes'.
	((dir includesKey: newImageName) or:
	 [dir includesKey: newChangesName]) ifTrue: [
		^ self notify: newName, ' is already in use.
Please choose another name.'].

	dir copyFileNamed: self changesName toFileNamed: newChangesName.
	
	"On Mac, set the file type and creator (noop on other platforms)"
	FileDirectory default
		setMacFileNamed: newChangesName
		type: 'STch'
		creator: 'FAST'.

	self logChange: '----SAVEAS ', newName, '----', Date dateAndTimeNow printString.
	self imageName: (dir fullNameFor: newImageName).
	LastImageName _ self imageName.
	self closeSourceFiles; openSourceFiles.  "so SNAPSHOT appears in new changes file"
	self snapshot: true andQuit: false.
! !

!SystemDictionary methodsFor: 'snapshot and quit' stamp: 'jm 6/7/1999 21:33'!
setGCParameters
	"Adjust the VM's default GC parameters to avoid premature tenuring."

	Smalltalk vmParameterAt: 5 put: 4000.  "do an incremental GC after this many allocations"
	Smalltalk vmParameterAt: 6 put: 2000.  "tenure when more than this many objects survive the GC"
! !

!SystemDictionary methodsFor: 'snapshot and quit' stamp: 'jm 11/19/2004 11:57'!
snapshot: save andQuit: quit
	"Mark the changes file and close all files. If save is true, save the current state of this Smalltalk in the image file. If quit is true, then exit to the outer shell. The latter part of this method runs when resuming a previously saved image. The resume logic checks for a document file to process when starting up."

	| resuming msg sourceLink |
	save & (SourceFiles at: 2) notNil ifTrue:
		[msg _  (quit
			ifTrue: ['----QUIT----']
			ifFalse: ['----SNAPSHOT----'])
			, Date dateAndTimeNow printString.
		sourceLink _ ' priorSource: ' , LastQuitLogPosition printString.
		self assureStartupStampLogged.
		LastQuitLogPosition _ (SourceFiles at: 2) setToEnd; position.
		self logChange: msg , sourceLink.
		Transcript cr; show: msg].

	self processShutDownList.
	Cursor write show.
	save
		ifTrue: [resuming _ self snapshotPrimitive]  "<-- PC frozen here on image file"
		ifFalse: [resuming _ false].
	quit & resuming not ifTrue: [self quitPrimitive].
	Cursor normal show.
	self setGCParameters.
	resuming ifTrue: [self clearExternalObjects].
	self processStartUpList.
	resuming ifTrue: [self readDocumentFile].
	Smalltalk isMorphic ifTrue: [
		World displayWorldSafely.
		SystemWindow wakeUpTopWindowUponStartup].
	Display restore.
	^ resuming
! !

!SystemDictionary methodsFor: 'snapshot and quit'!
snapshotPrimitive
	"Primitive. Write the current state of the object memory on a file in the
	same format as the Smalltalk-80 release. The file can later be resumed,
	returning you to this exact state. Return normally after writing the file.
	Essential. See Object documentation whatIsAPrimitive."

	<primitive: 97>
	self primitiveFailed! !

!SystemDictionary methodsFor: 'snapshot and quit' stamp: 'ar 3/26/2000 16:12'!
unbindExternalPrimitives
	"Primitive. Force all external primitives to be looked up again afterwards. Since external primitives that have not found are bound for fast failure this method will force the lookup of all primitives again so that after adding some plugin the primitives may be found."
	<primitive: 570>
	"Do nothing if the primitive fails for compatibility with older VMs"! !


!SystemDictionary methodsFor: 'housekeeping'!
cleanOutUndeclared 
	Undeclared removeUnreferencedKeys! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'di 8/16/2000 10:08'!
condenseChanges		"Smalltalk condenseChanges"
	"Move all the changes onto a compacted sources file."
	| f oldChanges classCount |
	f _ FileStream fileNamed: 'ST80.temp'.
	f header; timeStamp.
'Condensing Changes File...'
	displayProgressAt: Sensor cursorPoint
	from: 0 to: Smalltalk classNames size
	during:
		[:bar | classCount _ 0.
		Smalltalk allClassesDo:
			[:class | bar value: (classCount _ classCount + 1).
			class moveChangesTo: f.
			class class moveChangesTo: f]].
	LastQuitLogPosition _ f position.
	f trailer; close.
	oldChanges _ SourceFiles at: 2.
	oldChanges close.
	FileDirectory default deleteFileNamed: oldChanges name , '.old'.
	FileDirectory default rename: oldChanges name
						toBe: oldChanges name , '.old'.
	FileDirectory default rename: f name
						toBe: oldChanges name.
	FileDirectory default setMacFileNamed: oldChanges name
						type: 'STch' creator: 'FAST'.
	SourceFiles at: 2
			put: (StandardFileStream oldFileNamed: oldChanges name).! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'JMM 8/10/2000 15:13'!
condenseSources		"Smalltalk condenseSources"
	"Move all the changes onto a compacted sources file."
	| f classCount dir |
	dir _ FileDirectory default.

	"Write all sources with fileIndex 1"
	f _ FileStream newFileNamed: self sourcesName , '.temp'.
	f header; timeStamp.
'Condensing Sources File...'
	displayProgressAt: Sensor cursorPoint
	from: 0 to: Smalltalk classNames size
	during:
		[:bar | classCount _ 0.
		Smalltalk allClassesDo:
			[:class | bar value: (classCount _ classCount + 1).
			class fileOutOn: f moveSource: true toFile: 1]].
	f trailer; close.

	"Make a new empty changes file"
	self closeSourceFiles.
	dir rename: self changesName
		toBe: self changesName , '.old'.
	(FileStream newFileNamed: self changesName)
		header; timeStamp; close.
	LastQuitLogPosition _ 0.

	dir rename: self sourcesName
		toBe: self sourcesName , '.old'.
	dir rename: self sourcesName , '.temp'
		toBe: self sourcesName.

	"On Mac, set the file type and creator (noop on other platforms)"
	FileDirectory default
		setMacFileNamed: self changesName
		type: 'STch'
		creator: 'FAST'.

	FileDirectory default
		setMacFileNamed:  self sourcesName
		type: 'STch'
		creator: 'FAST'.

	self openSourceFiles.
	SelectionMenu notify: 'Source files have been rewritten!!
Check that all is well,
and then save/quit.'! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'ar 7/19/1999 23:00'!
forgetDoIts	"Smalltalk forgetDoIts"
	Smalltalk allBehaviorsDo: "get rid of old DoIt methods"
		[:cl | cl forgetDoIts]

! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'sw 9/21/97 01:14'!
makeInternalRelease		"Smalltalk makeInternalRelease"
	(self confirm: self version , '
Is this the correct version designation?
If not, choose no, and fix it.') ifFalse: [^ self].
	(Object classPool at: #DependentsFields) size > 1 ifTrue: [self halt].
	Browser initialize.
	Undeclared isEmpty ifFalse: [self halt].
	Smalltalk garbageCollect.
	self obsoleteClasses isEmpty ifFalse: [self halt].
	Symbol rehash.
	self halt: 'Ready to condense changes'.
	Smalltalk condenseChanges! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'ar 7/15/1999 16:05'!
obsoleteBehaviors   "Smalltalk obsoleteBehaviors inspect"
	"Find all obsolete behaviors including meta classes"
	| obs |
	obs _ OrderedCollection new.
	Smalltalk garbageCollect.
	self allObjectsDo:[:cl|
		(cl isBehavior and:[cl isObsolete]) ifTrue:[obs add: cl]].
	^ obs asArray! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'jm 5/22/1998 11:37'!
obsoleteClasses   "Smalltalk obsoleteClasses inspect"
	"NOTE:  Also try inspecting comments below"
	| obs c |
	obs _ OrderedCollection new.  Smalltalk garbageCollect.
	Metaclass allInstancesDo:
		[:m | c _ m soleInstance.
		(c ~~ nil and: ['AnOb*' match: c name asString])
			ifTrue: [obs add: c]].
	^ obs asArray

"Likely in a ClassDict or Pool...
(Association allInstances select: [:a | (a value isKindOf: Class) and: ['AnOb*' match: a value name]]) asArray
"
"Obsolete class refs or super pointer in last lit of a method...
| n l found |
Smalltalk browseAllSelect:
	[:m | found _ false.
	1 to: m numLiterals do:
		[:i | (((l _ m literalAt: i) isMemberOf: Association)
				and: [(l value isKindOf: Behavior)
				and: ['AnOb*' match: l value name]])
			ifTrue: [found _ true]].
	found]
"! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'tk 6/24/1999 11:47'!
reclaimDependents		"Smalltalk reclaimDependents"
	"Reclaim unused entries in DependentsFields (DF)..."
	"NOTE:  if <object>addDependent: is ever used to add something
		other than a view, this process will fail to reinstate that
		thing after clearing out DependentsFields.  DF was only
		intended to be used as part of the MVC architecture."
	Object classPool at: #DependentsFields  "Remove all entries from DF"
				put: IdentityDictionary new.
	Smalltalk garbageCollect.  "If that was the only reference, they will go away"
	"Now if any views of non-models remain,
		they should be reinstated as dependent views..."
	View allSubInstancesDo:
		[:v | (v model==nil or: [v model isKindOf: Model])
				ifFalse: [v model addDependent: v]].
	SystemWindow allSubInstancesDo:
		[:v | (v model==nil or: [v model isKindOf: Model])
				ifFalse: [v model addDependent: v]].
! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'di 4/24/2000 14:02'!
recompileAllFrom: firstName 
	"Recompile all classes, starting with given name."

	Smalltalk forgetDoIts.
	self allClassesDo: 
		[:class | class name >= firstName
			ifTrue: 
				[Transcript show: class name; cr.
				class compileAll]]

	"Smalltalk recompileAllFrom: 'AAABodyShop'."
! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'di 10/16/1999 20:31'!
removeAllLineFeeds    "Smalltalk removeAllLineFeeds"
	"Scan all methods for source code with lineFeeds.
	Replaces all occurrences of <CR><LF> by <CR>, noted by beep.
	Halts with a message if any other LFs are found."
	 | oldCodeString n crlf cr newCodeString oldStamp oldCategory m |
	crlf _ String with: Character cr with: Character lf.
	cr _ String with: Character cr.
	Smalltalk forgetDoIts.
'Scanning sources for LineFeeds.
This will take a few minutes...'
displayProgressAt: Sensor cursorPoint
from: 0 to: CompiledMethod instanceCount
during: [:bar | n _ 0. m _ 0.
	Smalltalk allBehaviorsDo:
		[:cls | 
		cls selectors do:
			[:selector | (n _ n+1) \\ 100 = 0 ifTrue: [bar value: n].
			oldCodeString _ (cls sourceCodeAt: selector) asString.
			(oldCodeString indexOf: Character lf startingAt: 1) > 0 ifTrue:
				[self beep.
				newCodeString _ oldCodeString copyReplaceAll: crlf with: cr asTokens: false.
				(newCodeString indexOf: Character lf startingAt: 1) > 0
					ifTrue: [(self confirm: cls name , ' ' , (selector contractTo: 30) , '
has an isolated LineFeed (not part of CRLF).
Shall I replace it?') ifFalse: [self halt]].
				oldStamp _ Utilities timeStampForMethod: (cls compiledMethodAt: selector).
				oldCategory _ cls whichCategoryIncludesSelector: selector.
				cls compile: newCodeString classified: oldCategory withStamp: oldStamp notifying: nil.
				m _ m + 1]]].
].
	Transcript cr; show: m printString , ' methods stripped of LFs.'.
! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'di 6/8/1999 15:47'!
removeEmptyMessageCategories
	"Smalltalk removeEmptyMessageCategories"
	Smalltalk garbageCollect.
	(ClassOrganizer allInstances copyWith: SystemOrganization) do:
		[:org | org removeEmptyCategories]! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'jm 11/20/2007 08:31'!
sanityCheckSourceFiles
	"Check the sources for all methods to if (a) their source code can be retrieved and (b) that it starts with the method selector."
	"Smalltalk sanityCheckSourceFiles"

	| result src prefix |
	result _ OrderedCollection new.
	Smalltalk allBehaviorsDo: [:class |
		class selectorsDo: [:sel |
			src _ [class sourceCodeAt: sel] ifError: [''].
			(sel includes: $:)
				ifTrue: [prefix _ sel copyUpTo: $:]
				ifFalse: [prefix _ sel].
			(src asString beginsWith: prefix) ifFalse: [
				result add: class name, '>>>', sel]]].

	^ result asArray! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'di 8/23/1998 14:35'!
testDecompiler    "Smalltalk testDecompiler"
	"Decompiles the source for every method in the system, and then compiles that source and verifies that it generates (and decompiles to) identical code.  This currently fails in a number of places because some different patterns (esp involving conditionals where the first branch returns) decompile the same."
	 | methodNode oldMethod newMethod badOnes oldCodeString n |
	badOnes _ OrderedCollection new.
	Smalltalk forgetDoIts.
'Decompiling all classes...'
displayProgressAt: Sensor cursorPoint
from: 0 to: CompiledMethod instanceCount
during: [:bar | n _ 0.
	Smalltalk allBehaviorsDo:
		[:cls | 
		"Transcript cr; show: cls name."
		cls selectors do:
			[:selector | (n _ n+1) \\ 100 = 0 ifTrue: [bar value: n].
			oldMethod _ cls compiledMethodAt: selector.
			oldCodeString _ (cls decompilerClass new
								decompile: selector in: cls method: oldMethod)
							decompileString.
			methodNode _ cls compilerClass new
						compile: oldCodeString
						in: cls notifying: nil ifFail: [].
			newMethod _ methodNode generate: #(0 0 0 0).
			oldCodeString = (cls decompilerClass new
								decompile: selector in: cls method: newMethod)
							decompileString ifFalse: [Transcript cr; show: '***' , cls name , ' ' , selector.
											badOnes add: cls name , ' ' , selector]]].
].
	Smalltalk browseMessageList: badOnes asSortedCollection name: 'Decompiler Discrepancies'! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'sw 11/9/1999 17:56'!
testFormatter    "Smalltalk testFormatter"
	"Reformats the source for every method in the system, and then compiles that source and verifies that it generates identical code.   The formatting used will be either classic monochrome or fancy polychrome, depending on the setting of the preference #colorWhenPrettyPrinting."

	 | newCodeString methodNode oldMethod newMethod badOnes n |
	badOnes _ OrderedCollection new.
	Smalltalk forgetDoIts.
'Formatting all classes...'
displayProgressAt: Sensor cursorPoint
from: 0 to: CompiledMethod instanceCount
during: [:bar | n _ 0.
	Smalltalk allBehaviorsDo:
		[:cls | 
		"Transcript cr; show: cls name."
		cls selectors do:
			[:selector | (n _ n+1) \\ 100 = 0 ifTrue: [bar value: n].
			newCodeString _ (cls compilerClass new)
				format: (cls sourceCodeAt: selector)
				in: cls notifying: nil decorated: Preferences colorWhenPrettyPrinting.
			methodNode _ cls compilerClass new
						compile: newCodeString
						in: cls notifying: nil ifFail: [].
			newMethod _ methodNode generate: #(0 0 0 0).
			oldMethod _ cls compiledMethodAt: selector.
			oldMethod = newMethod ifFalse: [Transcript cr; show: '***' , cls name , ' ' , selector.
											badOnes add: cls name , ' ' , selector]]].
].
	Smalltalk browseMessageList: badOnes asSortedCollection name: 'Formatter Discrepancies'! !

!SystemDictionary methodsFor: 'housekeeping' stamp: 'sw 11/9/1999 17:56'!
testFormatter2    "Smalltalk testFormatter2"
	"Reformats the source for every method in the system, and then verifies that the order of source tokens is unchanged.  The formatting used will be either classic monochrome or fancy polychrome, depending on the setting of the preference #colorWhenPrettyPrinting."

	 | newCodeString badOnes n oldCodeString oldTokens newTokens |
	badOnes _ OrderedCollection new.
	Smalltalk forgetDoIts.
'Formatting all classes...'
displayProgressAt: Sensor cursorPoint
from: 0 to: CompiledMethod instanceCount
during: [:bar | n _ 0.
	Smalltalk allBehaviorsDo:
		[:cls | 
		"Transcript cr; show: cls name."
		cls selectors do:
			[:selector | (n _ n+1) \\ 100 = 0 ifTrue: [bar value: n].
			oldCodeString _ (cls sourceCodeAt: selector) asString.
			newCodeString _ (cls compilerClass new)
				format: oldCodeString
				in: cls notifying: nil decorated: Preferences colorWhenPrettyPrinting.
			oldTokens _ oldCodeString findTokens: Character separators.
			newTokens _ newCodeString findTokens: Character separators.
			oldTokens = newTokens ifFalse:
					[Transcript cr; show: '***' , cls name , ' ' , selector.
					badOnes add: cls name , ' ' , selector]]].
].
	Smalltalk browseMessageList: badOnes asSortedCollection name: 'Formatter Discrepancies'! !

!SystemDictionary methodsFor: 'housekeeping'!
verifyChanges		"Smalltalk verifyChanges"
	"Recompile all methods in the changes file."
	Smalltalk allBehaviorsDo: [:class | class recompileChanges].
! !


!SystemDictionary methodsFor: 'miscellaneous'!
clipboardText
	"Get the current clipboard text. Return the empty string if the primitive fails."

	<primitive: 141>
	^ ''! !

!SystemDictionary methodsFor: 'miscellaneous'!
clipboardText: aString
	"Set the current clipboard text to the given string."

	<primitive: 141>
	^ self primitiveFailed! !

!SystemDictionary methodsFor: 'miscellaneous'!
exitToDebugger
	"Primitive. Enter the machine language debugger, if one exists. Essential.
	See Object documentation whatIsAPrimitive."

	<primitive: 114>
	self primitiveFailed! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'jm 7/10/1999 08:26'!
extraVMMemory: extraBytesToReserve
	"Request that the given amount of extra memory be reserved for use by the virtual machine to leave extra C heap space available for things like plugins, network and file buffers, and so on. This request is stored when the image is saved and honored when the image is next started up. Answer the previous value of this parameter."

	extraBytesToReserve < 0
		ifTrue: [self error: 'VM memory reservation must be non-negative'].
	^ Smalltalk vmParameterAt: 23 put: extraBytesToReserve
! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'jm 3/10/98 21:43'!
fullScreenMode: aBoolean
	"On platforms that support it, set full-screen mode to the value of the argument. (Note: you'll need to restore the Display after calling this primitive."
	"Smalltalk fullScreenMode: true. Display newDepth: Display depth"

	<primitive: 233>
	self primitiveFailed
! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'jm 5/8/1998 11:41'!
getSystemAttribute: attributeID
	"Optional. Answer the string for the system attribute with the given integer ID. Answer nil if the given attribute is not defined on this platform. On platforms that support invoking programs from command lines (e.g., Unix), this mechanism can be used to pass command line arguments to programs written in Squeak. By convention, the first command line argument that is not a VM configuration option is considered a 'document' to be filed in. Such a document can add methods and classes, can contain a serialized object, can include code to be executed, or any combination of these.
	Currently defined attributes include:
	-1000...-1 - command line arguments that specify VM options
	0 - the full path name for currently executing VM
		(or, on some platforms, just the path name of the VM's directory)
	1 - full path name of this image
	2 - a Squeak document to open, if any
	3...1000 - command line arguments for Squeak programs
	1001 - this platform's operating system
	1002 - operating system version
	1003 - this platform's processor type" 

	<primitive: 149>
	^ nil
! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'ikp 1/2/98 20:29'!
getVMParameters	"Smalltalk getVMParameters"
	"Answer an Array containing the current values of the VM's internal
	parameter/metric registers.  Each value is stored in the array at the
	index corresponding to its VM register.  (See #vmParameterAt: and
	#vmParameterAt:put:.)"

	<primitive: 254>
	self primitiveFailed! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'jm 8/8/2005 12:26'!
handleUserInterrupt

	World ifNotNil: [
		World allMorphsDo: [:m |
			(m isKindOf: ScratchStageMorph) ifTrue: [m stopAll]].
		Preferences noviceMode ifTrue: [^ self]].

	Preferences cmdDotEnabled ifTrue:
		[Smalltalk isMorphic
			ifTrue: [[Project current interruptName: 'User Interrupt'] fork]
			ifFalse: [[ScheduledControllers interruptName: 'User Interrupt'] fork]]
! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'di 7/19/1999 15:44'!
hasMorphic
	"Answer whether the Morphic classes are available in the system (they may have been stripped, such as by a call to Smalltalk removeMorphic"

	^ ((Smalltalk at: #Morph ifAbsent: [nil]) isKindOf: Class)! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'jm 1/23/2007 14:29'!
isMacOSX
	"Answer true if running on Macintosh OS X 10.0 or later."

	^ (self platformName = 'Mac OS') and: [self osVersion asNumber >= 1000]! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'jm 6/3/2009 15:35'!
isUnix
	"Answer true if running on Unix or Linux."

	^ self platformName = 'unix'
! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'jm 6/26/2008 17:29'!
isWindows
	"Answer true if running on Windows."

	^ self platformName = 'Win32'
! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'ar 5/16/2000 00:54'!
listBuiltinModule: index
	"Return the name of the n-th builtin module.
	This list is not sorted!!"
	<primitive: 572>
	^self primitiveFailed! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'ar 6/5/2000 18:44'!
listBuiltinModules
	"Smalltalk listBuiltinModules"
	"Return a list of all builtin modules (e.g., plugins). Builtin plugins are those that are compiled with the VM directly, as opposed to plugins residing in an external shared library. The list will include all builtin plugins regardless of whether they are currently loaded or not. Note that the list returned is not sorted!!"
	| modules index name |
	modules _ WriteStream on: Array new.
	index _ 1.
	[true] whileTrue:[
		name _ self listBuiltinModule: index.
		name ifNil:[^modules contents].
		modules nextPut: name.
		index _ index + 1.
	].! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'TPR 5/16/2000 16:56'!
listLoadedModule: index
	"Return the name of the n-th loaded module.
	This list is not sorted!!"
	<primitive: 573>
	^self primitiveFailed! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'ar 6/5/2000 18:43'!
listLoadedModules
	"Smalltalk listLoadedModules"
	"Return a list of all currently loaded modules (e.g., plugins). Loaded modules are those that currently in use (e.g., active). The list returned will contain all currently active modules regardless of whether they're builtin (that is compiled with the VM) or external (e.g., residing in some external shared library). Note that the returned list is not sorted!!"
	| modules index name |
	modules _ WriteStream on: Array new.
	index _ 1.
	[true] whileTrue:[
		name _ self listLoadedModule: index.
		name ifNil:[^modules contents].
		modules nextPut: name.
		index _ index + 1.
	].! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'di 12/6/1999 19:54'!
logError: errMsg inContext: aContext to: aFilename
	"Log the error message and a stack trace to the given file."
	| ff ctx |
	FileDirectory default deleteFileNamed: aFilename ifAbsent: [].
	(ff _ FileStream fileNamed: aFilename) ifNil: [^ self "avoid recursive errors"].
  	ff print: Date today; space; print: Time now; cr.
  	ff nextPutAll: errMsg; cr.
	"Note: The following is an open-coded version of ContextPart>>stackOfSize:
	since this method may be called during a low space condition and we might
	run out of space for allocating the full stack."
	ctx _ aContext.
	[ctx == nil] whileFalse:[
		ff print: ctx; cr.
		ctx _ ctx sender].
	ff close.! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'jm 12/30/2006 20:04'!
osVersion
	"Smalltalk osVersion"

	^ Smalltalk getSystemAttribute: 1002
! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'jm 12/30/2006 20:03'!
platformName
	"Smalltalk platformName"

	^ Smalltalk getSystemAttribute: 1001
! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'jm 11/1/1998 11:38'!
spaceForInstancesOf: aClass
	"Answer the number of bytes consumed by all instances of the given class, including thier object headers."

	| instCount isCompact instVarBytes bytesPerElement contentBytes headerBytes total |
	instCount _ aClass instanceCount.
	instCount = 0 ifTrue: [^ 0].
	isCompact _ aClass indexIfCompact > 0.
	instVarBytes _ aClass instSize * 4.
	aClass isVariable
		ifTrue: [
			bytesPerElement _ aClass isBytes ifTrue: [1] ifFalse: [4].
			total _ 0.
			aClass allInstancesDo: [:inst |
				contentBytes _ instVarBytes + (inst size * bytesPerElement).
				headerBytes _
					contentBytes > 255
						ifTrue: [12]
						ifFalse: [isCompact ifTrue: [4] ifFalse: [8]].
				total _ total + headerBytes + contentBytes].
			^ total]
		ifFalse: [
			headerBytes _
				instVarBytes > 255
					ifTrue: [12]
					ifFalse: [isCompact ifTrue: [4] ifFalse: [8]].
			^ instCount * (headerBytes + instVarBytes)].
! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'jm 11/1/1998 11:45'!
spaceTally
	"Answer a collection of tuples representing the memory space (in bytes) consumed by the code and instances of each class in the system. The tuples have the form:
	<class> <code size> <instance count> <space for instances>
Code sizes do not currently report memory consumed by class variables. The arrays used to record these results consume a relatively insignificant amount of space."
	"(Smalltalk spaceTally asSortedCollection: [:a :b | a last > b last]) asArray"

	| results entry c |
	"pre-allocate array of entries for results"
	results _ OrderedCollection new: self size.
	self do: [:cl |
		(cl isKindOf: Class) ifTrue: [
			entry _ Array new: 4.
			entry at: 1 put: cl.
			results add: entry]].
	results _ results asArray.

	Smalltalk garbageCollect.
	1 to: results size do: [:i |
		entry _ results at: i.
		c _ entry at: 1.
		entry at: 2 put: c spaceUsed.
		entry at: 3 put: c instanceCount.
		entry at: 4 put: (self spaceForInstancesOf: c).
		Smalltalk garbageCollectMost].
	^ results
! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'jm 12/1/2005 16:48'!
unloadPlugin: aString
	"Primitive. Unload the given Squeak plugin. The mechanism for unloading may not be supported on all platforms. If your system does not support plugin unloading you'll need to save your image, quit, and restart Squeak in order to load a new version of a plugin that you're developing."

	<primitive: 571>
	^ self primitiveFailed
! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'sw 9/21/1998 11:03'!
verifyMorphicAvailability
	"If Morphic is available, return true; if not, put up an informer and return false"
	self hasMorphic ifFalse:
		[self beep.
		self inform: 'Sorry, Morphic must
be present to use this feature'.
		^ false].
	^ true! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'ikp 1/2/98 20:29'!
vmParameterAt: parameterIndex
	"parameterIndex is a positive integer corresponding to one of the VM's internal
	parameter/metric registers.  Answer with the current value of that register.
	Fail if parameterIndex has no corresponding register."

	<primitive: 254>
	self primitiveFailed! !

!SystemDictionary methodsFor: 'miscellaneous' stamp: 'ikp 1/2/98 20:29'!
vmParameterAt: parameterIndex put: newValue
	"parameterIndex is a positive integer corresponding to one of the VM's internal
	parameter/metric registers.  Store newValue (a positive integer) into that
	register and answer with the previous value that was stored there.
	Fail if newValue is out of range, if parameterIndex has no corresponding
	register, or if the corresponding register is read-only."

	<primitive: 254>
	self primitiveFailed! !


!SystemDictionary methodsFor: 'accessing' stamp: 'ar 7/11/1999 21:56'!
organization
	"Return the organizer for the receiver"
	^SystemOrganization! !


!SystemDictionary methodsFor: 'printing' stamp: 'sma 6/1/2000 09:53'!
printElementsOn: aStream
	aStream nextPutAll:'(lots of globals)'! !


Magnitude subclass: #Character
	instanceVariableNames: 'value '
	classVariableNames: 'CharacterTable '
	poolDictionaries: ''
	category: 'Collections-Text'!
!Character commentStamp: '<historical>' prior: 0!
I represent a character by storing its associated ASCII code (extended to 256 codes). My instances are created uniquely, so that all instances of a character ($R, for example) are identical.!


!Character methodsFor: 'accessing'!
asciiValue
	"Answer the value of the receiver that represents its ascii encoding."

	^value! !

!Character methodsFor: 'accessing'!
digitValue
	"Answer 0-9 if the receiver is $0-$9, 10-35 if it is $A-$Z, and < 0 
	otherwise. This is used to parse literal numbers of radix 2-36."

	value <= $9 asciiValue 
		ifTrue: [^value - $0 asciiValue].
	value >= $A asciiValue 
		ifTrue: [value <= $Z asciiValue ifTrue: [^value - $A asciiValue + 10]].
	^ -1! !


!Character methodsFor: 'comparing'!
< aCharacter 
	"Answer true if the receiver's value < aCharacter's value."

	^self asciiValue < aCharacter asciiValue! !

!Character methodsFor: 'comparing'!
= aCharacter 
	"Primitive. Answer true if the receiver and the argument are the same
	object (have the same object pointer) and false otherwise. Optional. See
	Object documentation whatIsAPrimitive."

	<primitive: 110>
	^self == aCharacter! !

!Character methodsFor: 'comparing'!
> aCharacter 
	"Answer true if the receiver's value > aCharacter's value."

	^self asciiValue > aCharacter asciiValue! !

!Character methodsFor: 'comparing'!
hash
	"Hash is reimplemented because = is implemented."

	^value! !


!Character methodsFor: 'testing'!
isAlphaNumeric
	"Answer whether the receiver is a letter or a digit."

	^self isLetter or: [self isDigit]! !

!Character methodsFor: 'testing'!
isDigit
	"Answer whether the receiver is a digit."

	^value >= 48 and: [value <= 57]! !

!Character methodsFor: 'testing'!
isLetter
	"Answer whether the receiver is a letter."

	^(8r141 <= value and: [value <= 8r172])
		or: [8r101 <= value and: [value <= 8r132]]! !

!Character methodsFor: 'testing'!
isLowercase
	"Answer whether the receiver is a lowercase letter.
	(The old implementation answered whether the receiver is not an uppercase letter.)"

	^8r141 <= value and: [value <= 8r172]! !

!Character methodsFor: 'testing' stamp: 'jm 11/9/2006 09:16'!
isSafeForHTTP
	"whether a character is 'safe', or needs to be escaped when used, eg, in a URL"
	^self isAlphaNumeric or: [ '.~-_/' includes: self ]! !

!Character methodsFor: 'testing'!
isSeparator
	"Answer whether the receiver is one of the separator characters--space, 
	cr, tab, line feed, or form feed."

	value = 32 ifTrue: [^true].	"space"
	value = 13 ifTrue: [^true].	"cr"
	value = 9 ifTrue: [^true].	"tab"
	value = 10 ifTrue: [^true].	"line feed"
	value = 12 ifTrue: [^true].	"form feed"
	^false! !

!Character methodsFor: 'testing' stamp: 'di 4/3/1999 00:38'!
isSpecial
	"Answer whether the receiver is one of the special characters"

	^'+-/\*~<>=@,%|&?!!' includes: self! !

!Character methodsFor: 'testing'!
isUppercase
	"Answer whether the receiver is an uppercase letter.
	(The old implementation answered whether the receiver is not a lowercase letter.)"

	^8r101 <= value and: [value <= 8r132]! !

!Character methodsFor: 'testing'!
isVowel
	"Answer whether the receiver is one of the vowels, AEIOU, in upper or 
	lower case."

	^'AEIOU' includes: self asUppercase! !

!Character methodsFor: 'testing'!
tokenish
	"Answer whether the receiver is a valid token-character--letter, digit, or 
	colon."

	^self isLetter or: [self isDigit or: [self = $:]]! !


!Character methodsFor: 'copying'!
copy
	"Answer with the receiver because Characters are unique."! !

!Character methodsFor: 'copying'!
deepCopy
	"Answer with the receiver because Characters are unique."! !


!Character methodsFor: 'printing'!
hex
	^ String with: ('0123456789ABCDEF' at: value//16+1)
			with:  ('0123456789ABCDEF' at: value\\16+1)! !

!Character methodsFor: 'printing'!
isLiteral

	^true! !

!Character methodsFor: 'printing'!
printOn: aStream

	aStream nextPut: $$.
	aStream nextPut: self! !

!Character methodsFor: 'printing'!
storeOn: aStream
	"Character literals are preceded by '$'."

	aStream nextPut: $$; nextPut: self! !


!Character methodsFor: 'converting'!
asCharacter
	"Answer the receiver itself."

	^self! !

!Character methodsFor: 'converting'!
asInteger
	"Answer the value of the receiver."

	^value! !

!Character methodsFor: 'converting'!
asLowercase
	"If the receiver is uppercase, answer its matching lowercase Character."
	
	(8r101 <= value and: [value <= 8r132])  "self isUppercase"
		ifTrue: [^ Character value: value + 8r40]
		ifFalse: [^ self]! !

!Character methodsFor: 'converting' stamp: 'sma 3/11/2000 17:21'!
asString
	^ String with: self! !

!Character methodsFor: 'converting'!
asSymbol 
	"Answer a Symbol consisting of the receiver as the only element."

	^Symbol internCharacter: self! !

!Character methodsFor: 'converting'!
asUppercase
	"If the receiver is lowercase, answer its matching uppercase Character."
	
	(8r141 <= value and: [value <= 8r172])  "self isLowercase"
		ifTrue: [^ Character value: value - 8r40]
		ifFalse: [^ self]! !

!Character methodsFor: 'converting' stamp: 'sma 3/15/2000 22:57'!
isoToSqueak
	"Convert receiver from iso8895-1 (actually CP1252) to mac encoding.
	Does not do lf/cr conversion!! Characters not available in MacRoman
	encoding have been remapped to their base characters or to $?."

	value < 128 ifTrue: [^ self].
	^ Character value: (#(
		219 63 226 196 227 201 160 224 246 228 83 220 206 63 90 63		"80-8F"
		63 212 213 210 211 165 208 209 247 170 115 221 207 63 122 217		"90-9F"
		202 193 162 163 63 180 124 164 172 169 187 199 194 45 168 248	 	"A0-AF"
		161 177 50 51 171 181 166 225 252 49 188 200 63 63 63 192 			"B0-BF"
		203 231 229 204 128 129 174 130 233 131 230 232 237 234 235 236 	"C0-CF"
		63 132 241 238 239 205 133 42 175 244 242 243 134 89 63 167	 	"D0-DF"
		136 135 137 139 138 140 190 141 143 142 144 145 147 146 148 149		"E0-EF"
		63 150 152 151 153 155 154 214 191 157 156 158 159 121 63 216		"F0-FF"
	) at: value - 127)! !

!Character methodsFor: 'converting'!
to: other
	"Answer with a collection in ascii order -- $a to: $z"
	^ (self asciiValue to: other asciiValue) collect:
				[:ascii | Character value: ascii]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Character class
	instanceVariableNames: ''!

!Character class methodsFor: 'class initialization'!
initialize
	"Create the table of unique Characters. This code is not shown so that the
	user can not destroy the system by trying to recreate the table."! !


!Character class methodsFor: 'instance creation' stamp: 'ls 8/15/1998 06:56'!
allCharacters
	^ (0 to: 255)
		collect: [:v | Character value: v]

	
! !

!Character class methodsFor: 'instance creation'!
digitValue: x 
	"Answer the Character whose digit value is x. For example, answer $9 for 
	x=9, $0 for x=0, $A for x=10, $Z for x=35."

	| index |
	index _ x asInteger.
	^CharacterTable at: 
		(index < 10
			ifTrue: [48 + index]
			ifFalse: [55 + index])
		+ 1! !

!Character class methodsFor: 'instance creation'!
new
	"Creating new characters is not allowed."

	self error: 'cannot create new characters'! !

!Character class methodsFor: 'instance creation'!
separators
	^ #(32 "space"
		13 "cr"
		9 "tab"
		10 "line feed"
		12 "form feed")
		collect: [:v | Character value: v]

	
! !

!Character class methodsFor: 'instance creation'!
value: anInteger 
	"Answer the Character whose value is anInteger."

	^CharacterTable at: anInteger + 1! !


!Character class methodsFor: 'constants'!
backspace
	"Answer the Character representing a backspace."

	^self value: 8! !

!Character class methodsFor: 'constants'!
cr
	"Answer the Character representing a carriage return."

	^self value: 13! !

!Character class methodsFor: 'constants'!
enter
	"Answer the Character representing enter."

	^self value: 3! !

!Character class methodsFor: 'constants' stamp: 'ls 9/8/1998 22:15'!
lf
	"Answer the Character representing a linefeed."

	^self value: 10! !

!Character class methodsFor: 'constants'!
linefeed
	"Answer the Character representing a linefeed."

	^self value: 10! !

!Character class methodsFor: 'constants'!
newPage
	"Answer the Character representing a form feed."

	^self value: 12! !

!Character class methodsFor: 'constants'!
space
	"Answer the Character representing a space."

	^self value: 32! !

!Character class methodsFor: 'constants'!
tab
	"Answer the Character representing a tab."

	^self value: 9! !


ArrayedCollection variableByteSubclass: #String
	instanceVariableNames: ''
	classVariableNames: 'AsciiOrder CSLineEnders CSNonSeparators CSSeparators CaseInsensitiveOrder CaseSensitiveOrder HtmlEntities LowercasingTable '
	poolDictionaries: ''
	category: 'Collections-Text'!
!String commentStamp: '<historical>' prior: 0!
A String is an indexed collection of Characters, compactly encoded as 8-bit bytes.

String support a vast array of useful methods, which can best be learned by browsing and trying out examples as you find them in the code.

Here are a few useful methods to look at...
	String match:
	String contractTo:

String also inherits many useful methods from its hierarchy, such as
	SequenceableCollection ,
	SequenceableCollection copyReplaceAll:with:!
]style[(269 13 2 18 72 24 2 43)f1,f1LString match:;,f1,f1LString contractTo:;,f1,f1LSequenceableCollection ,;,f1,f1LSequenceableCollection copyReplaceAll:with:;!


!String methodsFor: 'accessing'!
at: index 
	"Primitive. Answer the Character stored in the field of the receiver
	indexed by the argument. Fail if the index argument is not an Integer or
	is out of bounds. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 63>
	^Character value: (super at: index)! !

!String methodsFor: 'accessing' stamp: 'wod 6/16/1998 15:24'!
at: index put: aCharacter 
	"Primitive. Store the Character in the field of the receiver indicated by
	the index. Fail if the index is not an Integer or is out of bounds, or if
	the argument is not a Character. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 64>
	(aCharacter isKindOf: Character)
		ifTrue: [	
			index isInteger
				ifTrue: [self errorSubscriptBounds: index]
				ifFalse: [self errorNonIntegerIndex]]
		ifFalse: [self error: 'Strings only store Characters']! !

!String methodsFor: 'accessing' stamp: 'ar 12/27/1999 13:44'!
byteAt: index
	<primitive: 60>
	^(self at: index) asciiValue! !

!String methodsFor: 'accessing' stamp: 'ar 12/27/1999 13:44'!
byteAt: index put: value
	<primitive: 61>
	self at: index put: value asCharacter.
	^value! !

!String methodsFor: 'accessing'!
endsWithDigit
	"Answer whether the receiver's final character represents a digit.  3/11/96 sw"

	^ self size > 0 and: [self last isDigit]! !

!String methodsFor: 'accessing' stamp: 'tk 12/26/97 11:09'!
findAnySubStr: delimiters startingAt: start 
	"Answer the index of the character within the receiver, starting at start, that begins a substring matching one of the delimiters.  delimiters is an Array of Strings (Characters are permitted also).  If the receiver does not contain any of the delimiters, answer size + 1."

	| min ind |
	min _ self size + 1.
	delimiters do: [:delim |	"May be a char, a string of length 1, or a substring"
		delim class == Character 
			ifTrue: [ind _ self indexOfSubCollection: (String with: delim) 
						startingAt: start ifAbsent: [min]]
			ifFalse: [ind _ self indexOfSubCollection: delim 
						startingAt: start ifAbsent: [min]].
			min _ min min: ind].
	^ min! !

!String methodsFor: 'accessing' stamp: 'ls 3/19/2000 16:43'!
findCloseParenthesisFor: startIndex
	"assume (self at: startIndex) is $(.  Find the matching $), allowing parentheses to nest."
	" '(1+(2-3))-3.14159' findCloseParenthesisFor: 1 "
	" '(1+(2-3))-3.14159' findCloseParenthesisFor: 4 "
	| pos nestLevel |
	pos := startIndex+1.
	nestLevel := 1.
	[ pos <= self size ] whileTrue: [
		(self at: pos) = $( ifTrue: [ nestLevel := nestLevel + 1 ].
		(self at: pos) = $) ifTrue: [ nestLevel := nestLevel - 1 ].
		nestLevel = 0 ifTrue: [ ^pos ].
		pos := pos + 1.
	].
	^self size + 1! !

!String methodsFor: 'accessing'!
findDelimiters: delimiters startingAt: start 
	"Answer the index of the character within the receiver, starting at start, that matches one of the delimiters. If the receiver does not contain any of the delimiters, answer size + 1."

	start to: self size do: [:i |
		delimiters do: [:delim | delim = (self at: i) ifTrue: [^ i]]].
	^ self size + 1! !

!String methodsFor: 'accessing' stamp: 'ar 4/11/1999 22:15'!
findString: subString
	"Answer the index of subString within the receiver, starting at start. If 
	the receiver does not contain subString, answer 0."
	^self findString: subString startingAt: 1.! !

!String methodsFor: 'accessing' stamp: 'di 11/15/1998 16:43'!
findString: subString startingAt: start 
	"Answer the index of subString within the receiver, starting at start. If 
	the receiver does not contain subString, answer 0."

	^ self findSubstring: subString in: self startingAt: start matchTable: CaseSensitiveOrder! !

!String methodsFor: 'accessing' stamp: 'di 11/15/1998 16:45'!
findString: key startingAt: start caseSensitive: caseSensitive
	"Answer the index in this String at which the substring key first occurs, at or beyond start.  The match can be case-sensitive or not.  If no match is found, zero will be returned."

	caseSensitive
	ifTrue: [^ self findSubstring: key in: self startingAt: start matchTable: CaseSensitiveOrder]
	ifFalse: [^ self findSubstring: key in: self startingAt: start matchTable: CaseInsensitiveOrder]! !

!String methodsFor: 'accessing' stamp: 'sw 8/12/97 12:37'!
includesSubString: subString
	^ (self findString: subString startingAt: 1) > 0! !

!String methodsFor: 'accessing' stamp: 'di 11/15/1998 16:53'!
includesSubstring: aString caseSensitive: caseSensitive
	
	^ (self findString: aString startingAt: 1 caseSensitive: caseSensitive) > 0! !

!String methodsFor: 'accessing' stamp: 'di 9/1/1999 18:28'!
indexOf: aCharacter

	(aCharacter class == Character) ifFalse: [^ 0].
	^ String indexOfAscii: aCharacter asciiValue inString: self startingAt: 1! !

!String methodsFor: 'accessing' stamp: 'di 9/1/1999 18:28'!
indexOf: aCharacter  startingAt: start

	(aCharacter class == Character) ifFalse: [^ 0].
	^ String indexOfAscii: aCharacter asciiValue inString: self startingAt: start! !

!String methodsFor: 'accessing' stamp: 'di 9/1/1999 18:28'!
indexOf: aCharacter  startingAt: start  ifAbsent: aBlock
	| ans |
	(aCharacter class == Character) ifFalse: [ ^ aBlock value ].
	ans _ String indexOfAscii: aCharacter asciiValue inString: self  startingAt: start.
	ans = 0
		ifTrue: [ ^ aBlock value ]
		ifFalse: [ ^ ans ]! !

!String methodsFor: 'accessing' stamp: 'ls 8/20/1998 05:19'!
indexOfAnyOf: aCharacterSet  ifAbsent: aBlock
	"returns the index of the first character in the given set.  Returns the evaluation of aBlock if none are found"
	^self indexOfAnyOf: aCharacterSet  startingAt: 1  ifAbsent: aBlock! !

!String methodsFor: 'accessing' stamp: 'ls 8/18/1998 00:27'!
indexOfAnyOf: aCharacterSet  startingAt: start ifAbsent: aBlock
	"returns the index of the first character in the given set, starting from start"

	| ans |
	ans _ String findFirstInString: self  inSet: aCharacterSet byteArrayMap startingAt: start.

	ans = 0 
		ifTrue: [ ^aBlock value ]
		ifFalse: [ ^ans ]! !

!String methodsFor: 'accessing' stamp: 'jm 12/6/2006 16:20'!
indexOfSeparatorStartingAt: index
	"Answer the index of the next separator character found starting at the given index. Answer size + 1 if none is found."

	^ self
		indexOfAnyOf: CSSeparators
		startingAt: index 
		ifAbsent: [self size + 1]
! !

!String methodsFor: 'accessing' stamp: 'di 11/15/1998 17:02'!
indexOfSubCollection: sub startingAt: start ifAbsent: exceptionBlock
	| index |
	index _ self findSubstring: sub in: self startingAt: start matchTable: CaseSensitiveOrder.
	index = 0 ifTrue: [^ exceptionBlock value].
	^ index! !

!String methodsFor: 'accessing'!
skipDelimiters: delimiters startingAt: start 
	"Answer the index of the character within the receiver, starting at start, that does NOT match one of the delimiters. If the receiver does not contain any of the delimiters, answer size + 1.  Assumes the delimiters to be a non-empty string."

	start to: self size do: [:i |
		delimiters detect: [:delim | delim = (self at: i)]
				ifNone: [^ i]].
	^ self size + 1! !

!String methodsFor: 'accessing' stamp: 'sw 4/23/1998 10:53'!
startsWithDigit
	"Answer whether the receiver's first character represents a digit"

	^ self size > 0 and: [self first isDigit]! !


!String methodsFor: 'comparing' stamp: 'di 2/27/98 12:16'!
< aString 
	"Answer whether the receiver sorts before aString.
	The collation order is simple ascii (with case differences)."

	^ (self compare: self with: aString collated: AsciiOrder) = 1! !

!String methodsFor: 'comparing' stamp: 'di 2/27/98 12:17'!
<= aString 
	"Answer whether the receiver sorts before or equal to aString.
	The collation order is simple ascii (with case differences)."

	^ (self compare: self with: aString collated: AsciiOrder) <= 2! !

!String methodsFor: 'comparing' stamp: 'di 9/14/1998 16:29'!
= aString 
	"Answer whether the receiver sorts equally as aString.
	The collation order is simple ascii (with case differences)."

	aString species == String ifFalse: [^ false].

	^ (self compare: self with: aString collated: AsciiOrder) = 2! !

!String methodsFor: 'comparing' stamp: 'di 2/27/98 12:17'!
> aString 
	"Answer whether the receiver sorts after aString.
	The collation order is simple ascii (with case differences)."

	^ (self compare: self with: aString collated: AsciiOrder) = 3! !

!String methodsFor: 'comparing' stamp: 'di 2/27/98 12:18'!
>= aString 
	"Answer whether the receiver sorts after or equal to aString.
	The collation order is simple ascii (with case differences)."

	^ (self compare: self with: aString collated: AsciiOrder) >= 2! !

!String methodsFor: 'comparing'!
alike: aString 
	"Answer some indication of how alike the receiver is to the argument,  0 is no match, twice aString size is best score.  Case is ignored."

	| i j k minSize bonus |
	minSize _ (j _ self size) min: (k _ aString size).
	bonus _ (j - k) abs < 2 ifTrue: [ 1 ] ifFalse: [ 0 ].
	i _ 1.
	[(i <= minSize) and: [((super at: i) bitAnd: 16rDF)  = ((aString at: i) asciiValue bitAnd: 16rDF)]]
		whileTrue: [ i _ i + 1 ].
	[(j > 0) and: [(k > 0) and:
		[((super at: j) bitAnd: 16rDF) = ((aString at: k) asciiValue bitAnd: 16rDF)]]]
			whileTrue: [ j _ j - 1.  k _ k - 1. ].
	^ i - 1 + self size - j + bonus. ! !

!String methodsFor: 'comparing' stamp: 'di 11/15/1998 17:25'!
beginsWith: prefix
	"Answer whether the receiver begins with the given prefix string.
	The comparison is case-sensitive."

	self size < prefix size ifTrue: [^ false].
	^ (self findSubstring: prefix in: self startingAt: 1
			matchTable: CaseSensitiveOrder) = 1
! !

!String methodsFor: 'comparing' stamp: 'jm 4/27/2007 13:13'!
caseInsensitiveEqual: aString 
	"Answer whether the receiver is equal to aString ignoring case differences."

	^ (self compare: self with: aString collated: CaseInsensitiveOrder) = 2! !

!String methodsFor: 'comparing' stamp: 'sw 4/19/1999 12:11'!
caseInsensitiveLessOrEqual: aString 
	"Answer whether the receiver sorts before or equal to aString.
	The collation order is case insensitive."

	^ (self compare: self with: aString collated: CaseInsensitiveOrder) <= 2! !

!String methodsFor: 'comparing' stamp: 'di 9/20/1998 14:33'!
caseSensitiveLessOrEqual: aString 
	"Answer whether the receiver sorts before or equal to aString.
	The collation order is case sensitive."

	^ (self compare: self with: aString collated: CaseSensitiveOrder) <= 2! !

!String methodsFor: 'comparing' stamp: 'di 2/27/98 12:41'!
compare: aString 
	"Answer a comparison code telling how the receiver sorts relative to aString:
		1 - before
		2 - equal
		3 - after.
	The collation sequence is ascii with case differences ignored.
	To get the effect of a <= b, but ignoring case, use (a compare: b) <= 2."

	^ self compare: self with: aString collated: CaseInsensitiveOrder! !

!String methodsFor: 'comparing' stamp: 'go 2/11/98 14:59'!
crc16
	"Compute a 16 bit cyclic redundancy check."

	| crc |
	crc := 0.
	self do: [:c |
		crc := (crc bitShift: -8) bitXor: (
		 #(	16r0000	16rC0C1	16rC181	16r0140	16rC301	16r03C0	16r0280	16rC241
			16rC601	16r06C0	16r0780	16rC741	16r0500	16rC5C1	16rC481	16r0440
			16rCC01	16r0CC0	16r0D80	16rCD41	16r0F00	16rCFC1	16rCE81	16r0E40
			16r0A00	16rCAC1	16rCB81	16r0B40	16rC901	16r09C0	16r0880	16rC841
			16rD801	16r18C0	16r1980	16rD941	16r1B00	16rDBC1	16rDA81	16r1A40
			16r1E00	16rDEC1	16rDF81	16r1F40	16rDD01	16r1DC0	16r1C80	16rDC41
			16r1400	16rD4C1	16rD581	16r1540	16rD701	16r17C0	16r1680	16rD641
			16rD201	16r12C0	16r1380	16rD341	16r1100	16rD1C1	16rD081	16r1040
			16rF001	16r30C0	16r3180	16rF141	16r3300	16rF3C1	16rF281	16r3240
			16r3600	16rF6C1	16rF781	16r3740	16rF501	16r35C0	16r3480	16rF441
			16r3C00	16rFCC1	16rFD81	16r3D40	16rFF01	16r3FC0	16r3E80	16rFE41
			16rFA01	16r3AC0	16r3B80	16rFB41	16r3900	16rF9C1	16rF881	16r3840
			16r2800	16rE8C1	16rE981	16r2940	16rEB01	16r2BC0	16r2A80	16rEA41
			16rEE01	16r2EC0	16r2F80	16rEF41	16r2D00	16rEDC1	16rEC81	16r2C40
			16rE401	16r24C0	16r2580	16rE541	16r2700	16rE7C1	16rE681	16r2640
			16r2200	16rE2C1	16rE381	16r2340	16rE101	16r21C0	16r2080	16rE041
			16rA001	16r60C0	16r6180	16rA141	16r6300	16rA3C1	16rA281	16r6240
			16r6600	16rA6C1	16rA781	16r6740	16rA501	16r65C0	16r6480	16rA441
			16r6C00	16rACC1	16rAD81	16r6D40	16rAF01	16r6FC0	16r6E80	16rAE41
			16rAA01	16r6AC0	16r6B80	16rAB41	16r6900	16rA9C1	16rA881	16r6840
			16r7800	16rB8C1	16rB981	16r7940	16rBB01	16r7BC0	16r7A80	16rBA41
			16rBE01	16r7EC0	16r7F80	16rBF41	16r7D00	16rBDC1	16rBC81	16r7C40
			16rB401	16r74C0	16r7580	16rB541	16r7700	16rB7C1	16rB681	16r7640
			16r7200	16rB2C1	16rB381	16r7340	16rB101	16r71C0	16r7080	16rB041
			16r5000	16r90C1	16r9181	16r5140	16r9301	16r53C0	16r5280	16r9241
			16r9601	16r56C0	16r5780	16r9741	16r5500	16r95C1	16r9481	16r5440
			16r9C01	16r5CC0	16r5D80	16r9D41	16r5F00	16r9FC1	16r9E81	16r5E40
			16r5A00	16r9AC1	16r9B81	16r5B40	16r9901	16r59C0	16r5880	16r9841
			16r8801	16r48C0	16r4980	16r8941	16r4B00	16r8BC1	16r8A81	16r4A40
			16r4E00	16r8EC1	16r8F81	16r4F40	16r8D01	16r4DC0	16r4C80	16r8C41
			16r4400	16r84C1	16r8581	16r4540	16r8701	16r47C0	16r4680	16r8641
			16r8201	16r42C0	16r4380	16r8341	16r4100	16r81C1	16r8081	16r4040)
			 at: ((crc bitXor: c asciiValue) bitAnd: 16rFF) + 1) ].
	^crc! !

!String methodsFor: 'comparing' stamp: 'di 11/15/1998 17:25'!
endsWith: suffix
	"Answer whether the tail end of the receiver is the same as suffix.
	The comparison is case-sensitive."
	| extra |
	(extra _ self size - suffix size) < 0 ifTrue: [^ false].
	^ (self findSubstring: suffix in: self startingAt: extra + 1
			matchTable: CaseSensitiveOrder) > 0
"
  'Elvis' endsWith: 'vis'
"! !

!String methodsFor: 'comparing'!
hash

	| l m |
	(l _ m _ self size) <= 2
	  ifTrue:
		[l = 2
		  ifTrue: [m _ 3]
		  ifFalse:
			[l = 1
			  ifTrue: [^((self at: 1) asciiValue bitAnd: 127) * 106].
			^21845]].
	^(self at: 1) asciiValue * 48 + ((self at: (m - 1)) asciiValue + l)! !

!String methodsFor: 'comparing' stamp: 'di 11/19/1998 13:37'!
match: text
	"Answer whether text matches the pattern in this string.
	Matching ignores upper/lower case differences.
	Where this string contains #, text may contain any character.
	Where this string contains *, text may contain any sequence of characters."

	^ self startingAt: 1 match: text startingAt: 1
"
	'*'			match: 'zort' true
	'*baz'		match: 'mobaz' true
	'*baz'		match: 'mobazo' false
	'*baz*'		match: 'mobazo' true
	'*baz*'		match: 'mozo' false
	'foo*'		match: 'foozo' true
	'foo*'		match: 'bozo' false
	'foo*baz'	match: 'foo23baz' true
	'foo*baz'	match: 'foobaz' true
	'foo*baz'	match: 'foo23bazo' false
	'foo'		match: 'Foo' true
	'foo*baz*zort' match: 'foobazort' false
	'foo*baz*zort' match: 'foobazzort' false
	'*foo#zort'	match: 'afoo3zortthenfoo3zort' true
	'*foo*zort'	match: 'afoodezortorfoo3zort' true
"! !

!String methodsFor: 'comparing' stamp: 'di 2/27/98 12:19'!
sameAs: aString 
	"Answer whether the receiver sorts equal to aString. The 
	collation sequence is ascii with case differences ignored."

	^ (self compare: self with: aString collated: CaseInsensitiveOrder) = 2! !

!String methodsFor: 'comparing' stamp: 'di 11/19/1998 13:28'!
startingAt: keyStart match: text startingAt: textStart
	"Answer whether text matches the pattern in this string.
	Matching ignores upper/lower case differences.
	Where this string contains #, text may contain any character.
	Where this string contains *, text may contain any sequence of characters."
	| anyMatch matchStart matchEnd i matchStr j ii jj |
	i _ keyStart.
	j _ textStart.

	"Check for any #'s"
	[i > self size ifTrue: [^ j > text size "Empty key matches only empty string"].
	(self at: i) = $#] whileTrue:
		["# consumes one char of key and one char of text"
		j > text size ifTrue: [^ false "no more text"].
		i _ i+1.  j _ j+1].

	"Then check for *"
	(self at: i) = $*
		ifTrue: [i = self size ifTrue:
					[^ true "Terminal * matches all"].
				"* means next match string can occur anywhere"
				anyMatch _ true.
				matchStart _ i + 1]
		ifFalse: ["Otherwise match string must occur immediately"
				anyMatch _ false.
				matchStart _ i].

	"Now determine the match string"
	matchEnd _ self size.
	(ii _ self indexOf: $* startingAt: matchStart) > 0 ifTrue:
		[ii = 1 ifTrue: [self error: '** not valid -- use * instead'].
		matchEnd _ ii-1].
	(ii _ self indexOf: $# startingAt: matchStart) > 0 ifTrue:
		[ii = 1 ifTrue: [self error: '*# not valid -- use #* instead'].
		matchEnd _ matchEnd min: ii-1].
	matchStr _ self copyFrom: matchStart to: matchEnd.

	"Now look for the match string"
	[jj _ text findString: matchStr startingAt: j caseSensitive: false.
	anyMatch ifTrue: [jj > 0] ifFalse: [jj = j]]
		whileTrue:
		["Found matchStr at jj.  See if the rest matches..."
		(self startingAt: matchEnd+1 match: text startingAt: jj + matchStr size) ifTrue:
			[^ true "the rest matches -- success"].
		"The rest did not match."
		anyMatch ifFalse: [^ false].
		"Preceded by * -- try for a later match"
		j _ j+1].
	^ false "Failed to find the match string"! !


!String methodsFor: 'copying'!
copyReplaceTokens: oldSubstring with: newSubstring 
	"Replace all occurrences of oldSubstring that are surrounded
	by non-alphanumeric characters"
	^ self copyReplaceAll: oldSubstring with: newSubstring asTokens: true
	"'File asFile Files File''s File' copyReplaceTokens: 'File' with: 'Snick'"! !

!String methodsFor: 'copying'!
deepCopy
	"DeepCopy would otherwise mean make a copy of the character;  since 
	characters are unique, just return a shallowCopy."

	^self shallowCopy! !

!String methodsFor: 'copying' stamp: 'di 2/15/98 22:54'!
padded: leftOrRight to: length with: char
	leftOrRight = #left ifTrue:
		[^ (String new: (length - self size max: 0) withAll: char) , self].
	leftOrRight = #right ifTrue:
		[^ self , (String new: (length - self size max: 0) withAll: char)].! !


!String methodsFor: 'converting' stamp: 'di 11/9/1998 12:17'!
adaptToNumber: rcvr andSend: selector
	"If I am involved in arithmetic with a number, convert me to a number."

	^ rcvr perform: selector with: self asNumber! !

!String methodsFor: 'converting' stamp: 'di 11/6/1998 13:49'!
adaptToPoint: rcvr andSend: selector
	"If I am involved in arithmetic with a point, convert me to a number."

	^ rcvr perform: selector with: self asNumber! !

!String methodsFor: 'converting' stamp: 'jm 10/28/2007 19:28'!
allWordsCapitalized
	"Return a copy with the first letter of each word capitalized."

	| result wordStart ch |
	result _ self copy.
	wordStart _ true.
	1 to: self size do: [:i |
		ch _ self at: i.
		ch isSeparator
			ifTrue: [wordStart _ true]
			ifFalse: [
				wordStart ifTrue: [
					result at: i put: ch asUppercase.
					wordStart _ false]]].
	^ result
! !

!String methodsFor: 'converting' stamp: 'tk 1/24/98 11:22'!
asDate
	"Many allowed forms, see Date.readFrom:"
	^ Date readFrom: (ReadStream on: self)! !

!String methodsFor: 'converting'!
asDisplayText
	"Answer a DisplayText whose text string is the receiver."

	^DisplayText text: self asText! !

!String methodsFor: 'converting' stamp: 'sma 3/11/2000 17:25'!
asHtml
	"Do the basic character conversion for HTML.  Leave all original return 
	and tabs in place, so can conver back by simply removing bracked 
	things. 4/4/96 tk"
	| temp |
	temp _ self copyReplaceAll: '&' with: '&amp;'.
	HtmlEntities keysAndValuesDo:
		[:entity :char |
		char = $& ifFalse:
			[temp _ temp copyReplaceAll: char asString with: '&' , entity , ';']].
	temp _ temp copyReplaceAll: '	' with: '	<IMG SRC="tab.gif" ALT="    ">'.
	temp _ temp copyReplaceAll: '
' with: '
<BR>'.
	^ temp

"
	'A<&>B' asHtml
"! !

!String methodsFor: 'converting' stamp: 'sma 6/12/2000 11:40'!
asLowercase
	"Answer a String made up from the receiver whose characters are all 
	lowercase."

	^ self copy asString translateToLowercase! !

!String methodsFor: 'converting' stamp: 'jm 6/29/2008 11:09'!
asMacRoman
	"Squeak strings are encoded as MacRoman."

	^ self
! !

!String methodsFor: 'converting' stamp: 'jm 10/14/2002 19:04'!
asNumber 
	"Answer the Number created by interpreting the receiver as the string  representation of a number."

	^ Number readFrom: (ReadStream on: self)
! !

!String methodsFor: 'converting' stamp: 'jm 6/2/2009 12:12'!
asNumberNoError
	"Convert the given string to a number without giving errors about its format. Ignore non-digit characters and allow a leading '+', which kids sometimes type. Answer zero if empty."

	| s sign ch body |
	self size = 0 ifTrue: [^ 0].
	s _ ReadStream on: self.
	s skipSeparators.

	"read sign character, if any"
	sign _ 1.
	ch _ s peek.
	(ch = $+) | (ch = $-) ifTrue: [
		ch = $- ifTrue: [sign _ -1].
		s skip: 1].

	body _ WriteStream on: (String new: 40).
	body nextPut: $0.
	[s atEnd not and: [s peek isDigit]] whileTrue: [body nextPut: s next].  "read digits before decimal point"
	('.,' includes: s peek) ifTrue: [  "read decimal point (period or comma) and following digits, if any"
		s skip: 1.
		body nextPut: $..
		[s atEnd not and: [s peek isDigit]] whileTrue: [body nextPut: s next]].

	"read exponent"
	(s atEnd not and: ['eE' includes: s peek]) ifTrue: [
		s next.
		body nextPut: $e.
		(s atEnd not and: [s peek = $-]) ifTrue: [body nextPut: s next].		 "exponent sign"
		[s atEnd not and: [s peek isDigit]] whileTrue: [body nextPut: s next]].  "exponent"

	^ sign * (body contents asNumber)
! !

!String methodsFor: 'converting'!
asParagraph
	"Answer a Paragraph whose text string is the receiver."

	^Paragraph withText: self asText! !

!String methodsFor: 'converting' stamp: 'jm 5/14/1998 10:40'!
asString
	"Answer this string."

	^ self
! !

!String methodsFor: 'converting'!
asSymbol
	"Answer the unique Symbol whose characters are the characters of the 
	string."

	^Symbol intern: self! !

!String methodsFor: 'converting'!
asText
	"Answer a Text whose string is the receiver."

	^Text fromString: self! !

!String methodsFor: 'converting' stamp: 'jm 6/29/2008 10:31'!
asUTF32
	"Answer this string, assumed be encoded in MacRoman, encoded as UTF-32."

	^ (UTF8 fromMacRoman: self) asUTF32
! !

!String methodsFor: 'converting' stamp: 'jm 1/24/2008 11:45'!
asUTF8
	"Answer this string, assumed be encoded in MacRoman, encoded as UTF-8."

	^ UTF8 fromMacRoman: self
! !

!String methodsFor: 'converting' stamp: 'sma 6/12/2000 11:41'!
asUppercase
	"Answer a String made up from the receiver whose characters are all 
	uppercase."

	^ self collect: [:each | each asUppercase]! !

!String methodsFor: 'converting' stamp: 'jm 9/20/2007 10:40'!
asUrl
	"This escapes the tokens in the path in a URL. For example, in the path /shariables/read/tammy/high score, each of the parts between the slashes should be escaped. It is missing the carrot symbol, which converts to %5E."
	"'high score' asUrl"

	| temp |
	temp _ self copyReplaceAll: '%' with: '%20'.
	temp _ temp copyReplaceAll: ' ' with: '%20'.
	temp _ temp copyReplaceAll: '$' with: '%24'.
	temp _ temp copyReplaceAll: '&' with: '%26'.
	temp _ temp copyReplaceAll: '+' with: '%2B'.
	temp _ temp copyReplaceAll: ',' with: '%2C'.
	temp _ temp copyReplaceAll: '/' with: '%2F'.
	temp _ temp copyReplaceAll: ':' with: '%3A'.
	temp _ temp copyReplaceAll: ';' with: '%3B'.
	temp _ temp copyReplaceAll: '=' with: '%3D'.
	temp _ temp copyReplaceAll: '?' with: '%3F'.
	temp _ temp copyReplaceAll: '@' with: '%40'.
	temp _ temp copyReplaceAll: '<' with: '%3C'.
	temp _ temp copyReplaceAll: '>' with: '%3E'.
	temp _ temp copyReplaceAll: '"' with: '%22'.
	temp _ temp copyReplaceAll: '#' with: '%23'.
	temp _ temp copyReplaceAll: '{' with: '%7B'.
	temp _ temp copyReplaceAll: '}' with: '%7D'.	
	temp _ temp copyReplaceAll: '|' with: '%7C'.
	temp _ temp copyReplaceAll: '\' with: '%5C'.
	temp _ temp copyReplaceAll: '~' with: '%7E'.
	temp _ temp copyReplaceAll: '[' with: '%5B'.
	temp _ temp copyReplaceAll: ']' with: '%5D'.
	temp _ temp copyReplaceAll: '`' with: '%60'.
	^ temp
! !

!String methodsFor: 'converting' stamp: 'di 2/2/98 12:59'!
askIfAddStyle: priorMethod req: requestor
	^ self   "we are a string with no text style"! !

!String methodsFor: 'converting' stamp: 'ls 9/10/1998 08:48'!
capitalized
	"Return a copy with the first letter capitalized"
	| cap |
	self isEmpty ifTrue: [ ^self copy ].
	cap _ self copy.
	cap at: 1 put: (cap at: 1) asUppercase.
	^ cap! !

!String methodsFor: 'converting'!
compressWithTable: tokens
	"Return a string with all substrings that occur in tokens replaced
	by a character with ascii code = 127 + token index.
	This will work best if tokens are sorted by size.
	Assumes this string contains no characters > 127, or that they
	are intentionally there and will not interfere with this process."
	| str null finalSize start result ri c ts |
	null _ Character value: 0.
	str _ self copyFrom: 1 to: self size.  "Working string will get altered"
	finalSize _ str size.
	tokens doWithIndex:
		[:token :tIndex |
		start _ 1.
		[(start _ str findString: token startingAt: start) > 0]
			whileTrue:
			[ts _ token size.
			((start + ts) <= str size
				and: [(str at: start + ts) = $  and: [tIndex*2 <= 128]])
				ifTrue: [ts _ token size + 1.  "include training blank"
						str at: start put: (Character value: tIndex*2 + 127)]
				ifFalse: [str at: start put: (Character value: tIndex + 127)].
			str at: start put: (Character value: tIndex + 127).
			1 to: ts-1 do: [:i | str at: start+i put: null].
			finalSize _ finalSize - (ts - 1).
			start _ start + ts]].
	result _ String new: finalSize.
	ri _ 0.
	1 to: str size do:
		[:i | (c _ str at: i) = null ifFalse: [result at: (ri _ ri+1) put: c]].
	^ result! !

!String methodsFor: 'converting' stamp: 'di 1/16/98 16:33'!
contractTo: smallSize
	"return myself or a copy shortened by ellipsis to smallSize"
	| leftSize |
	self size <= smallSize
		ifTrue: [^ self].  "short enough"
	smallSize < 5
		ifTrue: [^ self copyFrom: 1 to: smallSize].    "First N characters"
	leftSize _ smallSize-2//2.
	^ self copyReplaceFrom: leftSize+1		"First N/2 ... last N/2"
		to: self size - (smallSize - leftSize - 3)
		with: '...'
"
	'A clear but rather long-winded summary' contractTo: 18
"! !

!String methodsFor: 'converting'!
correctAgainst: wordList
	"Correct the receiver: assume it is a misspelled word and return the (maximum of five) nearest words in the wordList.  Depends on the scoring scheme of alike:"
	| results |
	results _ self correctAgainst: wordList continuedFrom: nil.
	results _ self correctAgainst: nil continuedFrom: results.
	^ results! !

!String methodsFor: 'converting' stamp: 'jm 5/29/2003 18:55'!
correctAgainst: wordList continuedFrom: oldCollection
	"Like correctAgainst:.  Use when you want to correct against several lists, give nil as the first oldCollection, and nil as the last wordList."

	^ wordList isNil
		ifTrue: [self correctAgainstEnumerator: nil continuedFrom: oldCollection]
		ifFalse: [
			self correctAgainstEnumerator: [:action |
					wordList do: [:w | w ifNotNil: [action value: w]]]
				continuedFrom: oldCollection]
! !

!String methodsFor: 'converting'!
correctAgainstDictionary: wordDict continuedFrom: oldCollection
	"Like correctAgainst:continuedFrom:.  Use when you want to correct against a dictionary."

	^ wordDict isNil
		ifTrue: [ self correctAgainstEnumerator: nil
					continuedFrom: oldCollection ]
		ifFalse: [ self correctAgainstEnumerator: [ :action | wordDict keysDo: action ]
					continuedFrom: oldCollection ]! !

!String methodsFor: 'converting' stamp: 'ls 8/12/1998 23:31'!
encodeForHTTP
	"change dangerous characters to their %XX form, for use in HTTP transactions"
	| encodedStream |
	encodedStream _ WriteStream on: (String new).
	
	self do: [ :c |
		c isSafeForHTTP ifTrue: [ encodedStream nextPut: c ] ifFalse: [
			encodedStream nextPut: $%.
			encodedStream nextPut: (c asciiValue // 16) asHexDigit.
			encodedStream nextPut: (c asciiValue \\ 16) asHexDigit.
		]
	].
	^encodedStream contents. ! !

!String methodsFor: 'converting' stamp: 'bf 10/13/1999 09:26'!
findSelector
	"Dan's code for hunting down selectors with keyword parts; while this doesn't give a true parse, in most cases it does what we want, in where it doesn't, we're none the worse for it."
	| sel possibleParens level n |
	sel _ self withBlanksTrimmed.
	(sel includes: $:) ifTrue:
		[possibleParens _ sel findTokens: Character separators.
		sel _ String streamContents:
			[:s | level _ 0.
			possibleParens do:
				[:token |
				(level = 0 and: [token endsWith: ':'])
					ifTrue: [s nextPutAll: token]
					ifFalse: [(n _ token occurrencesOf: $( ) > 0 ifTrue: [level _ level + n].
							(n _ token occurrencesOf: $[ ) > 0 ifTrue: [level _ level + n].
							(n _ token occurrencesOf: $] ) > 0 ifTrue: [level _ level - n].
							(n _ token occurrencesOf: $) ) > 0 ifTrue: [level _ level - n]]]]].

	sel isEmpty ifTrue: [^ nil].
	Symbol hasInterned: sel ifTrue:
		[:aSymbol | ^ aSymbol].
	^ nil! !

!String methodsFor: 'converting' stamp: 'sw 8/20/1999 10:23'!
initialIntegerOrNil
	"Answer the integer represented by the leading digits of the receiver, or nil if the receiver does not begin with a digit"
	| firstNonDigit |
	(self size == 0 or: [self first isDigit not]) ifTrue: [^ nil].
	firstNonDigit _ (self findFirst: [:m | m isDigit not]).
	firstNonDigit = 0 ifTrue: [firstNonDigit _ self size + 1].
	^ (self copyFrom: 1  to: (firstNonDigit - 1)) asNumber
"
'234Whoopie' initialIntegerOrNil
'wimpy' initialIntegerOrNil
'234' initialIntegerOrNil
'2N' initialIntegerOrNil
'2' initialIntegerOrNil
'  89Ten ' initialIntegerOrNil
'78 92' initialIntegerOrNil
"
! !

!String methodsFor: 'converting' stamp: 'jm 9/18/2007 14:49'!
isoLatinToMac
	"Convert this string from ISO-Latin to MacRoman encoding."

	| toMacRoman result ch |
	toMacRoman _ #(173 176 226 196 227 201 160 224 246 228 178 220 206 179 182 183 184 212 213 210 211 165 208 209 247 170 185 221 207 186 189 217 202 193 162 163 219 180 195 164 172 169 187 199 194 197 168 248 161 177 198 215 171 181 166 225 252 218 188 200 222 223 240 192 203 231 229 204 128 129 174 130 233 131 230 232 237 234 235 236 245 132 241 238 239 205 133 249 175 244 242 243 134 250 251 167 136 135 137 139 138 140 190 141 143 142 144 145 147 146 148 149 253 150 152 151 153 155 154 214 191 157 156 158 159 254 255 216).
	result _ self copy.
	1 to: result size do: [:i |
		ch _ self basicAt: i.
		ch > 127 ifTrue: [result basicAt: i put: (toMacRoman at: ch - 127)]].
	^ result
! !

!String methodsFor: 'converting' stamp: 'ee 4/14/2008 15:25'!
localized
	"Answer myself translated into the current Scratch language. If there is no translation for me, then answer myself."

	| selfAsString |
	selfAsString _ self asString.
	ScratchTranslator addUITranslation: selfAsString.
	^ ScratchTranslator translationFor: selfAsString.
! !

!String methodsFor: 'converting' stamp: 'jm 10/22/2007 16:28'!
localizedMIDI
	"Answer myself translated into the current Scratch language. If there is no translation for me, then answer myself."

	ScratchTranslator addMIDITranslation: self.
	^ ScratchTranslator translationFor: self
! !

!String methodsFor: 'converting' stamp: 'jm 9/18/2007 14:50'!
macToISOLatin
	"Convert this string from MacRoman to ISO-Latin encoding."

	| toISOLatin result ch |
	toISOLatin _ #(196 197 199 201 209 214 220 225 224 226 228 227 229 231 233 232 234 235 237 236 238 239 241 243 242 244 246 245 250 249 251 252 134 176 162 163 167 149 182 223 174 169 153 180 168 128 198 216 129 177 138 141 165 181 142 143 144 154 157 170 186 158 230 248 191 161 172 166 131 173 178 171 187 133 160 192 195 213 140 156 150 151 147 148 145 146 247 179 255 159 185 164 139 155 188 189 135 183 130 132 137 194 202 193 203 200 205 206 207 204 211 212 190 210 218 219 217 208 136 152 175 215 221 222 184 240 253 254).
	result _ self copy.
	1 to: result size do: [:i |
		ch _ self basicAt: i.
		ch > 127 ifTrue: [result basicAt: i put: (toISOLatin at: ch - 127)]].
	^ result
! !

!String methodsFor: 'converting'!
sansPeriodSuffix
	"Return a copy of the receiver up to, but not including, the first period.  If the receiver's *first* character is a period, then just return the entire receiver. "

	| likely |
	likely _ self copyUpTo: $..
	^ likely size == 0
		ifTrue:	[self]
		ifFalse:	[likely]! !

!String methodsFor: 'converting' stamp: 'di 9/24/1999 12:31'!
splitInteger
	"Answer an array that is a splitting of self into a string and an integer.
	'43Sam' ==> #(43 'Sam').  'Try90' ==> #('Try' 90)
	BUT NOTE: 'Sam' ==> #('Sam' 0), and '90' ==> #('' 90)  ie, (<string> <integer>)."

	| pos |
	(pos _ self findFirst: [:d | d isDigit not]) == 0 ifTrue: [^ Array with: '' with: self asNumber].
	self first isDigit ifTrue: [
		^ Array with: (self copyFrom: 1 to: pos - 1) asNumber 
				with: (self copyFrom: pos to: self size)].
	(pos _ self findFirst: [:d | d isDigit]) == 0 ifTrue: [^ Array with: self with: 0].
	^ Array with: (self copyFrom: 1 to: pos - 1)
			with: (self copyFrom: pos to: self size) asNumber! !

!String methodsFor: 'converting' stamp: 'jm 6/12/2008 12:51'!
trailingDigits
	"Answer the trailing digits of a string such as 'foo123' If the string does not end in a digit, answer the empty string."
	"'foo123' trailingDigits"
	"'foo' trailingDigits"

	| i |
	i _ self size.
	[(i > 0) and: [(self at: i) isDigit]] whileTrue: [i _ i - 1].
	^ self copyFrom: i + 1 to: self size
! !

!String methodsFor: 'converting' stamp: 'ls 8/15/1998 10:31'!
translateFrom: start  to: stop  table: table
	"translate the characters in the string by the given table, in place"
	String translate: self  from: start to: stop table: table! !

!String methodsFor: 'converting' stamp: 'ls 8/18/1998 07:44'!
translateToLowercase
	"Translate all characters to lowercase, in place"

	self translateWith: LowercasingTable! !

!String methodsFor: 'converting' stamp: 'ls 8/15/1998 08:30'!
translateWith: table
	"translate the characters in the string by the given table, in place"
	^self translateFrom: 1 to: self size table: table! !

!String methodsFor: 'converting'!
truncateTo: smallSize
	"return myself or a copy shortened to smallSize.  1/18/96 sw"

	^ self size <= smallSize
		ifTrue:
			[self]
		ifFalse:
			[self copyFrom: 1 to: smallSize]! !

!String methodsFor: 'converting' stamp: 'sw 9/2/1998 17:09'!
truncateWithElipsisTo: maxLength
	"Return myself or a copy suitably shortened but with elipsis added"

	^ self size <= maxLength
		ifTrue:
			[self]
		ifFalse:
			[(self copyFrom: 1 to: (maxLength - 3)), '...']


	"'truncateWithElipsisTo:' truncateWithElipsisTo: 20"! !

!String methodsFor: 'converting' stamp: 'jm 5/14/1998 10:26'!
withBlanksTrimmed
	"Return a copy of the receiver from which leading and trailing blanks have been trimmed."

	| first |
	first _ self findFirst: [:c | c isSeparator not].
	first = 0 ifTrue: [^ ''].  "no non-separator character"
	^ self
		copyFrom: first
		to: (self findLast: [:c | c isSeparator not])

	" ' abc  d   ' withBlanksTrimmed"
! !

!String methodsFor: 'converting'!
withCRs
	"Return a copy of the receiver in which backslash (\) characters have been replaced with carriage returns."

	^ self collect: [ :c | c = $\ ifTrue: [ Character cr ] ifFalse: [ c ]].! !

!String methodsFor: 'converting' stamp: 'ls 8/20/1998 10:43'!
withSeparatorsCompacted
	"replace each sequences of whitespace by a single space character"
	| out pos textEnd |

	self isEmpty ifTrue: [ ^self ].

	out _ WriteStream on: (String new: self size).
	pos _ 1.   "current position in a scan through aString"


	"handle the case of initial separators"
	self first isSeparator ifTrue: [
		out nextPut: Character space.
		pos _ self indexOfAnyOf: CSNonSeparators ifAbsent: [ self size + 1 ] ].


	"central loop: handle a segment of text, followed possibly by a segment of whitespace"
	[ pos <= self size ] whileTrue: [ 
		"handle a segment of text..."

		textEnd _ self 
			indexOfAnyOf: CSSeparators
			startingAt: pos 
			ifAbsent: [ self size + 1 ].

		textEnd _ textEnd - 1.
		out nextPutAll: (self copyFrom: pos to: textEnd).
		pos _ textEnd + 1.

		pos <= self size ifTrue: [
			pos _ self 
				indexOfAnyOf: CSNonSeparators
				startingAt: pos
				ifAbsent: [ self size + 1 ].

			out nextPut: Character space  ] ].

	^out contents! !

!String methodsFor: 'converting' stamp: 'jm 6/10/2008 00:11'!
withoutLeadingBlanks
	"Return a copy of the receiver from which leading blanks have been trimmed."
	"' 	foo' withoutLeadingBlanks"

	| first |
	first _ self findFirst: [:c | c isSeparator not].
	first = 0 ifTrue: [^ ''].  "no non-separator character"
	^ self copyFrom: first to: self size
! !

!String methodsFor: 'converting' stamp: 'sw 1/8/1999 14:45'!
withoutLeadingDigits
	"Answer the portion of the receiver that follows any leading series of digits and blanks.  If the receiver consists entirely of digits and blanks, return an empty string"
	| firstNonDigit |
	firstNonDigit _ (self findFirst: [:m | m isDigit not and: [m ~~ $ ]]).
	^ firstNonDigit > 0
		ifTrue:
			[self copyFrom: firstNonDigit  to: self size]
		ifFalse:
			['']

"
'234Whoopie' withoutLeadingDigits
' 4321 BlastOff!!' withoutLeadingDigits
'wimpy' withoutLeadingDigits
'  89Ten ' withoutLeadingDigits
'78 92' withoutLeadingDigits
"
! !

!String methodsFor: 'converting' stamp: 'bf 11/24/1998 19:58'!
withoutTrailingBlanks
	"Return a copy of the receiver from which trailing blanks have been trimmed."

	| last |
	last _ self findLast: [:c | c isSeparator not].
	last = 0 ifTrue: [^ ''].  "no non-separator character"
	^ self copyFrom: 1 to: last

	" ' abc  d   ' withoutTrailingBlanks"
! !

!String methodsFor: 'converting'!
withoutTrailingDigits
	"Answer the portion of the receiver that precedes any trailing series of digits and blanks.  If the receiver consists entirely of digits and blanks, return an empty string"
	| firstDigit |
	firstDigit _ (self findFirst: [:m | m isDigit or: [m == $ ]]).
	^ firstDigit > 0
		ifTrue:
			[self copyFrom: 1   to: firstDigit-1]
		ifFalse:
			[self]

"
'Whoopie234' withoutTrailingDigits
' 4321 BlastOff!!' withoutLeadingDigits
'wimpy' withoutLeadingDigits
'  89Ten ' withoutLeadingDigits
'78 92' withoutLeadingDigits
"
! !


!String methodsFor: 'displaying' stamp: 'jm 5/30/2003 13:17'!
display
	"Display the receiver on the Display."

	self displayOn: Display at: 0@0.
! !

!String methodsFor: 'displaying' stamp: 'jm 5/25/2003 11:58'!
displayAt: aPoint 
	"Display the receiver at the given point."

	self displayOn: Display at: aPoint.
! !

!String methodsFor: 'displaying' stamp: 'jm 5/25/2003 11:57'!
displayOn: aForm
	"Display the receiver on the given Form."

	self displayOn: aForm at: 0@0.
! !

!String methodsFor: 'displaying' stamp: 'jm 5/25/2003 12:00'!
displayOn: aForm at: aPoint 
	"Display myself at the given point on the given Form."

	(self asDisplayText
		foregroundColor: Color black
		backgroundColor: Color white)
			displayOn: aForm at: aPoint.
! !

!String methodsFor: 'printing'!
isLiteral

	^true! !

!String methodsFor: 'printing' stamp: 'sma 6/1/2000 09:48'!
printOn: aStream 
	"Print inside string quotes, doubling inbedded quotes."

	self storeOn: aStream! !

!String methodsFor: 'printing'!
storeOn: aStream 
	"Print inside string quotes, doubling inbedded quotes."
	| x |
	aStream nextPut: $'.
	1 to: self size do:
		[:i |
		aStream nextPut: (x _ self at: i).
		x == $' ifTrue: [aStream nextPut: x]].
	aStream nextPut: $'! !


!String methodsFor: 'internet' stamp: 'sma 3/11/2000 20:40'!
isoToSqueak
	^ self collect: [:each | each isoToSqueak]! !

!String methodsFor: 'internet' stamp: 'jm 10/20/2004 12:27'!
replaceHtmlCharRefs

	| outString outPos pos ampIndex newOutPos scIndex special specialValue |
	outString _ String new: self size.
	outPos _ 0.
	pos _ 1.
	[pos <= self size] whileTrue: [
		"read up to the next ampersand"
		ampIndex _ self indexOf: $& startingAt: pos ifAbsent: [0].
		ampIndex = 0 ifTrue: [
			pos = 1 ifTrue: [^ self] ifFalse: [ampIndex _ self size + 1]].

		newOutPos _ outPos + ampIndex - pos.
		outString
			replaceFrom: outPos + 1
			to: newOutPos
			with: self
			startingAt: pos.
		outPos _ newOutPos.
		pos _ ampIndex.

		ampIndex <= self size ifTrue: [
			"find the $;"
			scIndex _ self indexOf: $; startingAt: ampIndex ifAbsent: [self size + 1].
			special _ self copyFrom: ampIndex + 1 to: scIndex - 1.
			specialValue _ String valueOfHtmlEntity: special.
			specialValue
				ifNil: [
					"not a recognized entity. wite it back"
					scIndex > self size ifTrue: [scIndex _ self size].
					newOutPos _ outPos + scIndex - ampIndex + 1.
					outString
						replaceFrom: outPos+1
						to: newOutPos
						with: self
						startingAt: ampIndex.
					outPos _ newOutPos]
				ifNotNil: [
					outPos _ outPos + 1.
					outString at: outPos put: specialValue].
			pos _ scIndex + 1]].
	^ outString copyFrom: 1 to: outPos
! !

!String methodsFor: 'internet' stamp: 'jm 5/17/2005 20:38'!
replaceHtmlHexChars
	"Replace embedded hex characters such as '%20' (a space character) in a string formatted for HTML."

	| in out ch d1 d2 |
	in _ ReadStream on: self.
	out _ WriteStream on: (String new: self size).
	[in atEnd] whileFalse: [
		ch _ in next.
		((ch = $%) and: [in position + 2 <= self size]) ifTrue: [
			d1 _ in next digitValue.
			d2 _ in next digitValue.
			((d1 >= 0) & (d1 <= 15) & (d2 >= 0) & (d2 <= 15))
				ifTrue: [ch _ ((d1 * 16) + d2) asCharacter]
				ifFalse: [in skip: -2]].
		out nextPut: ch].
	^ out contents

! !

!String methodsFor: 'internet' stamp: 'ls 10/27/1998 00:52'!
withSqueakLineEndings
	"assume the string is textual, and that CR, LF, and CRLF are all 
	valid line endings.  Replace each occurence with a single CR"
	| cr lf input c crlf inPos outPos outString lineEndPos newOutPos |
	cr _ Character cr.
	lf _ Character linefeed.
	crlf _ CharacterSet new.
	crlf add: cr; add: lf.

	inPos _ 1.
	outPos _ 1.
	outString _
 String new: self size.

	[ lineEndPos _ self indexOfAnyOf: crlf startingAt: inPos ifAbsent: [0].
		lineEndPos ~= 0 ] whileTrue: [
			newOutPos _ outPos + (lineEndPos - inPos + 1).
			outString replaceFrom: outPos to: newOutPos - 2 with: self startingAt: inPos.
			outString at: newOutPos-1 put: cr.
			outPos _ newOutPos.

			((self at: lineEndPos) = cr and: [ lineEndPos < self size and: [ (self at: lineEndPos+1) = lf ] ]) ifTrue: [
				"CRLF ending"
				inPos _ lineEndPos + 2 ]
			ifFalse: [ 
				"CR or LF ending"
				inPos _ lineEndPos + 1 ]. ].

	"no more line endings.  copy the rest"
	newOutPos _ outPos + (self size - inPos + 1).
	outString replaceFrom: outPos to: newOutPos-1 with: self startingAt: inPos.

	^outString copyFrom: 1 to: newOutPos-1
	! !


!String methodsFor: 'testing' stamp: 'sw 11/5/1998 17:41'!
lastSpacePosition
	"Answer the character position of the final space or other separator character in the receiver, and 0 if none"
	self size to: 1 by: -1 do:
		[:i | ((self at: i) isSeparator) ifTrue: [^ i]].
	^ 0

"
'fred the bear' lastSpacePosition
'ziggie' lastSpacePosition
'elvis ' lastSpacePosition
'wimpy  ' lastSpacePosition
'' lastSpacePosition
"! !


!String methodsFor: 'paragraph support' stamp: 'RAA 8/30/1998 15:20'!
indentationIfBlank: aBlock
	"Answer the number of leading tabs in the receiver.  If there are
	 no visible characters, pass the number of tabs to aBlock and return its value."

	| reader leadingTabs lastSeparator cr tab ch |
	cr _ Character cr.
	tab _ Character tab.
	reader _ ReadStream on: self.
	leadingTabs _ 0.
	[reader atEnd not and: [(ch _ reader next) == tab]]
		whileTrue: [leadingTabs _ leadingTabs + 1].
	lastSeparator _ leadingTabs + 1.
	[reader atEnd not and: [ch isSeparator and: [ch ~~ cr]]]
		whileTrue: [lastSeparator _ lastSeparator + 1. ch _ reader next].
	lastSeparator = self size | (ch == cr)
		ifTrue: [^aBlock value: leadingTabs].
	^leadingTabs! !


!String methodsFor: 'system primitives' stamp: 'jm 2/15/98 18:07'!
compare: string1 with: string2 collated: order
	"Return 1, 2 or 3, if string1 is <, =, or > string2, with the collating order of characters given by the order array."

	| len1 len2 c1 c2 |
	<primitive: 235>
	self var: #string1 declareC: 'unsigned char *string1'.
	self var: #string2 declareC: 'unsigned char *string2'.
	self var: #order declareC: 'unsigned char *order'.

	len1 _ string1 size.
	len2 _ string2 size.
	1 to: (len1 min: len2) do:
		[:i |
		c1 _ order at: (string1 basicAt: i) + 1.
		c2 _ order at: (string2 basicAt: i) + 1.
		c1 = c2 ifFalse: 
			[c1 < c2 ifTrue: [^ 1] ifFalse: [^ 3]]].
	len1 = len2 ifTrue: [^ 2].
	len1 < len2 ifTrue: [^ 1] ifFalse: [^ 3].
! !

!String methodsFor: 'system primitives' stamp: 'di 11/15/1998 16:27'!
findSubstring: key in: body startingAt: start matchTable: matchTable
	"Answer the index in the string body at which the substring key first occurs, at or beyond start.  The match is determined using matchTable, which can be used to effect, eg, case-insensitive matches.  If no match is found, zero will be returned.

	The algorithm below is not optimum -- it is intended to be translated to C which will go so fast that it wont matter."
	| index |
	<primitive: 246>
	self var: #key declareC: 'unsigned char *key'.
	self var: #body declareC: 'unsigned char *body'.
	self var: #matchTable declareC: 'unsigned char *matchTable'.

	key size = 0 ifTrue: [^ 0].
	start to: body size - key size + 1 do:
		[:startIndex |
		index _ 1.
			[(matchTable at: (body at: startIndex+index-1) asciiValue + 1)
				= (matchTable at: (key at: index) asciiValue + 1)]
				whileTrue:
				[index = key size ifTrue: [^ startIndex].
				index _ index+1]].
	^ 0
"
' ' findSubstring: 'abc' in: 'abcdefabcd' startingAt: 1 matchTable: CaseSensitiveOrder 1
' ' findSubstring: 'abc' in: 'abcdefabcd' startingAt: 2 matchTable: CaseSensitiveOrder 7
' ' findSubstring: 'abc' in: 'abcdefabcd' startingAt: 8 matchTable: CaseSensitiveOrder 0
' ' findSubstring: 'abc' in: 'abcdefABcd' startingAt: 2 matchTable: CaseSensitiveOrder 0
' ' findSubstring: 'abc' in: 'abcdefABcd' startingAt: 2 matchTable: CaseInsensitiveOrder 7
"! !

!String methodsFor: 'system primitives' stamp: 'di 4/3/1999 00:37'!
numArgs
	"Answer either the number of arguments that the receiver would take if considered a selector.  Answer -1 if it couldn't be a selector.  Note that currently this will answer -1 for anything begining with an uppercase letter even though the system will accept such symbols as selectors.  It is intended mostly for the assistance of spelling correction."

	| firstChar numColons |
	firstChar _ self at: 1.
	firstChar isLetter ifTrue:
		[ firstChar isUppercase ifTrue: [ ^ -1 ].
		numColons _ 0. 
		self do: [ :ch |
			ch tokenish ifFalse: [ ^ -1 ].
			(ch = $:) ifTrue: [numColons _ numColons + 1] ].
		^ (self last = $:)
			ifTrue: [ numColons > 0 ifTrue: [ numColons ] ifFalse: [ -1 ] ]
			ifFalse: [ numColons > 0 ifTrue: [ -1 ] ifFalse: [ 0 ] ] ].
	firstChar isSpecial ifTrue:
		[self size = 1 ifTrue: [^ 1].
		2 to: self size do: [:i | (self at: i) isSpecial ifFalse: [^ -1]].
		^ 1].
	^ -1.! !


!String methodsFor: 'private'!
replaceFrom: start to: stop with: replacement startingAt: repStart 
	"Primitive. This destructively replaces elements from start to stop in the receiver starting at index, repStart, in the collection, replacement. Answer the receiver. Range checks are performed in the primitive only. Optional. See Object documentation whatIsAPrimitive."
	<primitive: 105>
	super replaceFrom: start to: stop with: replacement startingAt: repStart! !

!String methodsFor: 'private'!
stringhash
	^self hash! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

String class
	instanceVariableNames: ''!

!String class methodsFor: 'instance creation' stamp: 'jm 5/6/1998 18:39'!
cr
	"Answer a string containing a single carriage return character."

	^ self with: Character cr
! !

!String class methodsFor: 'instance creation' stamp: 'ls 9/10/1998 22:29'!
crlf
	"Answer a string containing a carriage return and a linefeed."

	^ self with: Character cr with: Character lf
! !

!String class methodsFor: 'instance creation' stamp: 'jm 6/27/2008 13:23'!
fromBytes: aCollection
	"Answer a new String containing the given sequence of bytes."
	"self fromBytes: (65 to: 70)"

	| s i |
	s _ self new: aCollection size.
	i _ 0.
	aCollection do: [:byte | s basicAt: (i _ i + 1) put: byte].
	^ s
! !

!String class methodsFor: 'instance creation' stamp: 'di 1/14/98 10:26'!
fromString: aString 
	"Answer an instance of me that is a copy of the argument, aString."
	
	^ aString copyFrom: 1 to: aString size! !

!String class methodsFor: 'instance creation'!
readFrom: inStream
	"Answer an instance of me that is determined by reading the stream, 
	inStream. Embedded double quotes become the quote Character."

	| outStream char done |
	outStream _ WriteStream on: (String new: 16).
	"go to first quote"
	inStream skipTo: $'.
	done _ false.
	[done or: [inStream atEnd]]
		whileFalse: 
			[char _ inStream next.
			char = $'
				ifTrue: 
					[char _ inStream next.
					char = $'
						ifTrue: [outStream nextPut: char]
						ifFalse: [done _ true]]
				ifFalse: [outStream nextPut: char]].
	^outStream contents! !

!String class methodsFor: 'instance creation' stamp: 'sw 6/15/1999 22:59'!
tab
	"Answer a string containing a single tab character."

	^ self with: Character tab
! !


!String class methodsFor: 'initialization' stamp: 'di 9/20/1998 14:09'!
initialize  "String initialize"
	| order |
	AsciiOrder _ (0 to: 255) as: ByteArray.

	CaseInsensitiveOrder _ AsciiOrder copy.
	($a to: $z) do:
		[:c | CaseInsensitiveOrder at: c asciiValue + 1
				put: (CaseInsensitiveOrder at: c asUppercase asciiValue +1)].

	"Case-sensitive compare sorts space, digits, letters, all the rest..."
	CaseSensitiveOrder _ ByteArray new: 256 withAll: 255.
	order _ -1.
	' 0123456789' do:  "0..10"
		[:c | CaseSensitiveOrder at: c asciiValue + 1 put: (order _ order+1)].
	($a to: $z) do:     "11-64"
		[:c | CaseSensitiveOrder at: c asUppercase asciiValue + 1 put: (order _ order+1).
		CaseSensitiveOrder at: c asciiValue + 1 put: (order _ order+1)].
	1 to: CaseSensitiveOrder size do:
		[:i | (CaseSensitiveOrder at: i) = 255 ifTrue:
			[CaseSensitiveOrder at: i put: (order _ order+1)]].
	order = 255 ifFalse: [self error: 'order problem'].

	"a table for translating to lower case"
	LowercasingTable _ String new: 256.
	Character allCharacters do: [ :c |
		LowercasingTable at: (c asciiValue+1) put: c asLowercase ].	

	"CR and LF--characters that terminate a line"
	CSLineEnders _ CharacterSet empty.
	CSLineEnders add: Character cr.
	CSLineEnders add: Character lf.

 	"separators and non-separators"
	CSSeparators _ CharacterSet separators.
	CSNonSeparators _ CSSeparators complement.! !

!String class methodsFor: 'initialization' stamp: 'jm 5/24/2003 13:52'!
initializeHtmlEntities
	"String initializeHtmlEntities"

	HtmlEntities _ (Dictionary new: 128)
		at: 'amp'	put: $&;
		at: 'lt'		put: $<;
		at: 'gt'		put: $>;
		at: 'quot'	put: $";
		at: 'euro'	put: (Character value: 219);
		yourself.

	#('nbsp' 'iexcl' 'cent' 'pound' 'curren' 'yen' 'brvbar' 'sect' 'uml' 'copy' 'ordf' 'laquo' 'not' 'shy' 'reg' 'hibar' 'deg' 'plusmn' 'sup2' 'sup3' 'acute' 'micro' 'para' 'middot' 'cedil' 'sup1' 'ordm' 'raquo' 'frac14' 'frac12' 'frac34' 'iquest' 'Agrave' 'Aacute' 'Acirc' 'Atilde' 'Auml' 'Aring' 'AElig' 'Ccedil' 'Egrave' 'Eacute' 'Ecirc' 'Euml' 'Igrave' 'Iacute' 'Icirc' 'Iuml' 'ETH' 'Ntilde' 'Ograve' 'Oacute' 'Ocirc' 'Otilde' 'Ouml' 'times' 'Oslash' 'Ugrave' 'Uacute' 'Ucirc' 'Uuml' 'Yacute' 'THORN' 'szlig' 'agrave' 'aacute' 'acirc' 'atilde' 'auml' 'aring' 'aelig' 'ccedil' 'egrave' 'eacute' 'ecirc' 'euml' 'igrave' 'iacute' 'icirc' 'iuml' 'eth' 'ntilde' 'ograve' 'oacute' 'ocirc' 'otilde' 'ouml' 'divide' 'oslash' 'ugrave' 'uacute' 'ucirc' 'uuml' 'yacute' 'thorn' 'yuml' ) withIndexDo: [:each :index | HtmlEntities at: each put: (index + 159) asCharacter isoToSqueak]! !


!String class methodsFor: 'primitives' stamp: 'ls 9/14/1998 07:50'!
findFirstInString: aString  inSet: inclusionMap  startingAt: start
	| i stringSize |
	<primitive: 244>

	self var: #aString declareC: 'unsigned char *aString'.
	self var: #inclusionMap  declareC: 'char *inclusionMap'.

	inclusionMap size ~= 256 ifTrue: [ ^0 ].

	i _ start.
	stringSize _ aString size.
	[ i <= stringSize and: [ (inclusionMap at: (aString at: i) asciiValue+1) = 0 ] ] whileTrue: [ 
		i _ i + 1 ].

	i > stringSize ifTrue: [ ^0 ].
	^i! !

!String class methodsFor: 'primitives' stamp: 'jm 10/12/1998 18:21'!
indexOfAscii: anInteger inString: aString startingAt: start

	| stringSize |
	<primitive: 245>

	self var: #aCharacter declareC: 'int anInteger'.
	self var: #aString declareC: 'unsigned char *aString'.

	stringSize _ aString size.
	start to: stringSize do: [:pos |
		(aString at: pos) asciiValue = anInteger ifTrue: [^ pos]].

	^ 0
! !

!String class methodsFor: 'primitives' stamp: 'ls 8/15/1998 12:15'!
translate: aString from: start  to: stop  table: table
	"translate the characters in the string by the given table, in place"
	<primitive: 243>
	self var: #table  declareC: 'unsigned char *table'.
	self var: #aString  declareC: 'unsigned char *aString'.

	start to: stop do: [ :i |
		aString at: i put: (table at: (aString at: i) asciiValue+1) ]! !


!String class methodsFor: 'internet' stamp: 'sma 3/11/2000 20:25'!
valueOfHtmlEntity: specialEntity 
	"Please note: the 'min: 255' is a crude fix to silently ignore unicode characters."

	(specialEntity beginsWith: '#')
		ifTrue:
			[^ ((specialEntity
				copyFrom: 2
				to: specialEntity size) asNumber min: 255) asCharacter isoToSqueak].
	^ HtmlEntities at: specialEntity ifAbsent: [nil]! !


String variableByteSubclass: #Symbol
	instanceVariableNames: ''
	classVariableNames: 'OtherTable SelectorTables SingleCharSymbols '
	poolDictionaries: ''
	category: 'Collections-Text'!
!Symbol commentStamp: '<historical>' prior: 0!
I represent Strings that are created uniquely. Thus, someString asSymbol == someString asSymbol.!


!Symbol methodsFor: 'accessing'!
at: anInteger put: anObject 
	"You cannot modify the receiver."

	self errorNoModification! !

!Symbol methodsFor: 'accessing' stamp: 'sma 2/5/2000 12:32'!
precedence
	"Answer the receiver's precedence, assuming it is a valid Smalltalk
	message selector or 0 otherwise.  The numbers are 1 for unary,
	2 for binary and 3 for keyword selectors."

	self size = 0 ifTrue: [^ 0].
	self first isLetter ifFalse: [^ 2].
	self last = $: ifTrue: [^ 3].
	^ 1! !

!Symbol methodsFor: 'accessing'!
replaceFrom: start to: stop with: replacement startingAt: repStart

	self errorNoModification! !


!Symbol methodsFor: 'comparing' stamp: 'di 4/11/2000 16:18'!
= another

	"Use == between two symbols..."
	self == another ifTrue: [^ true].  "Was == "
	another class == Symbol ifTrue: [^ false].  "Was not == "

	"Otherwise use string =..."
	^ super = another! !

!Symbol methodsFor: 'comparing'!
hash
	"Primitive. Answer with a SmallInteger whose value is half of the
	receiver's object pointer (interpreting object pointers as 16-bit signed
	quantities). Essential. See Object documentation whatIsAPrimitive."

	<primitive: 75>
	^self! !


!Symbol methodsFor: 'copying' stamp: 'tk 6/26/1998 11:35'!
clone
	"Answer with the receiver, because Symbols are unique."! !

!Symbol methodsFor: 'copying'!
copy
	"Answer with the receiver, because Symbols are unique."! !

!Symbol methodsFor: 'copying'!
shallowCopy
	"Answer with the receiver, because Symbols are unique."! !


!Symbol methodsFor: 'converting'!
asString 
	"Refer to the comment in String|asString."

	| newString |
	newString _ String new: self size.
	1 to: self size do: [:index | newString at: index put: (self at: index)].
	^newString! !

!Symbol methodsFor: 'converting'!
asSymbol 
	"Refer to the comment in String|asSymbol."! !

!Symbol methodsFor: 'converting' stamp: 'sw 1/28/98 18:18'!
capitalized
	^ self asString capitalized asSymbol! !


!Symbol methodsFor: 'printing' stamp: 'di 4/25/2000 12:32'!
storeOn: aStream 

	aStream nextPut: $#.
	(Scanner isLiteralSymbol: self)
		ifTrue: [aStream nextPutAll: self]
		ifFalse: [super storeOn: aStream]! !


!Symbol methodsFor: 'system primitives' stamp: 'di 1/2/1999 17:00'!
flushCache
	"Tell the interpreter to remove all entries with this symbol as a selector from its method lookup cache, if it has one.  This primitive must be called whenever a method is defined or removed.
	NOTE:  Only one of the two selective flush methods needs to be used.
	Squeak 2.3 and later uses 116 (See CompiledMethod flushCache)."

	<primitive: 119>
! !


!Symbol methodsFor: 'private'!
errorNoModification

	self error: 'symbols can not be modified.'! !

!Symbol methodsFor: 'private'!
species

	^String! !

!Symbol methodsFor: 'private'!
string: aString

	1 to: aString size do: [:j | super at: j put: (aString at: j)].
	^self  ! !

!Symbol methodsFor: 'private'!
stringhash

	^super hash! !


!Symbol methodsFor: 'testing' stamp: 'sma 2/5/2000 12:32'!
isInfix
	"Answer whether the receiver is an infix message selector."

	^ self precedence == 2! !

!Symbol methodsFor: 'testing' stamp: 'sma 2/5/2000 12:34'!
isKeyword
	"Answer whether the receiver is a message keyword."

	^ self precedence == 3! !

!Symbol methodsFor: 'testing' stamp: 'di 4/25/2000 12:32'!
isLiteral
	"Answer whether the receiver is a valid Smalltalk literal."

	^ true! !

!Symbol methodsFor: 'testing' stamp: 'sma 2/5/2000 12:13'!
isPvtSelector
	"Answer whether the receiver is a private message selector, that is,
	begins with 'pvt' followed by an uppercase letter, e.g. pvtStringhash."

	^ (self beginsWith: 'pvt') and: [self size >= 4 and: [(self at: 4) isUppercase]]! !

!Symbol methodsFor: 'testing' stamp: 'sma 2/5/2000 12:34'!
isUnary
	"Answer whether the receiver is an unary message selector."

	^ self precedence == 1! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Symbol class
	instanceVariableNames: ''!

!Symbol class methodsFor: 'class initialization'!
initialize

	| a v |
	"make up table of 1-char atoms"
	v _ Array new: 128.
	a _ String new: 1.
	1 to: 128 do: 
		[:i | 
		a at: 1 put: i - 1.
		v at: i put: a asSymbol].
	SingleCharSymbols _ v
	
	"Symbol initialize"! !


!Symbol class methodsFor: 'instance creation' stamp: 'sma 2/26/2000 20:17'!
intern: aString 
	"Answer a unique Symbol whose characters are those of aString."

	| ascii table mainTable index sym numArgs symbol lastNilIndex |

	aString size = 0
		ifTrue: [ascii _ 0]
		ifFalse:
			[ascii _ (aString at: 1) asciiValue.
			aString size = 1 ifTrue: [ascii < 128 ifTrue: 
				[^ SingleCharSymbols at: ascii + 1]]].

	table _ ((ascii >= "$a asciiValue" 97) and:
		[(ascii <= "$z asciiValue" 122) and:
		[(numArgs _ aString numArgs) >= 0]])
			ifTrue: [(mainTable _ SelectorTables
									at: (numArgs + 1 min: SelectorTables size))
						at: (index _ ascii - "($a asciiValue - 1)" 96)]
			ifFalse: [(mainTable _ OtherTable)
						at: (index _ aString stringhash \\ OtherTable size + 1)].

	1 to: table size do: [:i |
		symbol _ table at: i.
		symbol isNil 
			ifTrue:[lastNilIndex _ i]
			ifFalse:[(aString size = symbol size and:[aString = symbol])
						ifTrue:[^symbol]]
	].

	sym _ (aString isMemberOf: Symbol)
		ifTrue: [aString]	"putting old symbol in new table"
		ifFalse: [(Symbol new: aString size) string: aString]. "create a new one"

	lastNilIndex isNil
		ifTrue:[mainTable at: index put: (table copyWith: sym)]
		ifFalse:[table at: lastNilIndex put: sym].
	^sym
! !

!Symbol class methodsFor: 'instance creation'!
internCharacter: aCharacter
	"Answer a unique Symbol of one character, the argument, aCharacter."

	| ascii |
	(ascii _ aCharacter asciiValue) < 128
		ifTrue: [^SingleCharSymbols at: ascii + 1].
	^self intern: (String with: aCharacter)! !

!Symbol class methodsFor: 'instance creation'!
newFrom: aCollection 
	"Answer an instance of me containing the same elements as aCollection."

	^ (aCollection as: String) asSymbol

"	Symbol newFrom: {$P. $e. $n}
	{$P. $e. $n} as: Symbol
"! !

!Symbol class methodsFor: 'instance creation' stamp: 'di 10/11/1999 00:02'!
readFrom: strm  "Symbol readFromString: '#abc'"

	strm peek = $# ifFalse: [self error: 'Symbols must be introduced by #'].
	^ (Scanner new scan: strm) advance  "Just do what the code scanner does"! !

!Symbol class methodsFor: 'private' stamp: 'ar 5/1/1999 04:56'!
hasInterned: aString ifTrue: symBlock 
	"Answer with false if aString hasnt been interned (into a Symbol), 
	otherwise supply the symbol to symBlock and return true."

	| table ascii numArgs symbol |

	ascii _ (aString at: 1) asciiValue.
	aString size = 1 ifTrue: [ascii < 128 ifTrue: 
		[symBlock value: (SingleCharSymbols at: ascii + 1).
		^true]].

	table _ ((ascii >= "$a asciiValue" 97) and:
		[(ascii <= "$z asciiValue" 122) and:
		[(numArgs _ aString numArgs) >= 0]])
			ifTrue: [(SelectorTables at: (numArgs + 1 min: SelectorTables size))
						at: ascii - "($a asciiValue - 1)" 96]
			ifFalse: [OtherTable at: aString stringhash \\ OtherTable size + 1].

	1 to: table size do: [:i | 
		symbol _ table at: i.
		(symbol notNil and:[aString size = symbol size and: [aString = symbol]]) ifTrue: [
			symBlock value: symbol.
			^true]
	].
	^false! !


!Symbol class methodsFor: 'access' stamp: 'tk 2/11/2000 21:16'!
otherThatStarts: leadingCharacters skipping: skipSym
	"Answer a selector symbol with leadingCharacters that 
		starts with an uppercase letter. Ignore case in aKeyword.
	If skipSym is not nil, it is a previous answer; start searching after it.
	If no symbols are found, answer nil.
	Used by Alt-q (Command-q) routines."

	| key size table candidate ii skip |
	key _ leadingCharacters asLowercase.
	size _ key size.
	skip _ skipSym ~~ nil.
	(1 to: OtherTable size) do:
		[:jj |
		table _ OtherTable at: jj.
		1 to: table size do: 
			[:tt | 
			((candidate _ table at: tt) == nil or:
					[skip and: [skip _ candidate ~~ skipSym. true]]) ifFalse:
				[candidate size >= size ifTrue:
					[ii _ size. "test last character first"
					 [ii > 0 and: [(candidate at: ii) asLowercase == (key at: ii)]]
						whileTrue: [ii _ ii - 1].
					 ii = 0 ifTrue: [^candidate]]]]].
	^nil

"Symbol otherThatStarts: 'morph' skipping: nil"
"Symbol otherThatStarts: 'morph' skipping: #'Morphic-Support'"
"Symbol otherThatStarts: 'rect' skipping: #'rectangle functions'"
! !

!Symbol class methodsFor: 'access' stamp: 'tk 8/11/1998 22:12'!
possibleSelectorsFor: misspelled
	"Answer an ordered collection of possible corrections for the misspelled selector in order of likelyhood."

	| numArgs table lookupString list binary |
	lookupString _ misspelled asLowercase. "correct uppercase selectors to lowercase"
	numArgs _ lookupString numArgs.
	numArgs < 0 ifTrue: [ ^ OrderedCollection new: 0 ].
	table _ (SelectorTables at: (numArgs + 1 min: SelectorTables size))
				at: (lookupString at: 1) asciiValue - "($a asciiValue - 1)" 96.
	list _ lookupString correctAgainst: table.
	((misspelled last ~~ $:) and: [misspelled size > 1]) ifTrue: [
		binary _ misspelled, ':'.		"try for missing colon"
		Symbol hasInterned: binary ifTrue: [:him | list addFirst: him]].
	^ list! !

!Symbol class methodsFor: 'access' stamp: 'bf 10/13/1999 09:57'!
selectorsContaining: aString
	"Answer a list of selectors that contain aString within them.  Case-insensitive."
	| size table candidate selectorList selectorTable ascii |

	selectorList _ OrderedCollection new.
	(size _ aString size) = 0 ifTrue: [^ selectorList].

	aString size = 1 ifTrue:
		[ascii _ aString first asciiValue.
		ascii < 128 ifTrue:
			[selectorList add: (SingleCharSymbols at: ascii + 1)]].
	aString first isLetter ifFalse: [
		aString size == 2 ifTrue: 
			[Symbol hasInterned: aString ifTrue: [:s | selectorList add: s]].
		^ selectorList].
	(SelectorTables size to: 1 by: -1) do:
		[:j | selectorTable _ SelectorTables at: j.
		1 to: 26 do: [:index |
		table _ selectorTable at: index.
		1 to: table size do: 
			[:t | 
			((candidate _ table at: t) == nil) ifFalse:
				[candidate size >= size ifTrue:
					[((candidate findString: aString startingAt: 1 caseSensitive: false) > 0) ifTrue:
							[selectorList add: candidate]]]]]].
	^ selectorList

"Symbol selectorsContaining: 'scon' "! !

!Symbol class methodsFor: 'access' stamp: 'tk 2/11/2000 21:30'!
thatStarts: leadingCharacters skipping: skipSym
	"Answer a selector symbol that starts with leadingCharacters.
	Symbols beginning with a lower-case letter handled directly here.
	Ignore case after first char.
	If skipSym is not nil, it is a previous answer; start searching after it.
	If no symbols are found, answer nil.
	Used by Alt-q (Command-q) routines."

	| key size index table candidate i skip firstTable |
	key _ leadingCharacters asLowercase.
	index _ key first asciiValue - "($a asciiValue - 1)" 96.
	((index >= 1) and:
		[(index <= 26) and:
		[leadingCharacters numArgs >= 0]])
			ifFalse: [^ self otherThatStarts: leadingCharacters skipping: skipSym].
	size _ key size.
	skip _ skipSym ~~ nil.
	firstTable _ skip
		ifTrue: [skipSym numArgs + 1 min: SelectorTables size] "can't be in a later table"
		ifFalse: [SelectorTables size]. "could be in any table; favor longer identifiers"
	(firstTable to: 1 by: -1) do:
		[:j |
		table _ (SelectorTables at: j) at: index.
		1 to: table size do: 
			[:t | 
			((candidate _ table at: t) == nil or:
					[skip and: [skip _ candidate ~~ skipSym. true]]) ifFalse:
				[candidate size >= size ifTrue:
					[i _ size. "test last character first"
					 [i > 1 and: [(candidate at: i) asLowercase == (key at: i)]]
						whileTrue: [i _ i - 1].
					 i = 1 ifTrue: "don't need to compare first character"
						[^candidate]]]]].
	^nil

"Symbol thatStarts: 'sf' skipping: nil"
"Symbol thatStarts: 'sf' skipping: #sfpGetFile:with:with:with:with:with:with:with:with:"
"Symbol thatStarts: 'candidate' skipping: nil"
! !


SequenceableCollection subclass: #Interval
	instanceVariableNames: 'start stop step '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Collections-Sequenceable'!
!Interval commentStamp: '<historical>' prior: 0!
I represent a finite arithmetic progression.!


!Interval methodsFor: 'accessing'!
at: anInteger 
	"Answer the anInteger'th element."

	(anInteger >= 1 and: [anInteger <= self size])
		ifTrue: [^start + (step * (anInteger - 1))]
		ifFalse: [self errorSubscriptBounds: anInteger]! !

!Interval methodsFor: 'accessing'!
at: anInteger put: anObject 
	"Storing into an Interval is not allowed."

	self error: 'you can not store into an interval'! !

!Interval methodsFor: 'accessing'!
first 
	"Refer to the comment in SequenceableCollection|first."

	^start! !

!Interval methodsFor: 'accessing' stamp: 'rpj 11/30/1999 11:04'!
includes: aNumber
	"Determine if aNumber is an element of this interval."
	^ (self rangeIncludes: aNumber) and: [ self valuesInclude: aNumber ]! !

!Interval methodsFor: 'accessing'!
increment
	"Answer the receiver's interval increment."

	^step! !

!Interval methodsFor: 'accessing'!
last 
	"Refer to the comment in SequenceableCollection|last."

	^stop - (stop - start \\ step)! !

!Interval methodsFor: 'accessing' stamp: 'di 12/6/1999 11:00'!
rangeIncludes: aNumber
	"Return true if the number lies in the interval between start and stop."

	step >= 0
		ifTrue: [^ aNumber between: start and: stop]
		ifFalse: [^ aNumber between: stop and: start]
! !

!Interval methodsFor: 'accessing' stamp: 'sma 5/12/2000 11:38'!
size
	"Answer how many elements the receiver contains."

	step < 0
		ifTrue: [start < stop
				ifTrue: [^ 0]
				ifFalse: [^ stop - start // step + 1]]
		ifFalse: [stop < start
				ifTrue: [^ 0]
				ifFalse: [^ stop - start // step + 1]]! !


!Interval methodsFor: 'comparing'!
= anInterval 
	"Answer true if my species and anInterval species are equal, and
	if our starts, steps and sizes are equal."

	self species == anInterval species
		ifTrue: [^start = anInterval first
					and: [step = anInterval increment and: [self size = anInterval size]]]
		ifFalse: [^false]! !

!Interval methodsFor: 'comparing'!
hash
	"Hash is reimplemented because = is implemented."

	^(((start hash bitShift: 2)
		bitOr: stop hash)
		bitShift: 1)
		bitOr: self size! !


!Interval methodsFor: 'adding'!
add: newObject 
	"Adding to an Interval is not allowed."

	self shouldNotImplement! !


!Interval methodsFor: 'removing'!
remove: newObject 
	"Removing from an Interval is not allowed."

	self error: 'elements cannot be removed from an Interval'! !


!Interval methodsFor: 'copying'!
copy
	"Return a copy of me. Override the superclass because my species is
	Array and copy, as inherited from SequenceableCollection, uses
	copyFrom:to:, which creates a new object of my species."

	^self shallowCopy! !

!Interval methodsFor: 'copying' stamp: 'sma 3/3/2000 13:18'!
shallowCopy
	"Without this method, #copy would return an array instead of a new interval.
	The whole problem is burried in the class hierarchy and every fix will worsen
	the problem, so once the whole issue is resolved one should come back to this 
	method fix it."

	^ self class from: start to: stop by: step! !


!Interval methodsFor: 'enumerating'!
collect: aBlock
	| nextValue result |
	result _ self species new: self size.
	nextValue _ start.
	1 to: result size do:
		[:i |
		result at: i put: (aBlock value: nextValue).
		nextValue _ nextValue + step].
	^ result! !

!Interval methodsFor: 'enumerating'!
do: aBlock

	| aValue |
	aValue _ start.
	step < 0
		ifTrue: [[stop <= aValue]
				whileTrue: 
					[aBlock value: aValue.
					aValue _ aValue + step]]
		ifFalse: [[stop >= aValue]
				whileTrue: 
					[aBlock value: aValue.
					aValue _ aValue + step]]! !

!Interval methodsFor: 'enumerating'!
reverseDo: aBlock 
	"Evaluate aBlock for each element of my interval, in reverse order."

	| aValue |
	aValue _ stop.
	step < 0
		ifTrue: [[start >= aValue]
				whileTrue: 
					[aBlock value: aValue.
					aValue _ aValue - step]]
		ifFalse: [[start <= aValue]
				whileTrue: 
					[aBlock value: aValue.
					aValue _ aValue - step]]! !


!Interval methodsFor: 'printing' stamp: 'sma 6/1/2000 09:50'!
printOn: aStream
	aStream nextPut: $(;
	 print: start;
	 nextPutAll: ' to: ';
	 print: stop.
	step ~= 1 ifTrue: [aStream nextPutAll: ' by: '; print: step].
	aStream nextPut: $)! !

!Interval methodsFor: 'printing'!
storeOn: aStream 
	"This is possible because we know numbers store and print the same."

	self printOn: aStream! !


!Interval methodsFor: 'private'!
setFrom: startInteger to: stopInteger by: stepInteger

	start _ startInteger.
	stop _ stopInteger.
	step _ stepInteger! !

!Interval methodsFor: 'private'!
species

	^Array! !

!Interval methodsFor: 'private' stamp: 'di 4/24/2000 13:56'!
valuesInclude: aNumber
	"Private - answer whether or not aNumber is one of the enumerated values in this interval."

	| val |
	val _ (aNumber - self first) asFloat / self increment.
	^ val fractionPart abs < (step * 1.0e-10)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

Interval class
	instanceVariableNames: ''!

!Interval class methodsFor: 'instance creation'!
from: startInteger to: stopInteger 
	"Answer an instance of me, starting at startNumber, ending at 
	stopNumber, and with an interval increment of 1."

	^self new
		setFrom: startInteger
		to: stopInteger
		by: 1! !

!Interval class methodsFor: 'instance creation'!
from: startInteger to: stopInteger by: stepInteger 
	"Answer an instance of me, starting at startNumber, ending at 
	stopNumber, and with an interval increment of stepNumber."

	^self new
		setFrom: startInteger
		to: stopInteger
		by: stepInteger! !

!Interval class methodsFor: 'instance creation'!
new
	"Primitive. Create and answer with a new instance of the receiver
	(a class) with no indexable fields. Fail if the class is indexable. Override
	SequenceableCollection new. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 70>
	self isVariable ifTrue: [ ^ self new: 0 ].
	"space must be low"
	Smalltalk signalLowSpace.
	^ self new  "retry if user proceeds"
! !

!Interval class methodsFor: 'instance creation'!
newFrom: aCollection 
	"Answer an instance of me containing the same elements as aCollection."

	| newInterval |
	newInterval _ self from: aCollection first to: aCollection last by:
		(aCollection last - aCollection first)//(aCollection size - 1).
	aCollection ~= newInterval
		ifTrue: [self error: 'The argument is not an arithmetic progression'].
	^newInterval

"	Interval newFrom: {1. 2. 3}
	{33. 5. -23} as: Interval
	{33. 5. -22} as: Interval    (an error)
	(-4 to: -12 by: -1) as: Interval
"! !


Object subclass: #HandmadeTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'jorendorff-lulz'!
!HandmadeTests commentStamp: 'jto 5/1/2011 12:54' prior: 0!
Tests for the Smalltalk-to-JS compiler.

To run the tests:
	(HandmadeTests new) runTests!


!HandmadeTests methodsFor: 'tests' stamp: 'jto 5/1/2011 12:50'!
runTests
	self testBasics;
	     testCompilerBlocks;
	     testCompilerSelf;
	     testIdentifiers;
	     testIntegers;
	     testPrimitives
! !

!HandmadeTests methodsFor: 'tests' stamp: 'jto 5/1/2011 12:50'!
testBasics
	"the very first tests"

	self check: [true].
	self check: [true.].
	self check: [false. true].
	self check: [false. true.].
	self check: [false not].
	self check: [true not not].
	self check: [false or: [true]].

	self check: [2 + 2 = 4].
	self check: [0 - 1 = -1].

	self check: [('hello' at: 5) = $o].
	self check: [{} isEmpty].
	self check: [{1} isEmpty not].
	self check: [{1. 2. 3. 3. 5. 7. 12} isSorted].
	self check: [{1. 2. 3. 3. 5. 4. 12} isSorted not].

        self check: [self sailingYear = 1492].
! !

!HandmadeTests methodsFor: 'tests' stamp: 'jto 5/1/2011 12:50'!
testCompilerSelf
	"test compiler support for the 'self' keyword"
	|x|
 
	x _ ({1} at: 1 put: self; at: 1).
	self check: [x == self].
! !

!HandmadeTests methodsFor: 'tests' stamp: 'jto 5/1/2011 12:50'!
testCompilerBlocks
	"test compiler support for identifiers in blocks"

	self check: [|x| x _ 2 + 2. x = 4].
! !

!HandmadeTests methodsFor: 'tests' stamp: 'jto 5/1/2011 12:50'!
testIdentifiers
	|arguments class eval if private this|

	arguments _ 1.
	class _ 2.
	eval _ 3.
	if _ 4.
	private _ 5.
	this _ 6.

	self check: [arguments = 1];
	     check: [class = 2];
	     check: [eval = 3];
	     check: [if = 4];
	     check: [private = 5];
	     check: [this = 6].
! !

!HandmadeTests methodsFor: 'tests' stamp: 'jto 5/1/2011 12:50'!
testIntegers
	self check: [(0 bitXor: 1) = 1].

        self check: [(2 raisedTo: 31) = 2147483648].
        self check: [((2 raisedTo: 31) // (2 raisedTo: 15)) = 65536].

	"self check: [16r3FFFFFFF + 1 = 16r40000000]."
	"self check: [-16r40000000 negate = 16r40000000]."
	"self check: [(16rF0F0F0F0 bitXor: 16r0F0F0F0F) = 16rFFFFFFFF]."
	self check: [1 ~= 2].
	self check: [(0 bitXor: 0) = 0].

	"this one doesn't work yet -- outside the range of precise integer-valued Numbers."
	"self check: [16r0123456789ABCDEF0123456789ABCDEF = 1512366075204170929049582354406559215]."
! !

!HandmadeTests methodsFor: 'tests' stamp: 'jto 5/1/2011 12:50'!
testPrimitives
	"17: SmallInteger#bitShift:"
	self check: [(1 bitShift: 4) = 16];
	     check: [(-1 bitShift: 4) = -16];
	     check: [(16r12345 bitShift: 12) = 16r12345000].
	"The rest of these need better LargeInteger support."
	"     check: [(1 bitShift: 31) = 16r80000000];"
	"     check: [((16rFFFFFFFF bitShift: 4) bitShift: -4) = 16rFFFFFFFF];"
	"     check: [((16rFFFFFFFF bitShift: -4) bitShift: 4) = 16rFFFFFFF0];"
	"     check: [(1 bitShift: 32) = 16r100000000];"
	"     check: [(16rF0000000 bitShift: 4) = 16rF00000000];"
	"     check: [(16r70000000 bitShift: 4) = 16r700000000];"
	"     check: [(16rF0000000 bitShift: -4) = 16r0F000000];"
	"     check: [(16r70000000 bitShift: -4) = 16r07000000];"

	"51: Float#truncated"
	self check: [0.125 truncated isMemberOf: SmallInteger];
	     check: [0.999 truncated = 0];
	     check: [-0.0 truncated = 0];
	     check: [-0.999 truncated = 0];
	     check: [2147483647.5 truncated = 2147483647];
	     "check: [2147483648.0 truncated = 2147483648];"
	     "check: [2147483648.5 truncated = 2147483648];"
	     check: [-2147483647.5 truncated = -2147483647].
	     "check: [-2147483648.0 truncated = -2147483648];"

	"60: Object#at: / Object#basicAt:"
	self check: [({14 . 92} at: 2) = 92];
	     check: [((ByteArray new: 5) at: 5) = 0].

	"61: Object#at:put: / Object#basicAt:put:"
	self check: [ :a |
		a _ {0 . 0}.
		a at: 1 put: 3.
		a basicAt: 2 put: 7.
		(a at: 1) = 3 and: [(a at: 2) = 7].
	     ].

	"71: Object#basicNew:"
	self check: [((Array new: 5) at: 1) == nil].
! !

!HandmadeTests methodsFor: 'tests' stamp: 'jto 5/6/2011 19:55'!
sailingYear
	^ 1492.
! !

!HandmadeTests methodsFor: 'support' stamp: 'jto 5/6/2011 19:55'!
check: block
	"make sure block produces the value true."

	block value == true ifFalse: [ self halt ].
! !
