"
A demo to demonstrate the usage of `SpTActivable`
"
Class {
	#name : 'SpDemoActivablePresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTActivable',
	#classTraits : 'SpTActivable classTrait',
	#instVars : [
		'activationAction'
	],
	#category : 'Spec2-Examples-Demo-Transmission',
	#package : 'Spec2-Examples',
	#tag : 'Demo-Transmission'
}

{ #category : 'inspection' }
SpDemoActivablePresenter class >> inspectionTesting: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Testing'>

	^ self instantiate: self
]

{ #category : 'instance creation' }
SpDemoActivablePresenter class >> open [ 
	<script>
	
	self inspect
]

{ #category : 'private - actions' }
SpDemoActivablePresenter >> activate [

	self activationAction ifNil: [ ^ self ].
	self activationAction cull: (SpActivatedSelection newValue: 42)
]

{ #category : 'initialization' }
SpDemoActivablePresenter >> initializePresenters [

	self layout: (SpBoxLayout newVertical 
		add: (self newButton 
			label: 'Activate';
			action: [ self activate ];
			yourself);
		yourself).
]
