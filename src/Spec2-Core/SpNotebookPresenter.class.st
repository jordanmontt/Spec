"
I'm a presenter for a tabbed notebook container. 
This is a container whos children are pages (instances of `SpNotebookPage`), which have a title and a content.
"
Class {
	#name : 'SpNotebookPresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#instVars : [
		'#pagesHolder',
		'#selectedPage => ObservableSlot'
	],
	#category : 'Spec2-Core-Widgets-Tab',
	#package : 'Spec2-Core',
	#tag : 'Widgets-Tab'
}

{ #category : 'specs' }
SpNotebookPresenter class >> adapterName [

	^ #NotebookAdapter
]

{ #category : 'documentation' }
SpNotebookPresenter class >> documentFactoryMethodSelector [

	^ #newNotebook
]

{ #category : 'api' }
SpNotebookPresenter >> addPage: aPage [
	"Add a page (an instance of `SpNotebookPage`) to the notebook."

	aPage owner: self.
	pagesHolder add: aPage
]

{ #category : 'api' }
SpNotebookPresenter >> addPageTitle: aString provider: aBlock [ 
	"A convenience method to directly add a page with a provider."
	
	^ self addPage: (SpNotebookPage title: aString provider: aBlock)
]

{ #category : 'testing' }
SpNotebookPresenter >> hasPageNamed: aTitle [

	^ self pages anySatisfy: [ : page | 	page title = aTitle ]
]

{ #category : 'testing' }
SpNotebookPresenter >> hasPages [

	^ self pages isNotEmpty
]

{ #category : 'initialization' }
SpNotebookPresenter >> initialize [

	super initialize.
	pagesHolder := OrderedCollection new asValueHolder.
	pagesHolder whenChangedDo: [ self pagesChanged ]
]

{ #category : 'private' }
SpNotebookPresenter >> pageAt: index [

	^ self pages at: index
]

{ #category : 'api' }
SpNotebookPresenter >> pageNamed: aTitle [
	"Answer the receiver's <SpNotebookPage> with aTitle as name. Raise a <NotFound> exception if not present"

	^ self pages detect: [ : page | page title = aTitle ]
]

{ #category : 'private' }
SpNotebookPresenter >> pageTitleChanged: aPage [ 

	self changed: #updatePageTitle: with: { aPage }
]

{ #category : 'api' }
SpNotebookPresenter >> pages [ 
	"Answer all pages in the notebook."

	^ pagesHolder value
]

{ #category : 'api' }
SpNotebookPresenter >> pages: aCollection [
	"Set all pages of the notebook.
	 `aCollection` contains instances of `SpNotebookPage`."

	aCollection do: [ :each | each owner: self ].
	pagesHolder rawValue: aCollection asOrderedCollection.
	pagesHolder valueChanged: nil
]

{ #category : 'private' }
SpNotebookPresenter >> pagesChanged [

	self changed: #updatePages
]

{ #category : 'api' }
SpNotebookPresenter >> removeAll [
	"Remove all pages in notebook"
	
	selectedPage := nil.
	pagesHolder removeAll
]

{ #category : 'api' }
SpNotebookPresenter >> removePage: aPage [
	"Remove the page `aPage` from the notebook."
	
	pagesHolder remove: aPage
]

{ #category : 'api' }
SpNotebookPresenter >> removePageAt: anIndex [
	"Remove the page at index `anIndex`."

	pagesHolder removeAt: anIndex
]

{ #category : 'api' }
SpNotebookPresenter >> resetAllPageContents [
	"Resets all page contents, forcing a refresh next time a page is selected."

	self pages do: [ :each | each resetContent ]
]

{ #category : 'api' }
SpNotebookPresenter >> selectPage: aPage [
	"Selects the page `aPage` from the notebook, switching to show it."

	aPage = self selectedPage ifTrue: [ ^ self ].
	selectedPage := aPage
]

{ #category : 'api' }
SpNotebookPresenter >> selectPageIndex: aNumber [
	"Select the page with the index `aNumber`."

	self selectPage: (self pages at: aNumber)
]

{ #category : 'api' }
SpNotebookPresenter >> selectedPage [
	"Answer current selected page."

	^ selectedPage
]

{ #category : 'api' }
SpNotebookPresenter >> selectedPageIndex [
	"Answer the index of selected page"
	| page |
	
	page := self selectedPage.
	page ifNil: [ ^ 0 ].
	
	^ self pages indexOf: page
]

{ #category : 'private - traversing' }
SpNotebookPresenter >> traverseInFocusOrderDo: aBlock excluding: excludes [

	excludes add: self.
	aBlock value: self.
	
	self selectedPage ifNil: [ ^ self ].
	self selectedPage activePresenter
		traverseInFocusOrderDo: aBlock 
		excluding: excludes
]

{ #category : 'private' }
SpNotebookPresenter >> updatePageContent: aPage [

	self withAdapterDo: [ :anAdapter | 
		anAdapter updatePageContent: aPage ]
]

{ #category : 'api - events' }
SpNotebookPresenter >> whenPageAddedDo: aBlock [
	"Inform when a page has been added.
	 `aBlock` receives one argument (the added page)"

	pagesHolder whenAddedDo: aBlock
]

{ #category : 'api - events' }
SpNotebookPresenter >> whenPageRemovedDo: aBlock [
	"Inform when a page has been removed.
	 `aBlock` receives one argument (the removed page)"

	pagesHolder whenRemovedDo: aBlock
]

{ #category : 'api - events' }
SpNotebookPresenter >> whenPagesChangedDo: aBlock [
	"Inform when pages has been changed.
	 `aBlock` has three optional arguments: 
	 - new value
	 - old value
	 - the announcement triggering this action"

	pagesHolder whenChangedDo: aBlock
]

{ #category : 'api - events' }
SpNotebookPresenter >> whenSelectedPageChangedDo: aBlock [
	"Inform when selected page has changed.
	 `aBlock` has three optional arguments: 
	 - new value
	 - old value
	 - the announcement triggering this action"

	self 
		property: #selectedPage 
		whenChangedDo: aBlock
]
