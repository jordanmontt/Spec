"
A presenter to create a menu button (a button who exposes a menu instead having an action) 

"
Class {
	#name : 'SpMenuButtonPresenter',
	#superclass : 'SpAbstractButtonPresenter',
	#instVars : [
		'#menu => ObservableSlot'
	],
	#category : 'Spec2-Core-Widgets',
	#package : 'Spec2-Core',
	#tag : 'Widgets'
}

{ #category : 'specs' }
SpMenuButtonPresenter class >> adapterName [

	^ #MenuButtonAdapter
]

{ #category : 'documentation' }
SpMenuButtonPresenter class >> documentFactoryMethodSelector [

	^ #newMenuButton
]

{ #category : 'api' }
SpMenuButtonPresenter >> fillWith: anActionGroup [ 
	| menuPresenter |
	
	menuPresenter := self newMenu.
	SpActionMenuPresenterBuilder new
		menuPresenter: menuPresenter;
		visit: anActionGroup.
		
	self menu: menuPresenter
	
]

{ #category : 'initialization' }
SpMenuButtonPresenter >> initialize [

	super initialize
]

{ #category : 'api' }
SpMenuButtonPresenter >> menu [
	"Answer the menu (an instance of `SpMenuPresenter` or a block) to show."

	^ menu
]

{ #category : 'api' }
SpMenuButtonPresenter >> menu: aValuable [
	"Set the menu to show. 
	 `aValuable` can be an instance of `SpMenuPresenter` or a block to allow dynamic behavior."

	menu := aValuable
]

{ #category : 'api - events' }
SpMenuButtonPresenter >> whenMenuChangedDo: aBlock [
	"Inform when menu  property has changed. 
	 `aBlock` has three optional arguments: 
	 - new value
	 - old value
	 - the announcement triggering this action"

	self property: #menu whenChangedDo: aBlock
]

{ #category : 'api - events' }
SpMenuButtonPresenter >> windowTitle [

	^ 'MenuButton'
]
