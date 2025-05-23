"
Browse all implementors of the selector found in context.
"
Class {
	#name : 'SpBrowseImplementorsCommand',
	#superclass : 'SpSystemSelectionCommand',
	#category : 'Spec2-Commands-Navigation',
	#package : 'Spec2-Commands',
	#tag : 'Navigation'
}

{ #category : 'default' }
SpBrowseImplementorsCommand class >> defaultDescription [
	^ 'Browse all implementors of the selected method or message'
]

{ #category : 'accessing' }
SpBrowseImplementorsCommand class >> defaultName [

	^ 'Implementors of it'
]

{ #category : 'default' }
SpBrowseImplementorsCommand class >> defaultShortcutKey [

	^ $m actionModifier
]

{ #category : 'default' }
SpBrowseImplementorsCommand class >> shortName [

	^ 'implementors'
]

{ #category : 'executing' }
SpBrowseImplementorsCommand >> execute [

	self context doBrowseImplementors
]
