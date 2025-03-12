"
A TestingComposablePresenter is a stupid composable model used to test SpecInterpreter.
"
Class {
	#name : 'SpTestingPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'list'
	],
	#category : 'Spec2-Tests-Utils',
	#package : 'Spec2-Tests',
	#tag : 'Utils'
}

{ #category : 'layout' }
SpTestingPresenter class >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: #list;
		yourself
]

{ #category : 'accessing' }
SpTestingPresenter >> getText [
	^ Text new
]

{ #category : 'initialization' }
SpTestingPresenter >> initializePresenters [
	list := self newList
]

{ #category : 'accessing' }
SpTestingPresenter >> list [

	^ list
]

{ #category : 'accessing' }
SpTestingPresenter >> windowTitle [ 

	^ 'You should not see me !'
]
