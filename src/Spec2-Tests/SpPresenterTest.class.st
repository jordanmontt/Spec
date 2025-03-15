Class {
	#name : 'SpPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter'
	],
	#category : 'Spec2-Tests-Core',
	#package : 'Spec2-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
SpPresenterTest >> testAdapterDoesNotRemainsAsDependencyWhenReplacingIt [

	presenter := SpPresenter new.
	presenter layout: (SpBoxLayout new
			 add: SpListPresenter new;
			 add: SpTextPresenter new;
			 yourself).

	3 timesRepeat: [ 
		presenter open.
		presenter window close ].

	self assert: presenter dependents size equals: 1
]

{ #category : 'tests' }
SpPresenterTest >> testAsDialogWindow [

	presenter := SpPresenter new.
	self 
		assert: presenter asDialogWindow class
		equals: presenter application defaultDialogWindowPresenterClass
]

{ #category : 'tests' }
SpPresenterTest >> testAsModalWindow [

	presenter := SpPresenter new.
	self 
		assert: presenter asModalWindow class
		equals: presenter application defaultModalWindowPresenterClass
]

{ #category : 'tests' }
SpPresenterTest >> testAsWindow [

	presenter := SpPresenter new.
	self 
		assert: presenter asWindow class
		equals: presenter application defaultWindowPresenterClass
]

{ #category : 'tests - extent' }
SpPresenterTest >> testExtentWhenNotSetIsPreferredExtent [

	| presenterClass |
	presenterClass := SpPresenter newAnonymousSubclass.
	presenterClass compile: 'defaultLayout ^ SpGridLayout new'.
	presenterClass compile: 'initializePresenters self layout: SpBoxLayout newLeftToRight'.
	presenterClass class compile: 'defaultPreferredExtent ^ 500@600'.
	
	presenter := presenterClass new.
	self assert: presenter extent equals: 500@600.
	
]

{ #category : 'tests - extent' }
SpPresenterTest >> testExtentWhenSet [

	| presenterClass |
	presenterClass := SpPresenter newAnonymousSubclass.
	presenterClass compile: 'defaultLayout ^ SpGridLayout new'.
	presenterClass compile: 'initializePresenters self layout: SpBoxLayout newLeftToRight'.
	presenterClass class compile: 'defaultPreferredExtent ^ 500@600'.
	
	presenter := presenterClass new.
	presenter extent: 101@202.
	self assert: presenter extent  equals: 101@202.
	
	"It is not clear what is the situation when we set the extent: and we resized we window.
	Normally the last resized value should be returned by the extent."
	
]

{ #category : 'tests - layout' }
SpPresenterTest >> testLayoutIsDefaultLayoutWhenDefaultLayoutAndDefaultSpecDefined [
	| presenterClass |
	
	presenterClass := SpPresenter newAnonymousSubclass.
	presenterClass class compile: 'defaultSpec ^ SpBoxLayout newLeftToRight'.
	presenterClass compile: 'defaultLayout ^ SpGridLayout new'.
	presenter := presenterClass new.
	
	self 
		assert: presenter layout class 
		equals: SpGridLayout
]

{ #category : 'tests - layout' }
SpPresenterTest >> testLayoutIsNotSetWhenAlreadyInitialized [
	
	| presenterClass |
	presenterClass := SpPresenter newAnonymousSubclass.
	presenterClass compile: 'defaultLayout ^ SpGridLayout new'.
	presenterClass compile: 'initializePresenters self layout: SpBoxLayout newLeftToRight'.
	presenter := presenterClass new.
	
	self 
		assert: presenter layout class 
		equals: SpBoxLayout
]

{ #category : 'tests - extent' }
SpPresenterTest >> testPreferredExtentIsDynamicallyComputed [
	"This test shows that the defaultPreferredExtent is computed dynamically.
	It is not stored. 
	
	This is only on resize (if resize is allowed) that the last size is stored.
	See companion test.
	But pay attention Morphic announce a resize when the extent is set and not when 
	the user explicitly resize the windown so the logic is bogus even if the user does not see it.
	"
	
	| presenterClass |
	presenterClass := SpPresenter newAnonymousSubclass.
	presenterClass compile: 'defaultLayout ^ SpGridLayout new'.
	presenterClass compile: 'initializePresenters self layout: SpBoxLayout newLeftToRight'.
	presenterClass class compile: 'defaultPreferredExtent ^ 500@600'.
	
	presenter := presenterClass new.
	self assert: presenter preferredExtent equals: 500@600.
	
	presenterClass class compile: 'defaultPreferredExtent ^ 1000@600'.
	self assert: presenter preferredExtent equals: 1000@600.
	
	
	
	
]

{ #category : 'tests - extent' }
SpPresenterTest >> testPreferredExtentIsNotStoredOnResizeWhenNotResizable [
	"This test shows that resize and its effect on the extent being remembered is only 
	available when resize is true.
	Pay attention Morphic announce a resize when the extent is set and not when 
	the user explicitly resize the windown so the logic is bogus even if the user does not see it."
	
	| presenterClass window |
	presenterClass := SpPresenter newAnonymousSubclass.
	presenterClass compile: 'defaultLayout ^ SpGridLayout new'.
	presenterClass compile: 'initializePresenters self layout: SpBoxLayout newLeftToRight'.
	presenterClass class compile: 'defaultPreferredExtent ^ 500@600'.
	
	presenter := presenterClass new.
	self assert: presenter preferredExtent equals: 500@600.
	window := presenter asWindow.
	window resizable: false. 
	self deny: window isResizable.
	window open.
	
	window resize: 666@6666.
	self assert: presenter preferredExtent equals: 500@600.
	
	presenterClass class compile: 'defaultPreferredExtent ^ 1000@600'.
	
	self assert: presenter class preferredExtent equals: 1000@600.
	window close.
	
	
	
	
]

{ #category : 'tests - extent' }
SpPresenterTest >> testPreferredExtentIsStoredOnResize [
	"Pay attention Morphic announce a resize when the extent is set and not when 
	the user explicitly resize the windown so the logic is bogus even if the user does not see it."

	| presenterClass window |
	presenterClass := SpPresenter newAnonymousSubclass.
	presenterClass compile: 'defaultLayout ^ SpGridLayout new'.
	presenterClass compile: 'initializePresenters self layout: SpBoxLayout newLeftToRight'.
	presenterClass class compile: 'defaultPreferredExtent ^ 500@600'.
	
	presenter := presenterClass new.
	self assert: presenter preferredExtent equals: 500@600.
	window := presenter asWindow.
	self assert: window isResizable.
	window open.
	window resize: 666@6666.
	self assert: presenter preferredExtent equals: 666@6666.
	
	presenterClass class compile: 'defaultPreferredExtent ^ 1000@600'.
	"here even if the defaultPreferredExtent changes, it is not taken into account
	because the resize takes precedence."
	
	self assert: presenter class preferredExtent equals: 666@6666.
	window close.
	
	
	
	
]

{ #category : 'tests' }
SpPresenterTest >> testPresentersIncludesPresentersAddedToTheLayout [
	| p1 p2 |
	
	presenter := SpPresenter new.
	presenter layout: (SpBoxLayout newTopToBottom
		add: (p1 := presenter newLabel);
		add: (p2 := presenter newLabel);
		yourself).
	
	self assert: presenter presenters equals: { p1. p2 }
]

{ #category : 'tests' }
SpPresenterTest >> testTraversePresentersDoIncludesPresentersAddedToTheLayout [
	| p1 p2 result |
	
	presenter := SpPresenter new.
	presenter layout: (SpBoxLayout newTopToBottom
		add: (p1 := presenter newLabel);
		add: (p2 := presenter newLabel);
		yourself).
	
	result := Array streamContents: [ :stream | 
		presenter traversePresentersDo: [ :each | stream << each ] ].	
	self assert: result equals: { presenter. p1. p2 }
]
