"
This class has a single instance representing a left item position.

Do not use the class directly, instead use:

	ITItemPosition left
"
Class {
	#name : #SpToolbarItemLeftPosition,
	#superclass : #SpToolbarItemPosition,
	#category : #'Spec2-Core-Widgets'
}

{ #category : #accessing }
SpToolbarItemLeftPosition >> addItem: anObject into: aToolbar [
	aToolbar addItemLeft: anObject
]
