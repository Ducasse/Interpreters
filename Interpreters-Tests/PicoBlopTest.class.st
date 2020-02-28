Class {
	#name : #PicoBlopTest,
	#superclass : #TestCase,
	#instVars : [
		'pointClass'
	],
	#category : #'Interpreters-Tests'
}

{ #category : #running }
PicoBlopTest >> setUp [

	pointClass := PicoBlop new: 5.
	{ #PicoClass . #PicoPoint . #PicoObject . { #class . #x . #y } . 5 }
		withIndexDo: [ :each :i | pointClass at: i put: each ].
	
	pointClass initializeMethodDictionaryFrom: PicoPointCode.
	PicoBlop initializePicoClassEnvironment.
	PicoBlop declareClass: pointClass.
	
	
]

{ #category : #tests }
PicoBlopTest >> testMethodDictionaryFrom [

	| dict |
	dict := PicoBlop new methodDictionaryFrom: PicoPointCode.
	self assert: dict keys asSet equals: PicoPointCode selectors asSet.
	self assert: (dict at: #x) equals: (PicoPointCode >> #x) ast

]

{ #category : #tests }
PicoBlopTest >> testPoinInstantiation [
	|  inst |
	inst := pointClass allocateAnInstance.
	self assert: (inst at: 1) equals: 'PicoPoint'.
	self assert: (inst at: 2) equals: nil.
	self assert: (inst at: 3) equals: nil.
]

{ #category : #tests }
PicoBlopTest >> testPoinInstantiationClass [
	| inst |
	inst := pointClass allocateAnInstance.
	self assert: (inst at: 1) equals: 'PicoPoint'.
	self assert: inst picoClass equals: pointClass.

]

{ #category : #tests }
PicoBlopTest >> testSimpleLookup [
	| method |
	method := pointClass lookup: #x:.
	self assert: method equals: (pointClass bodyOfMethod: #x:)
]

{ #category : #'message tests' }
PicoBlopTest >> testValidSend [

	self should: [ pointClass allocateAnInstance 
							send: #dotProduct: withArguments: {1 . 2} ] 
							raise: Error.
							
	self should: [ pointClass allocateAnInstance 
							send: #dotProduct withArguments: {1} ] 
							raise: Error.
	
	self should: [ pointClass allocateAnInstance 
							send: #dotProduct:and: withArguments: {1} ] 
							raise: Error.
							
	self should: [ pointClass allocateAnInstance 
							send: #dotProduct:and: withArguments: {1 . 2 .3 } ] 
							raise: Error
]
