"
I'm an example of an Option List (mac style).
My options reuse a layout already defined in other examples.
"
Class {
	#name : 'SpOptionListExample',
	#superclass : 'SpOptionListPresenter',
	#category : 'Spec2-Examples-Standalone',
	#package : 'Spec2-Examples',
	#tag : 'Standalone'
}

{ #category : 'initialization' }
SpOptionListExample class >> defaultPreferredExtent [

	^ 800@500
]

{ #category : 'examples' }
SpOptionListExample class >> example [

	self new open
]

{ #category : 'examples' }
SpOptionListExample class >> exampleDialog [
	self new openDialog
]

{ #category : 'initialization' }
SpOptionListExample >> allOptions [

	^ { SpProgressBarDemo . SpOptionPresenterExample . SpDemoFormPresenter }
		collect: [ :class | class new ]
]

{ #category : 'initialization' }
SpOptionListExample >> windowTitle [

	^ 'Spec Option List demos'
]
