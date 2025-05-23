"
A tab layout that receives pages with labels.
It is the layout version of `SpNotebookPresenter`
"
Class {
	#name : 'SpTabLayout',
	#superclass : 'SpExecutableLayout',
	#instVars : [
		'initialPageIndex'
	],
	#category : 'Spec2-Layout-Tab',
	#package : 'Spec2-Layout',
	#tag : 'Tab'
}

{ #category : 'private' }
SpTabLayout >> adapterName [

	^ #TabAdapter
]

{ #category : 'accessing' }
SpTabLayout >> add: aName label: aString [

	self 
		add: aName 
		withConstraints: [ :constraints | 
			constraints label: aString ]
]

{ #category : 'accessing' }
SpTabLayout >> add: aPresenter withConstraints: aBlock [

	super add: aPresenter withConstraints: aBlock.
	self announceChildAdded: aPresenter
]

{ #category : 'private' }
SpTabLayout >> constraintsClass [

	^ SpTabConstraints
]

{ #category : 'accessing' }
SpTabLayout >> initialPageIndex [
	
	^ initialPageIndex
]

{ #category : 'accessing' }
SpTabLayout >> initialPageIndex: aNumber [

	initialPageIndex := aNumber
]

{ #category : 'initialization' }
SpTabLayout >> initialize [

	super initialize.
	initialPageIndex := 1
]

{ #category : 'accessing' }
SpTabLayout >> select: aWindowPresenter [

	self selectIndex: (self children indexOf: aWindowPresenter)
]

{ #category : 'accessing' }
SpTabLayout >> selectIndex: aNumber [

	self withAdapterDo: [ :anAdapter | 
		anAdapter selectIndex: aNumber ]
]

{ #category : 'events' }
SpTabLayout >> whenTabSelectedDo: aBlock [

	self announcer 
		when: SpTabSelected 
		do: aBlock
		for: aBlock receiver
]

{ #category : 'events' }
SpTabLayout >> whenTabUnselectedDo: aBlock [

	self announcer 
		when: SpTabUnselected 
		do: aBlock
		for: aBlock receiver
]
