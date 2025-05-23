"
I browse a class that is returned from the evaluation of my context.
My context must be a block that returns a class.
"
Class {
	#name : 'SpBrowseClassCommand',
	#superclass : 'SpSystemSelectionCommand',
	#instVars : [
		'selector'
	],
	#category : 'Spec2-Commands-Navigation',
	#package : 'Spec2-Commands',
	#tag : 'Navigation'
}

{ #category : 'default' }
SpBrowseClassCommand class >> defaultDescription [
	^ 'Browse the selected class'
]

{ #category : 'default' }
SpBrowseClassCommand class >> defaultShortcutKey [

	^ $b actionModifier
]

{ #category : 'default' }
SpBrowseClassCommand class >> shortName [

	^ 'full class'
]

{ #category : 'execution' }
SpBrowseClassCommand >> execute [

	self context perform: self selector
]

{ #category : 'accessing' }
SpBrowseClassCommand >> selector [

	^ selector ifNil: [ #doBrowseClass ]
]

{ #category : 'accessing' }
SpBrowseClassCommand >> selector: aSelector [

	selector := aSelector
]
