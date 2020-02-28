"
These tests do not use a bootstrapped kernel. 
Everything is set manually.
"
Class {
	#name : #ManualCreationPicoTest,
	#superclass : #PicoTest,
	#instVars : [
		'pointClass',
		'aPoint',
		'coloredPointClass',
		'aColoredPoint',
		'objectClass'
	],
	#category : #'Interpreters-Tests'
}

{ #category : #setup }
ManualCreationPicoTest >> assembleColoredPointClass [
	
	"This is not the way to create classes. Here we are testing primitives before the bootstrap of the kernel so we do everything by hand. In future tests we will retest these functionalities using a full kernel version."
	
	coloredPointClass := PicoBlop new: 5.
	coloredPointClass at: coloredPointClass offsetForName put: #PicoColoredPoint.
	coloredPointClass at: coloredPointClass offsetForClass put: #PicoClass.
	coloredPointClass at: coloredPointClass offsetForIVs put: #(#class #x #y #color).
	coloredPointClass at: coloredPointClass offsetForSuperclass put: #PicoPoint.
	coloredPointClass at: coloredPointClass offsetForMethodDict put: IdentityDictionary new.
	coloredPointClass initializeMethodDictionaryFrom: PicoColoredPointCode.
	PicoBlop declareClass: coloredPointClass.

]

{ #category : #setup }
ManualCreationPicoTest >> assembleColoredPointInstance [
	aColoredPoint := PicoBlop new: 4.
	aColoredPoint at: 1 put: #PicoColoredPoint.
	aColoredPoint at: 2 put: 10.
	aColoredPoint at: 3 put: 15.
	aColoredPoint at: 4 put: Color red
]

{ #category : #setup }
ManualCreationPicoTest >> assembleObjectClass [
	
	"This is not the way to create classes. Here we are testing primitives before the bootstrap of the kernel so we do everything by hand. In future tests we will retest these functionalities using a full kernel version."
	
	objectClass := PicoBlop new: 5.
	objectClass at: objectClass offsetForName put: #PicoObject.
	objectClass at: objectClass offsetForClass put: #PicoClass.
	objectClass at: objectClass offsetForIVs put: #(#class).
	objectClass at: objectClass offsetForSuperclass put: nil.
	objectClass at: objectClass offsetForMethodDict put: IdentityDictionary new.
	objectClass initializeMethodDictionaryFrom: PicoObjectCode.
	PicoBlop declareClass: objectClass.

]

{ #category : #setup }
ManualCreationPicoTest >> assemblePointClass [
	
	"This is not the way to create classes. Here we are testing primitives before the bootstrap of the kernel so we do everything by hand. In future tests we will retest these functionalities using a full kernel version."
	
	pointClass := PicoBlop new: 5.
	pointClass at: pointClass offsetForName put: #PicoPoint.
	pointClass at: pointClass offsetForClass put: #PicoClass.
	pointClass at: pointClass offsetForIVs put: #(#class #x #y).
	pointClass at: pointClass offsetForSuperclass put: #PicoObject.
	pointClass at: pointClass offsetForMethodDict put: IdentityDictionary new.
	pointClass initializeMethodDictionaryFrom: PicoPointCode.
	PicoBlop declareClass: pointClass.

]

{ #category : #setup }
ManualCreationPicoTest >> assemblePointInstance [
	aPoint := PicoBlop new: 3.
	aPoint at: 1 put: #PicoPoint.
	aPoint at: 2 put: 10.
	aPoint at: 3 put: 15
]

{ #category : #setup }
ManualCreationPicoTest >> setUp [ 
	self assemblePointClass.
	self assemblePointInstance. 
	self assembleColoredPointClass.
	self assembleColoredPointInstance.
	self assembleObjectClass
]

{ #category : #'step5-tests-allocate' }
ManualCreationPicoTest >> testAllocate [
  "(self  selector: #testAllocate) run"
  | newInstance |
  newInstance := pointClass allocateAnInstance.
  self assert: (newInstance at: 1) equals: #PicoPoint.
  self assert: newInstance size equals: 3.
  self assert: (newInstance at: 2) isNil.
  self assert: (newInstance at: 3) isNil.
  self assert: newInstance picoClass equals: pointClass
]

{ #category : #'step3-tests-class access' }
ManualCreationPicoTest >> testClassAccess [
	"(self  selector: #testClassAccess) run"
	
	self assert: aPoint picoClass equals: pointClass
]

{ #category : #'step5-tests-allocate' }
ManualCreationPicoTest >> testEmpty [
]

{ #category : #'step8-tests-lookup' }
ManualCreationPicoTest >> testErrorRaisedSendWhenErrorInLookup [
	"(self  selector: #testErrorRaisedSendWhenErrorInLookup) run"
	
	self should: [ pointClass sendError: #zork withArgs: { aPoint } ] raise: Error.
	"Open a Transcript to see the message trace"
]

{ #category : #'step9-tests-message' }
ManualCreationPicoTest >> testExecuteMethodInDefiningClass [
	"(self  selector: #testExecuteMethodInDefiningClass) run"

	"method found in the class PointClass"
	self assert: (aPoint send: #x) equals: 10.
	
]

{ #category : #'step9-tests-message' }
ManualCreationPicoTest >> testExecuteMethodOfSuperclass [
	"(self  selector: #testMethodSelfSendUnarySend) run"

	self assert: (aColoredPoint send: #x) equals: 10.

]

{ #category : #'step4-tests-iv management' }
ManualCreationPicoTest >> testIVOffsetAskingTheClass [
	"(self  selector: #testIVOffsetAskingTheClass) run"

	self assert: (pointClass offsetFromClassOfInstanceVariable: #x) equals: 2.
	self assert: (pointClass offsetFromClassOfInstanceVariable: #lulu) equals:  0
]

{ #category : #'step4-tests-iv management' }
ManualCreationPicoTest >> testIVOffsetAskingTheInstance [
	"(self  selector: #testIVOffsetAskingTheInstance) run"

	self assert: (pointClass offsetFromClassOfInstanceVariable: #x) equals: 2.
	self assert: (pointClass offsetFromClassOfInstanceVariable: #lulu) equals: 0
]

{ #category : #'step4-tests-iv management' }
ManualCreationPicoTest >> testIVValue [
	"(self  selector: #testIVOffsetAndValue) run"

	self assert: (aPoint valueOfInstanceVariable: #x) equals: 10
]

{ #category : #'step2-tests-structure of classes' }
ManualCreationPicoTest >> testIVsSize [
	"(self selector: #testIVsSize) run"

	self assert: pointClass picoNumberOfIVs equals: 3.
	self assert: coloredPointClass picoNumberOfIVs equals: 4.

]

{ #category : #'step7-tests-instanceVariableInheritance' }
ManualCreationPicoTest >> testInstanceVariableInheritance [
	"(self  selector: #testInstanceVariableInheritance) run"

	"a better choice would be to throw an exception if there are duplicates"
	self assert: 
			(PicoBlop new computeNewIVFrom: #(#a #b #c #d) 
				with: #(#a #z #b #t) )
					equals: #(#a #b #c #d #z #t) .
	self assert: 
			(PicoBlop new computeNewIVFrom: #() 
				with: #(#a #z #b #t) )
					equals: #(#a #z #b #t) 
]

{ #category : #'step7-tests-instanceVariableInheritance' }
ManualCreationPicoTest >> testInstanceVariableInheritanceFromAObject [
	"(self  selector: #testInstanceVariableInheritanceFromAObject) run"
	
	coloredPointClass picoIVs: (coloredPointClass 	
												computeNewIVFrom: #(class x y)
												with: #(color)).
	
	self assert: (aPoint offsetFromObjectOfInstanceVariable: #x) equals: 2.
	self assert: (aColoredPoint offsetFromObjectOfInstanceVariable: #x) equals: 2
	
	
	
]

{ #category : #'step7-tests-instanceVariableInheritance' }
ManualCreationPicoTest >> testInstanceVariableInheritanceNotFind [
	"(self  selector: #testInstanceVariableInheritanceNotFind) run"
	
	self should: [aPoint offsetFromObjectOfInstanceVariable: #zork ] raise: Error.
	
]

{ #category : #'step7-tests-instanceVariableInheritance' }
ManualCreationPicoTest >> testInstanceVariableInheritanceNumberOfInstanceVar [
	"(self  selector: #testInstanceVariableInheritanceNumberOfInstanceVar) run"
	
	self assert: pointClass picoNumberOfIVs equals: 3.
	self assert: coloredPointClass picoNumberOfIVs equals: 4.
	

]

{ #category : #'step9-tests-message' }
ManualCreationPicoTest >> testIntrospectiveReadVariable [
	"(self  selector: #testIntrospectiveReadVariable) run"

	"method found in the class PointClass"
	self assert: (aPoint send: #x) equals: 10.

	"method found in ObjClass"
	self assert: (aPoint send: #introspectReadVariable: withArguments: #(#x)) equals: 10.
]

{ #category : #'step9-tests-message' }
ManualCreationPicoTest >> testIntrospectiveWriteVariable [
	"(self  selector: #testIntrospectiveMethod) run"

	"method found in ObjClass"
	aPoint send: #introspectWriteVariable:value: withArguments: #(y 22).
	self assert: (aPoint send: #introspectReadVariable: withArguments: #(#y)) equals: 22
]

{ #category : #'step8-tests-lookup' }
ManualCreationPicoTest >> testLookupMethodInSuperclass [
	| method |
	method := coloredPointClass lookup: #x.
	self assert: method equals: (pointClass bodyOfMethod: #x)
]

{ #category : #'step8-tests-lookup' }
ManualCreationPicoTest >> testLookupUndefinedMethodReturnsNil [
	"(self  selector: #testLookupUndefinedMethodReturnsNil) run"
	
	| foundMethod|
	foundMethod := (pointClass lookup: #zork).
	self assert: foundMethod isNil. 
	"The method zork is NOT implemented on pointClass, so nil is returned."
	
]

{ #category : #'step8-tests-lookup' }
ManualCreationPicoTest >> testMethodLookupStop [
	"(self  selector: #testMethodLookupStop) run"
	
	| foundMethod|
	
	foundMethod := (pointClass lookup: #error:).
	self assert: (foundMethod isKindOf: RBProgramNode).
	self assert: ('*Error*' match: foundMethod printString).
	
	"the message error defined on PicoObject requires two arguments: an object and a selector and it raises an error when executed. Open a Transcript to see the message trace"
	self should:  [((pointClass lookup: #zork) value: 'r' value: #e)] raise: Error
]

{ #category : #'step6-tests-method-API' }
ManualCreationPicoTest >> testMethodManagmentBodyOfMethod [
	"(self  selector: #testMethodManagmentBodyOfMethod) run"
	
	self assert: ((pointClass bodyOfMethod: #x) isKindOf: RBProgramNode )

]

{ #category : #'step6-tests-method-API' }
ManualCreationPicoTest >> testMethodManagmentNotUnderstandBadMethod [
	"(self  selector: #testMethodManagmentNotUnderstandBadMethod) run"

	self assert: (pointClass doesUnderstand: #xx) not
	
]

{ #category : #'step6-tests-method-API' }
ManualCreationPicoTest >> testMethodManagmentUnderstandGoodMethod [
	"(self  selector: #testMethodManagmentUnderstandGoodMethod) run"

	self assert: (pointClass doesUnderstand: #x).

]

{ #category : #'step9-tests-message' }
ManualCreationPicoTest >> testMethodSuperCall [
	"(self  selector: #testMethodSuperCall) run"

	"foo in point return 5"
	self assert: (aPoint send: #foo) equals: 5.

	"foo in colored point is doing super foo + super foo"
	self assert: (aColoredPoint send: #foo) equals: 10
]

{ #category : #'step2-tests-structure of classes' }
ManualCreationPicoTest >> testPrimitiveStructureIVs [
	"(self selector: #testPrimitiveStructureIVs) run"

	self assert: pointClass picoIVs equals: #(#class #x #y)

]

{ #category : #'step1-tests-structure of objects' }
ManualCreationPicoTest >> testPrimitiveStructureObjClassIdForSimpleObject [
	"self run: #testPrimitiveStructureObjClassIdForSimpleObject"

	self assert: aPoint picoClassId equals: #PicoPoint

]

{ #category : #'step1-tests-structure of objects' }
ManualCreationPicoTest >> testPrimitiveStructurePicoClassId [
	"(self selector: #testPrimitiveStructureObjClassId) run"

	self assert: pointClass picoClassId equals: #PicoClass

]

{ #category : #'step2-tests-structure of classes' }
ManualCreationPicoTest >> testPrimitiveStructurePicoName [
	"(self selector: #testPrimitiveStructureObjName) run"

	self assert: pointClass picoClassName equals: #PicoPoint.
	self assert: objectClass picoClassName equals: #PicoObject
	
]

{ #category : #'step2-tests-structure of classes' }
ManualCreationPicoTest >> testPrimitiveStructureSuperclassId [
	"(self selector: #testPrimitiveStructureSuperclassId) run"

	self assert: pointClass picoSuperclassId equals: #PicoObject.

]

{ #category : #'step8-tests-lookup' }
ManualCreationPicoTest >> testSimpleLookup [
	| method |
	method := pointClass lookup: #x:.
	self assert: method equals: (pointClass bodyOfMethod: #x:)
]
