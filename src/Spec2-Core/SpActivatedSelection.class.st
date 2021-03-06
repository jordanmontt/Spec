Class {
	#name : #SpActivatedSelection,
	#superclass : #Object,
	#instVars : [
		'selection',
		'value'
	],
	#category : #'Spec2-Core-Support'
}

{ #category : #accessing }
SpActivatedSelection >> selectedItem [

	^ value
]

{ #category : #accessing }
SpActivatedSelection >> value [

	^ value
]

{ #category : #accessing }
SpActivatedSelection >> value: anObject [

	value := anObject
]
