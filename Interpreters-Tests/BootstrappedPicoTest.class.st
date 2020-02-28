"
These tests consider that the kernel is bootstrapped.
"
Class {
	#name : #BootstrappedPicoTest,
	#superclass : #PicoTest,
	#instVars : [
		'picoClass'
	],
	#category : #'Interpreters-Tests'
}

{ #category : #setup }
BootstrappedPicoTest >> setUp [ 
	super setUp.
	PicoBlop bootstrap.
	picoClass := PicoBlop giveClassNamed: #PicoClass.
]

{ #category : #tests }
BootstrappedPicoTest >> testCreateClassPoint [
	"(self selector: #testCreateClassPoint) run"

	| pointClass |
	pointClass := picoClass
		send: #createClassNamed:inheritsFrom:instVars:
		withArguments:
			{#PicoPoint.
			#PicoObject.
			#(x y)}.
	self assert: pointClass picoClassId equals: #PicoClass.
	self assert: pointClass picoSuperclassId equals: #PicoObject.
	self assert: pointClass picoIVs equals: #(class x y).
	self
		assert: pointClass picoMethodDict keys size
		equals: PicoPointCode selectors size.
	self 
		assert: pointClass picoClassName 
		equals: #PicoPoint
]

{ #category : #tests }
BootstrappedPicoTest >> testCreateInstance [
	"(self selector: #testManuallyCreateClassInstanceOfClass) run"

	| pointClass aPoint |
	pointClass := picoClass
		send: #createClassNamed:inheritsFrom:instVars:
		withArguments:
			{#PicoPoint.
			#PicoObject.
			#(x y)}.
	aPoint := pointClass send: #new.
	self assert: (aPoint send: #x) equals: 1000.


]

{ #category : #tests }
BootstrappedPicoTest >> testCreatingPointClassDeclaresIt [
	"(self selector: #testCreatingPointClassDeclaresIt) run"

	| pointClass |
	pointClass := picoClass
		send: #createClassNamed:inheritsFrom:instVars:
		withArguments:
			{#PicoPoint.
			#PicoObject.
			#(class x y)}.
	self assert: (PicoBlop picoEnvironment keys includes: #PicoPoint)
]

{ #category : #'tests - error' }
BootstrappedPicoTest >> testErrorRaisedSendWhenErrorInLookup [
	"(self  selector: #testErrorRaisedSendWhenErrorInLookup) run"
	
	self 
		assert: (picoClass sendError: #zork withArguments: { picoClass }) 
		equals: 'Error: message zork not found in class PicoClass'
	"Open a Transcript to see the message trace"
]

{ #category : #'tests - messages' }
BootstrappedPicoTest >> testLookUpForInheritedMethod [
	"(self selector: #testLookUpForInheritedMethod) run"

	| pointClass aPoint |
	pointClass := picoClass
		send: #createClassNamed:inheritsFrom:instVars:
		withArguments:
			{#PicoPoint.
			#PicoObject.
			#(x y)}.
	aPoint := pointClass send: #new.
	self assert: (aPoint send: #isClass) equals: false.

]

{ #category : #'tests - messages' }
BootstrappedPicoTest >> testLookUpForInheritedMethod2 [
	"(self selector: #testLookUpForInheritedMethod) run"

	| pointClass coloredPointClass coloredPoint |
	pointClass := picoClass
		send: #createClassNamed:inheritsFrom:instVars:
		withArguments:
			{#PicoPoint.
			#PicoObject.
			#(x y)}.
	coloredPointClass := picoClass
		send: #createClassNamed:inheritsFrom:instVars:
		withArguments:
			{#PicoColoredPoint.
			#PicoPoint.
			#(x y)}.
	coloredPoint := coloredPointClass send: #new.
	coloredPoint send: #x: withArguments: { 5 }.
	self assert: (coloredPoint send: #x) equals: 5.

]

{ #category : #'tests - messages' }
BootstrappedPicoTest >> testLookUpForInheritedMethod3 [
	"(self selector: #testLookUpForInheritedMethod3) run"

	| pointClass aPoint |
	pointClass := picoClass
		send: #createClassNamed:inheritsFrom:instVars:
		withArguments:
			{#PicoPoint.
			#PicoObject.
			#(x y)}.
	aPoint := pointClass send: #new.
	self assert: (aPoint send: #isClass) equals: false.


]

{ #category : #'tests - error' }
BootstrappedPicoTest >> testNilWhenErrorInLookup [
	"(self  selector: #testNilWhenErrorInLookup) run"
	
	self assert: (picoClass lookup: #zork) isNil.
	"The method zork is NOT implemented on pointClass"
	
]

{ #category : #'tests - error' }
BootstrappedPicoTest >> testRaisesErrorSendWhenErrorInLookup [
	"(self  selector: #testRaisesErrorSendWhenErrorInLookup) run"
	
	| pointClass coloredPointClass coloredPoint |
	pointClass := picoClass
		send: #createClassNamed:inheritsFrom:instVars:
		withArguments:
			{#PicoPoint.
			#PicoObject.
			#(x y)}.
	coloredPointClass := picoClass
		send: #createClassNamed:inheritsFrom:instVars:
		withArguments:
			{#PicoColoredPoint.
			#PicoPoint.
			#(x y)}.
	coloredPoint := coloredPointClass send: #new.
	self assert: (coloredPoint send: #unknowMessage: withArguments: {111} ) equals: 'Error on coloredPoint for message: unknowMessage:'
]
