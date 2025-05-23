"
I am a window used by WindowSpec.

I have been introduced since it's currently the best solution to prevent to add dozen of respondsTo: in StandardWindow or add dirty extensions to Object (because all models are not subclasses of Model)
"
Class {
	#name : 'SpWindow',
	#superclass : 'StandardWindow',
	#category : 'Spec2-Adapters-Morphic-Support',
	#package : 'Spec2-Adapters-Morphic',
	#tag : 'Support'
}

{ #category : 'protocol' }
SpWindow >> aboutText [

	^ self model aboutText
]

{ #category : 'closing' }
SpWindow >> allowedToClose [

	super allowedToClose ifFalse: [ ^ false ].
	self model ifNil: [ ^ true ].
	^ self model askOkToClose 
		ifTrue: [ self model requestWindowClose ]
		ifFalse: [ true ].
]

{ #category : 'private' }
SpWindow >> announceWillClose [
	| announcement |

	announcement := SpWindowWillClose new
		window: self;
		yourself.
	self announce: announcement.
	self currentWorld announcer announce: announcement.
	^ announcement canClose 
]

{ #category : 'open/close' }
SpWindow >> deleteDiscardingChanges [

	self announceWillClose ifFalse: [ ^ self ].
	^ super deleteDiscardingChanges
]

{ #category : 'open/close' }
SpWindow >> extent: aPoint [ 
	| announcement oldExtent |
	oldExtent := self extent. 
	super extent: aPoint.
	
	oldExtent = aPoint
		ifFalse: [  	
			announcement := SpWindowResizing new
				window: self;
				oldSize: oldExtent;
				newSize: aPoint;
				yourself.
			self announce: announcement.
			self currentWorld announcer announce: announcement ]
]

{ #category : 'testing' }
SpWindow >> hasWidget: aMorph [ 
	
	^ self allMorphs includes: aMorph
]

{ #category : 'updating' }
SpWindow >> okToChange [

	^ self model okToChange
]

{ #category : 'private' }
SpWindow >> taskbarIcon [
	"If we close the window programatically while the taskbar is been updated the model can be nil in some cases."

	(self model isNil or: [ self model windowIcon isNil ]) ifTrue: [ ^ super taskbarIcon ].

	^ self model windowIcon
]

{ #category : 'accessing' }
SpWindow >> taskbarTask [
	"Answer a taskbar task for the receiver.
	 Answer nil if not required."

	(self valueOfProperty: #noTaskbarTask ifAbsent: [ false ]) ifTrue: [
		^ nil ].

	taskbarTask := TaskbarTask
		morph: self
		state: self taskbarState
		icon: (self model iconNamed: self model taskbarIconName)
		label: self taskbarLabel.

	^ taskbarTask
]
