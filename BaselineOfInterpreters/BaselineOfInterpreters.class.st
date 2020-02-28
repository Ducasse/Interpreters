Class {
	#name : #BaselineOfInterpreters,
	#superclass : #BaselineOf,
	#category : #BaselineOfInterpreters
}

{ #category : #baselines }
BaselineOfInterpreters >> baseline: spec [
	<baseline>
	spec
		baseline: 'ContainersPropertyEnvironment'
		with: [ spec repository: 'github://Ducasse/Containers-PropertyEnvironment' ].
	spec
		for: #pharo
		do: [ 
			spec
				package: 'PicoCore' with: [ spec requires: #('ContainersPropertyEnvironment') ] ]
]
