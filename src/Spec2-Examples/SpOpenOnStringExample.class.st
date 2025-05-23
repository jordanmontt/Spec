"
I am the component of DynamycSpecExample used for String.

self example 

I show also how to dynamically redrawn a widget.
"
Class {
	#name : 'SpOpenOnStringExample',
	#superclass : 'SpPresenter',
	#instVars : [
		'label',
		'check',
		'input',
		'button',
		'textToReset'
	],
	#category : 'Spec2-Examples-Wrapper',
	#package : 'Spec2-Examples',
	#tag : 'Wrapper'
}

{ #category : 'examples' }
SpOpenOnStringExample class >> example [

	<sampleInstance>
	^ (self new: 'Hello world')
		  extent: 300 @ 200;
		  open;
		  yourself
]

{ #category : 'instantiation' }
SpOpenOnStringExample class >> new: aString [
	^ self new initialize: aString
]

{ #category : 'accessing' }
SpOpenOnStringExample >> button [
	^ button
]

{ #category : 'accessing' }
SpOpenOnStringExample >> check [
	^ check
]

{ #category : 'initialization' }
SpOpenOnStringExample >> connectPresenters [
	button action: [ input text: textToReset ].
	input whenTextChangedDo: [ :text | label label: text ].
	check
		whenActivatedDo: [ self needRebuild: false.
			self buildWithSpecLayout: self class defaultLayout ];
		whenDeactivatedDo: [ self needRebuild: false.
			self buildWithSpecLayout: self class bottomLayout ]
]

{ #category : 'layout' }
SpOpenOnStringExample >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: label;
			add: check withConstraints: [ :constraints | constraints width: 100 ];
			yourself)
		withConstraints: [ :constraints | constraints height: 25 ];
		add: (SpBoxLayout newLeftToRight
			add: input;
			add: button;
			yourself)
		withConstraints: [ :constraints | constraints height: 25 ];
		yourself
]

{ #category : 'initialization' }
SpOpenOnStringExample >> initialize: aString [
	label label: aString.
	input text: aString.
	textToReset := aString
]

{ #category : 'initialization' }
SpOpenOnStringExample >> initializePresenters [
	label := self instantiate: SpLabelPresenter.
	check := self instantiate: SpCheckBoxPresenter.
	input := self instantiate: SpTextInputFieldPresenter.
	button := self instantiate: SpButtonPresenter.
	button
		label: 'reset';
		action: [ input text: textToReset ].
	check
		label: 'Label on top';
		state: false
]

{ #category : 'accessing' }
SpOpenOnStringExample >> input [
	^ input
]

{ #category : 'accessing' }
SpOpenOnStringExample >> label [
	^ label
]

{ #category : 'initialization' }
SpOpenOnStringExample >> openOnString [
	| ui temp object |
	object whenChangedDo: [ :o | ui label label: o asString ].
	temp := object value.

]

{ #category : 'accessing' }
SpOpenOnStringExample >> textToReset [
	^ textToReset
]

{ #category : 'accessing' }
SpOpenOnStringExample >> windowTitle [
	^ 'OpenOnStringExample'
]
