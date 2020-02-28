"
These tests are about the bootstrap of the kernel.
"
Class {
	#name : #BootstrapPicoTest,
	#superclass : #TestCase,
	#category : #'Interpreters-Tests'
}

{ #category : #'tests - manually Class definition' }
BootstrapPicoTest >> manualClassDefinition [
	PicoBlop
		initialize;
		manuallyDefineClass
]

{ #category : #'tests - Object definition' }
BootstrapPicoTest >> objectDefinition [
	self manualClassDefinition.
	PicoBlop defineObject
]

{ #category : #'tests - Class definition' }
BootstrapPicoTest >> testClassStructureCreation [
	| picoClass |
	PicoBlop bootstrap.
	picoClass := PicoBlop giveClassNamed: #PicoClass.
	self assert: picoClass picoClassName equals: #PicoClass.
	self assert: picoClass picoClassId equals: #PicoClass.
	self assert: picoClass picoClass equals: picoClass.
	self assert: picoClass picoSuperclassId equals: #PicoObject.
	"the fact that the created first class inherits form ObjObject is not necessary
	because there is no super calls"
	self
		assert: picoClass picoIVs
		equals: #(#class #name #superclass #iv #methodDict)
]

{ #category : #'tests - Class definition' }
BootstrapPicoTest >> testClassTesting [
	| picoClass |
	PicoBlop bootstrap.
	picoClass := PicoBlop giveClassNamed: #PicoClass.
	self assert: (picoClass send: #isMetaclass)
]

{ #category : #'tests - Class definition' }
BootstrapPicoTest >> testCreateClassPoint [
	"(self selector: #testManuallyCreateClassCreateClass) run"

	| picoClass picoPointClass |
	PicoBlop bootstrap.
	picoClass := PicoBlop giveClassNamed: #PicoClass.
	picoPointClass := picoClass
		send: #createClassNamed:inheritsFrom:instVars:
		withArguments:
			{#PicoPoint . #PicoObject . #(x y)}.
	self assert: picoPointClass picoClassId equals: #PicoClass.
	self assert: picoPointClass picoSuperclassId equals: #PicoObject.
	self assert: picoPointClass picoIVs equals: #(class x y).
	self
		assert: picoPointClass picoMethodDict keys size
		equals: PicoPointCode selectors size.
	self assert: picoPointClass picoClassName equals: #PicoPoint
]

{ #category : #'tests - Object definition' }
BootstrapPicoTest >> testCreateObject [
	"(self selector: #testCreateObject) run"

	| objectClass |
	self objectDefinition.
	objectClass := PicoBlop giveClassNamed: #PicoObject.
	self assert: objectClass picoClassId equals: #PicoClass.
	self assert: objectClass picoSuperclassId isNil.
	self assert: objectClass picoIVs equals: #(#class).
	self
		assert: objectClass picoMethodDict keys size
		equals: PicoObjectCode selectors size.
	self assert: objectClass picoClassName equals: #PicoObject
]

{ #category : #'tests - Object definition' }
BootstrapPicoTest >> testCreateObjectMethods [
	"(self selector: #testCreateObjectMethods) run"

	| objectClass instanceOfObject |
	self objectDefinition.
	self
		assert: (PicoBlop picoEnvironment keys includesAll: #(#PicoObject #PicoClass)).
	objectClass := PicoBlop giveClassNamed: #PicoObject.
	instanceOfObject := objectClass send: #new.
	self assert: (instanceOfObject send: #isClass) not.
	self assert: (instanceOfObject send: #isMetaclass) not
]

{ #category : #'tests - Object definition' }
BootstrapPicoTest >> testMakeSureThatInitializeOnObjectIsInvoked [
	"(self selector: #testMakeSureThatInitializeOnObjectIsInvoked) run"

	| objectClass instanceOfObject |
	self objectDefinition.
	
	self
		assert: (PicoBlop picoEnvironment keys includesAll: #(#PicoObject #PicoClass)).
	objectClass := PicoBlop giveClassNamed: #PicoObject.
	instanceOfObject := objectClass send: #new.
	self assert: (instanceOfObject send: #picoClass) equals: objectClass
]

{ #category : #'tests - manually Class definition' }
BootstrapPicoTest >> testManualClassStructureCreation [
	| picoClass |
	picoClass := PicoBlop giveClassNamed: #PicoClass.
	self assert: picoClass picoClassName equals: #PicoClass.
	self assert: picoClass picoClassId equals: #PicoClass.
	self assert: picoClass picoClass equals: picoClass.
	self assert: picoClass picoSuperclassId equals: #PicoObject.
	"the fact that the created first class inherits form ObjObject is not necessary
	because there is no super calls"
	self
		assert: picoClass picoIVs
		equals: #(#class #name #superclass #iv #methodDict)
]

{ #category : #'tests - manually Class definition' }
BootstrapPicoTest >> testManuallyCreateClassAllocate [
	"(self selector: #testManuallyCreateClassAllocate) run"

	| picoClass emptyClass |
	PicoBlop 
		initialize;
		manuallyDefineClass.
		
	picoClass := PicoBlop giveClassNamed: #PicoClass.
	emptyClass := picoClass send: #allocate.
	self assert: emptyClass picoClassId equals: #PicoClass.
	self assert:  emptyClass picoSuperclassId isNil.
	self assert:  emptyClass picoIVs isNil.
	self assert:  emptyClass picoMethodDict isNil.
	self assert:  emptyClass picoClassName isNil
]

{ #category : #'tests - manually Class definition' }
BootstrapPicoTest >> testManuallyCreateClassCreateClass [
	"(self selector: #testManuallyCreateClassCreateClass) run"

	| picoClass picoObject |
	self manualClassDefinition.
	picoClass := PicoBlop giveClassNamed: #PicoClass.
	picoObject := picoClass
		send: #createClassNamed:inheritsFrom:instVars:
		withArguments:
			{#PicoObject.
			nil .
			#()}.
	self assert: picoObject picoClassId equals: #PicoClass.
	self assert: picoObject picoSuperclassId isNil.
	self assert: picoObject picoIVs equals: #(class).
	self
		assert: picoObject picoMethodDict keys size
		equals: PicoObjectCode selectors size.
	self assert: picoObject picoClassName equals: #PicoObject
]

{ #category : #'tests - manually Class definition' }
BootstrapPicoTest >> testManuallyCreateClassInstanceOfClass [
	"(self selector: #testManuallyCreateClassInstanceOfClass) run"

	| picoClass pointClass aPoint |
	self manualClassDefinition.
	picoClass := PicoBlop giveClassNamed: #PicoClass.
	pointClass := picoClass
		send: #createClassNamed:inheritsFrom:instVars:
		withArguments:
			{#PicoObject.
			nil .
			#()}.
	aPoint := pointClass send: #new.
	self deny: (aPoint send: #isClass).
	self deny: (aPoint send: #isMetaclass)
]

{ #category : #'tests - manually Class definition' }
BootstrapPicoTest >> testManuallyCreateClassIsDeclared [
	"(self selector: #testManuallyCreateClassInstanceOfClass) run"

	| picoClass pointClass |
	self manualClassDefinition.
	picoClass := PicoBlop giveClassNamed: #PicoClass.
	pointClass := picoClass
		send: #createClassNamed:inheritsFrom:instVars:
		withArguments:
			{#PicoObject.
			nil .
			#(class)}.
	self assert: (PicoBlop picoEnvironment keys includes: #PicoObject)
]

{ #category : #'tests - manually Class definition' }
BootstrapPicoTest >> testManuallyCreateClassNew [
	"(self selector: #testManuallyCreateClassNew) run"

	| picoClass emptyClass |
	self manualClassDefinition.
	picoClass := PicoBlop giveClassNamed: #PicoClass.
	emptyClass := picoClass send: #new.
	self assert: emptyClass picoClassId equals: #PicoClass.
	self assert: emptyClass picoSuperclassId equals: #YouShouldNameMeToo.
	self assert: emptyClass picoIVs equals: #().
	self
		assert: emptyClass picoMethodDict class
		equals: IdentityDictionary
]
