Class {
	#name : #PicoInterpreterTest,
	#superclass : #TestCase,
	#instVars : [
		'pointClass',
		'coloredPointClass'
	],
	#category : #'Interpreters-Tests'
}

{ #category : #setup }
PicoInterpreterTest >> setUp [

	pointClass := PicoBlop new: 5.
	{ #PicoClass . #PicoPoint . #PicoObject . { #class . #x . #y } . 5 }
		withIndexDo: [ :each :i | pointClass at: i put: each ].
	pointClass initializeMethodDictionaryFrom: PicoPointCode.
	PicoBlop initializePicoClassEnvironment.
	PicoBlop declareClass: pointClass.
	
	coloredPointClass := PicoBlop new: 5.
	{ #PicoClass . #PicoColoredPoint . #PicoPoint . { #class . #x . #y . #color} . 5 }
		withIndexDo: [ :each :i | coloredPointClass at: i put: each ].
	coloredPointClass initializeMethodDictionaryFrom: PicoColoredPointCode.
	PicoBlop declareClass: coloredPointClass.
	
	
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testDirectAccessToInstanceVariable [

	| inst value |
	inst := pointClass allocateAnInstance.
	inst at: 2 put: 2.
	inst at: 3 put: 3.

	"directAccessToX

	^ x"

	value := inst send: #directAccessToX.
	self assert: value equals: 2
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testDotProduct [

	| inst inst2 value |
	inst := pointClass allocateAnInstance.
	inst2 := pointClass allocateAnInstance.
	inst at: 2 put: 2.
	inst at: 3 put: 3.
	inst2 at: 2 put: 20.
	inst2 at: 3 put: 30.
	"dotProduct: aPicoPoint 

	^ (x * (aPicoPoint send: #x)) + (y * (aPicoPoint send: #y))"

	value := inst send: #dotProduct: withArguments: {inst2}.
	self assert: value equals: (2@3 dotProduct: (20@30)).
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testDotProduct2 [

	| inst inst2 value |
	inst := pointClass allocateAnInstance.
	inst2 := pointClass allocateAnInstance.
	inst at: 2 put: 2.
	inst at: 3 put: 3.
	inst2 at: 2 put: 20.
	inst2 at: 3 put: 30.
	"dotProduct: aPicoPoint 

	^ ((self send: #x) * (aPicoPoint send: #x)) + ((self send: #y) * (aPicoPoint send: #y))"

	value := inst send: #dotProduct2: withArguments: {inst2}.
	self assert: value equals: (2@3 dotProduct: (20@30)).
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testGetterExecution [
	|  inst val |
	inst := pointClass allocateAnInstance.
	inst at: 2 put: 33.
	val := inst send: #x.
	self assert: val equals: 33
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testGlobalAccess [

	| inst value |
	inst := pointClass allocateAnInstance.
	value := inst send: #accessGlobal.
	self assert: value equals: PicoBlop
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testHalfDotProduct [

	| inst inst2 value |
	inst := pointClass allocateAnInstance.
	inst2 := pointClass allocateAnInstance.
	inst at: 2 put: 200.
	inst at: 3 put: 300.
	inst2 at: 2 put: 20.
	inst2 at: 3 put: 30.
	"halfDotProduct: aPicoPoint 

	^ x * (aPicoPoint send: #x) "

	value := inst send: #halfDotProduct: withArguments: {inst2}.
	self assert: value equals: 4000.
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testMessageSendToGlobalAccess [

	| inst value |
	inst := pointClass allocateAnInstance.
	PicoBlop declareClass: pointClass.
	value := inst send: #messageSendToGlobal.
	self assert: value equals: pointClass.
	
]

{ #category : #'primitive message tests' }
PicoInterpreterTest >> testPlayingWithString [
	| inst val |
	inst := pointClass allocateAnInstance.
	val := inst send: #playingWithString.
	"playingWithString

	^ 'pico core is cool' size"
	self assert: val equals: 17
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testReturn100Execution [
	|  inst val |
	inst := pointClass allocateAnInstance.
	val := inst send: #return100.
	self assert: val equals: 100
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testReturnSuper [
	| inst |
	inst := coloredPointClass allocateAnInstance.
	self assert: (inst send: #returnSuper) equals: inst
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testSendingMessageToArgument [
	|  inst inst2 value |
	inst := pointClass allocateAnInstance.
	inst2 := pointClass allocateAnInstance.
	inst at: 2 put: 42.
	inst2 at: 2 put: 666.
	"sendingMessageToArgument: aPicoPoint 
	
	^ (aPicoPoint send: #x) "
	value := inst send: #sendingMessageToArgument: withArguments: {inst2}.
	self assert: value equals: 666.
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testSendingMessageToArgumentWithArg [

	|  inst inst2 value |
	inst := pointClass allocateAnInstance.
	inst2 := pointClass allocateAnInstance.
	inst at: 2 put: 42.
	inst2 at: 2 put: 666.
	"sendingMessageToArgument: anEvilPoint withArg: arg
	
	^ (anEvilPoint send: #x) + arg"

	value := inst send: #sendingMessageToArgument:withArg: withArguments: {inst2 . 72}.
	self assert: value equals: 666 + 72.
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testSendingMessageToArgumentwithDifferentArgument [

	| inst inst2 value |
	inst := pointClass allocateAnInstance.
	inst2 := pointClass allocateAnInstance.
	inst at: 2 put: 42.
	inst2 at: 2 put: 666.
	"sendingMessageToArgument: aPicoPoint withDifferentArgument: anArg
	
	aPicoPoint send: #x: withArguments: {33}.
	^ aPicoPoint send: #x"

	value := inst send: #sendingMessageToArgument:withDifferentArgument: withArguments: {inst2 . 72}.
	self assert: value equals: 33.
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testSetterExecution [
	| inst |
	inst := pointClass allocateAnInstance.
	inst send: #x: withArguments: #(20).
	self assert: (inst at: 2) equals: 20.
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testSettingAValueFromTempToTemp2 [
	|  inst value |
	inst := pointClass allocateAnInstance.
	value := inst send: #settingAValueFromTempToTemp2.
	self assert: value equals: 10.
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testSettingAValueToTemp [
	|  inst value |
	inst := pointClass allocateAnInstance.
	value := inst send: #settingAValueToTemp.
	
	"settingAValueToTemp

	| temp | 
	temp := 10.
	^ temp"
	
	self assert: value equals: 10.
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testSettingAValueToTemp2 [
	|  inst value |
	inst := pointClass allocateAnInstance.
	value := inst send: #settingAValueToTemp2.
	self assert: value equals: 20.
]

{ #category : #'primitive message tests' }
PicoInterpreterTest >> testSimpleMessage [
	|  inst val |
	inst := pointClass allocateAnInstance.
	val := inst send: #simpleMessage.
	"
	simpleMessage
		^ 10 * 10
	"
	self assert: val equals: 100
	
]

{ #category : #'stack tests' }
PicoInterpreterTest >> testStackIsWellInitialized [

	| int |
	int := AbraInterpreter new.
	self assert: int stack top parent isNil.
]

{ #category : #'stack tests' }
PicoInterpreterTest >> testStackPushNewScope [

	| int |
	int := AbraInterpreter new.
	int pushNewFrame.
	"the parent of the top scope is the previous one."
	self deny: int stack top parent isNil.
]

{ #category : #'primitive message tests' }
PicoInterpreterTest >> testSummingArgArg2 [

	| inst value |
	inst := pointClass allocateAnInstance.
	inst at: 2 put: 42.
	"summingArg: arg1 arg2: arg2
		^ arg1 + arg2"

	value := inst send: #summingArg:arg2: withArguments: {33 . 72}.
	self assert: value equals: 33 + 72
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testSuperCall [
	| inst |
	inst := coloredPointClass allocateAnInstance.
	self assert: (inst send: #foo) equals: 10
	
]

{ #category : #'interpreter tests' }
PicoInterpreterTest >> testSwappingArgArg2 [

	| inst value |
	inst := pointClass allocateAnInstance.
	inst at: 2 put: 42.
	"swappingArg: arg1 arg2: arg2
	
	^ self send: #summingArg:arg2: withArguments: { arg1 . arg2}"

	value := inst send: #swappingArg:arg2: withArguments: {33 . 72}.
	self assert: value equals: 33 + 72
	
]

{ #category : #'primitive message tests' }
PicoInterpreterTest >> testUsingTempValue [
	|  inst val |
	inst := pointClass allocateAnInstance.
	val := inst send: #usingTempValue.
	"usingTempValue

	| temp | 
	temp := 10.
	temp := temp + temp.
	^ temp"
	self assert: val equals: 20
	
]
