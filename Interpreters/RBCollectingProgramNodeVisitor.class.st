Class {
	#name : #RBCollectingProgramNodeVisitor,
	#superclass : #RBProgramNodeVisitor,
	#category : #Interpreters
}

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitAllButLastStatementNodes: aCol [
	"Visit all the statements of a block body except the last one. See visitLastStatementNode:"

	^ aCol do: [ :each | self visitNode: each ]
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitArgumentNode: anArgumentNode [
	"Sent *each time* an argument node is found"
	"does nothing!"
	

]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitArrayNode: anArrayNode [

	^ anArrayNode children collect: [ :each | self visitNode: each ]
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitLastStatementNode: aNode [
	"Visit the last statement of a sequence node (method body or block body)."
	^ self visitNode: aNode
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitLiteralArrayNode: aNode [
		
	^ aNode contents collect: [ :each | self visitNode: each ]
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitMessageArgumentNode: aNode [
	^ self visitNode: aNode
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitMessageArgumentNodes: aCol [

	^ aCol do: [ :each | self visitMessageArgumentNode: each ]
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitMessageNode: aMessageNode [
	(aMessageNode isCascaded not or: [ aMessageNode isFirstCascaded ])
		ifTrue: [ self visitMessageReceiver: aMessageNode receiver ].
	self visitMessageArgumentNodes: aMessageNode arguments
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitMessageReceiver: aNode [
	^ self visitNode: aNode
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitMethodBodyNode: aMethodBodyNode [
	^ self visitNode: aMethodBodyNode 
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitMethodNode: aMethodNode [
	self visitParameterNodes: aMethodNode arguments.
	self visitPragmaNodes: aMethodNode pragmas.
	^ self visitMethodBodyNode: aMethodNode body
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitParameterNode: aNode [
	"We visit a single method parameter, usually a simple variable."
	
	^ self visitNode: aNode
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitParameterNodes: aCol [
	"We visit the **parameter** list of a method: in  foo: anInt, anInt is a parameter and not an argument. 
	We keep the term arguments for the actual objects pass to a message. Basically a list of variables"
	
	^ aCol do: [ :each | self visitParameterNode: each  ]
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitPragmaNode: aPragmaNode [
	^ self visitNode: aPragmaNode
	
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitPragmaNodes: aCol [
	^ aCol do: [ :each | self visitPragmaNode: each ]
	
]

{ #category : #visiting }
RBCollectingProgramNodeVisitor >> visitSequenceNode: aSequenceNode [
	"Sequence nodes represent method or block body."
	
	self visitTemporaryNodes: aSequenceNode temporaries.
	self visitAllButLastStatementNodes: aSequenceNode statements allButLast.
	^ self visitLastStatementNode: aSequenceNode statements last
]
