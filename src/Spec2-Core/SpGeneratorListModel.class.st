"
A list model to be used with a generator.

See `SpGeneratorListModel class>>#example`
See `Generator` class.

"
Class {
	#name : 'SpGeneratorListModel',
	#superclass : 'SpCollectionListModel',
	#instVars : [
		'generator',
		'size'
	],
	#category : 'Spec2-Core-Widgets-Table',
	#package : 'Spec2-Core',
	#tag : 'Widgets-Table'
}

{ #category : 'examples' }
SpGeneratorListModel class >> example [
	| items generator |

	items := ($a to: $z) asArray.
	generator := Generator on: [ :g | items do: [ :each | 
		each crTrace.
		g yield: each asUppercase ] ].

	SpEasyListViewPresenter new 
		model: (self new 
			generator: generator;
			yourself);
		open.

]

{ #category : 'instance creation' }
SpGeneratorListModel class >> on: aBlock [ 

	^ self new 
		generator: (Generator on: aBlock);
		yourself
]

{ #category : 'accessing' }
SpGeneratorListModel >> at: anIndex [

	^ self 
		at: anIndex 
		ifAbsent: [ self error: 'Index not found' ]
]

{ #category : 'accessing' }
SpGeneratorListModel >> at: anIndex ifAbsent: aBlock [

	[ collection size < anIndex ] 
	whileTrue: [ 
		self generator atEnd ifTrue: [ ^ aBlock value ].
		collection add: self generator next.
		size < collection size ifTrue: [ size := collection size ].
		self generator atEnd ifTrue: [ size := collection size ] ].
	
	^ collection at: anIndex
]

{ #category : 'accessing' }
SpGeneratorListModel >> generator [
	^ generator
]

{ #category : 'accessing' }
SpGeneratorListModel >> generator: aGenerator [

	generator := aGenerator.
]

{ #category : 'testing' }
SpGeneratorListModel >> hasElementAt: index [

	self at: index ifAbsent: [ ^ false ].
	^ true
]

{ #category : 'initialization' }
SpGeneratorListModel >> initialize [

	super initialize.
	self collection: OrderedCollection new.
	size := 10000
]

{ #category : 'accessing' }
SpGeneratorListModel >> size [

	^ size
]
