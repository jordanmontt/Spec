"
SpAbstractBasicWidget is an abstract class for basic widgets.
"
Class {
	#name : 'SpAbstractWidgetPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'#borderWidth => ObservableSlot',
		'#borderColor => ObservableSlot',
		'#dragEnabled => ObservableSlot',
		'#dropEnabled => ObservableSlot',
		'#color => ObservableSlot',
		'#help => ObservableSlot',
		'#enabled => ObservableSlot',
		'#wantsDrop => ObservableSlot',
		'#acceptDrop => ObservableSlot',
		'#deferredActions'
	],
	#category : 'Spec2-Core-Widgets',
	#package : 'Spec2-Core',
	#tag : 'Widgets'
}

{ #category : 'specs' }
SpAbstractWidgetPresenter class >> adapterName [

	^ self subclassResponsibility
]

{ #category : 'documentation' }
SpAbstractWidgetPresenter class >> addDocumentExtraSections: aBuilder [
	"a hook to add extra sections when needed"
	
]

{ #category : 'documentation' }
SpAbstractWidgetPresenter class >> addDocumentSection: aBuilder label: label methods: methods [
	
	methods ifEmpty: [ ^ self ].
	
	aBuilder newLine.
	aBuilder header: [ :builder | builder text: label ] withLevel: 2.
	aBuilder unorderedListDuring: [  
		(methods sorted: #selector ascending) do: [ :each |
			aBuilder item: [
				aBuilder monospace: (each methodClass name, '>>#', each selector) ] ] ]
]

{ #category : 'documentation' }
SpAbstractWidgetPresenter class >> addDocumentSectionExampleCode: aBuilder [
	| exampleCode |

	exampleCode := self documentExampleCode. 
	exampleCode ifNil: [ ^ self ].
	
	aBuilder newLine.
	aBuilder header: [ :builder | builder text: 'Example code' ] withLevel: 2.
	aBuilder newLine.
	aBuilder codeblock: exampleCode
]

{ #category : 'documentation' }
SpAbstractWidgetPresenter class >> addDocumentSectionFactoryMethod: aBuilder [
	| selector |

	selector := self documentFactoryMethodSelector. 
	selector ifNil: [ ^ self ].
	 
	aBuilder newLine.
	aBuilder header: [ :builder | builder text: 'Factory method' ] withLevel: 2.
	aBuilder newLine.
	aBuilder text: 'You can use '. 
	aBuilder monospace: self name. 
	aBuilder text: ' in your presenters by sending '.
	aBuilder monospace: 'SpPresenter>>#', selector.
	aBuilder text: '.'
]

{ #category : 'documentation' }
SpAbstractWidgetPresenter class >> addDocumentSectionHierarchy: aBuilder [

	aBuilder newLine.
	aBuilder
		header: [ :builder | builder text: 'Hierarchy' ]
		withLevel: 2.
	SpDocumentHierarchyBuilder new
		builder: aBuilder;
		filter: [ :eachClass | eachClass package name beginsWith: 'Spec2-' ];
		buildFor: self
]

{ #category : 'documentation' }
SpAbstractWidgetPresenter class >> addDocumentSectionTransmissions: aBuilder [
	| transmissions defaultInputPort defaultOutputPort |
	
	transmissions := self methods select: [ :each | 
		(each protocolName = self documentTransmissionsProtocol) 
		and: [ (each selector beginsWith: 'default') not ] ].
	transmissions ifEmpty: [ ^ self ].
	
	self methods 
		detect: [ :each | each selector = #defaultInputPort ]
		ifFound: [ :aMethod | defaultInputPort := aMethod literals first ].
	self methods 
		detect: [ :each | each selector = #defaultOutputPort ]
		ifFound: [ :aMethod | defaultOutputPort := aMethod literals first ].
	
	aBuilder newLine.
	aBuilder header: [ :builder | builder text: 'Transmissions' ] withLevel: 2.
	aBuilder unorderedListDuring: [  
		(transmissions sorted: #selector ascending) do: [ :each |
			aBuilder item: [
				aBuilder monospace: (each methodClass name, '>>#', each selector).
				(each selector = defaultInputPort or: [ each selector = defaultOutputPort  ])
					ifTrue: [ aBuilder monospace: ' (default)' ] ] ] ]
]

{ #category : 'layout' }
SpAbstractWidgetPresenter class >> defaultLayout [

	^ SpAbstractWidgetLayout for: self adapterName
]

{ #category : 'documentation' }
SpAbstractWidgetPresenter class >> documentExampleCode [
	| exampleMethod |

	exampleMethod := self class methods
		detect: [ :method | 
			method protocolName = self documentExamplesProtocol 
			and: [ method selector = self documentExampleCodeSelector ] ]
		ifNone: [ ^ nil ].
			
	^ ((exampleMethod sourceCode lines 
		allButFirst 	"Remove method name"
		reject: [ :each | each trimLeft beginsWith: '<' ]) "Remove pragmas"
		joinUsing: Character cr)
		trimmed
]

{ #category : 'documentation' }
SpAbstractWidgetPresenter class >> documentExampleCodeSelector [
	
	^ #example
]

{ #category : 'documentation' }
SpAbstractWidgetPresenter class >> documentExamplesProtocol [
	
	^ #'*Spec2-Examples'
]

{ #category : 'documentation' }
SpAbstractWidgetPresenter class >> documentFactoryMethodSelector [

	^ nil
]

{ #category : 'documentation' }
SpAbstractWidgetPresenter class >> documentSections [

	^ OrderedDictionary newFromPairs: {
			  'Examples'.
			  (self class methods select: [ :method | method protocolName = self documentExamplesProtocol ]).
			  'API Methods'.
			  (self methods select: [ :method | method protocolName = #api ]).
			  'Testing Methods'.
			  (self methods select: [ :method | method protocolName = #testing ]).
			  'Events'.
			  (self methods select: [ :method | method protocolName = #'api - events' ]) }
]

{ #category : 'documentation' }
SpAbstractWidgetPresenter class >> documentTransmissionsProtocol [

	^ #'*Spec2-Transmission'
]

{ #category : 'testing' }
SpAbstractWidgetPresenter class >> isAbstract [
	^ self = SpAbstractWidgetPresenter
]

{ #category : 'api - drag and drop' }
SpAbstractWidgetPresenter >> acceptDrop [
	^ acceptDrop
]

{ #category : 'api - drag and drop' }
SpAbstractWidgetPresenter >> acceptDrop: aBlock [
	acceptDrop := aBlock
]

{ #category : 'private - deferring' }
SpAbstractWidgetPresenter >> addDeferredAction: aBlock [
	"Deferred actions are one-shot actions, performed during adapter initialization."

	deferredActions ifNil: [ deferredActions := #() ].
	deferredActions := deferredActions copyWith: aBlock
]

{ #category : 'private - building' }
SpAbstractWidgetPresenter >> basicBuildAdapterWithLayout: aSpecLayout [
	| builtAdapter |

	builtAdapter := super basicBuildAdapterWithLayout: aSpecLayout.
	self processDeferredActions.
	^ builtAdapter
]

{ #category : 'TOREMOVE' }
SpAbstractWidgetPresenter >> borderColor [
	"Return the border color"

	^ borderColor
]

{ #category : 'TOREMOVE' }
SpAbstractWidgetPresenter >> borderColor: aColor [
	"Set the border width"

	borderColor := aColor
]

{ #category : 'TOREMOVE' }
SpAbstractWidgetPresenter >> borderWidth [
	"Return the border width"

	^ borderWidth
]

{ #category : 'TOREMOVE' }
SpAbstractWidgetPresenter >> borderWidth: anInteger [
	"Set the border width"

	borderWidth := anInteger
]

{ #category : 'TOREMOVE' }
SpAbstractWidgetPresenter >> color [
	^ color
]

{ #category : 'TOREMOVE' }
SpAbstractWidgetPresenter >> color: aColor [
	^ color := aColor
]

{ #category : 'TOREMOVE' }
SpAbstractWidgetPresenter >> defaultColor [
	^ self theme backgroundColor
]

{ #category : 'api' }
SpAbstractWidgetPresenter >> disable [
	"Disable the presenter"
	
	self enabled: false
]

{ #category : 'testing' }
SpAbstractWidgetPresenter >> dragEnabled [
	^ dragEnabled
]

{ #category : 'api - drag and drop' }
SpAbstractWidgetPresenter >> dragEnabled: aBoolean [
	dragEnabled := aBoolean
]

{ #category : 'private - drag and drop' }
SpAbstractWidgetPresenter >> dragTransferFor: passenger from: source [
	"answer a transfer presenter ready to be dragged away from this presenter to 
	 its destination. Allows user to modify elements of it by using the whenDragWillStartDo: 
	 event and touching the transfer object."
	| transfer |
	
	transfer := SpTransferPresenter new
		transfer: passenger;
		from: source;
		yourself.
		
	self announce: (SpDragStartAnnouncement newTransfer: transfer). 
		
	^ transfer
]

{ #category : 'testing' }
SpAbstractWidgetPresenter >> dropEnabled [
	^ dropEnabled
]

{ #category : 'api - drag and drop' }
SpAbstractWidgetPresenter >> dropEnabled: aBoolean [
	dropEnabled := aBoolean
]

{ #category : 'api' }
SpAbstractWidgetPresenter >> enable [
	"Enable the presenter"
	
	self enabled: true
]

{ #category : 'api' }
SpAbstractWidgetPresenter >> enabled: aBooleanOrValuable [
	"Set if the widget is enabled (clickable or focusable).
	This can either be a boolean or a block returning a boolean."

	enabled := aBooleanOrValuable
]

{ #category : 'api' }
SpAbstractWidgetPresenter >> help [
	"Return the help string to display as help (tooltip) to the user."

	^ help
]

{ #category : 'api' }
SpAbstractWidgetPresenter >> help: aString [
	"Set a help string to display to the user if he let the mouse over the widget (a tooltip)."

	help := aString
]

{ #category : 'initialization' }
SpAbstractWidgetPresenter >> initialize [
	super initialize.

	enabled := true.
	dragEnabled := false.
	dropEnabled := false.
	wantsDrop := [ :transfer | self dropEnabled ].
	acceptDrop := [ :transfer | ].
	self whenEnabledChangedDo: [ :value | 
		self withAdapterDo: [ :anAdapter | anAdapter enabled: value ] ].
	self property: #dragEnabled whenChangedDo: [ :value | 
		self withAdapterDo: [ :anAdapter | anAdapter dragEnabled: value  ] ].
	self property: #dropEnabled whenChangedDo: [ :value | 
		self withAdapterDo: [ :anAdapter | anAdapter dropEnabled: value ] ]
]

{ #category : 'testing' }
SpAbstractWidgetPresenter >> isEnabled [
	"Answer if presenter is enabled"

	^ enabled
]

{ #category : 'localization' }
SpAbstractWidgetPresenter >> localeChanged [

	super localeChanged.
	self forceUpdateSlot: #help
	
]

{ #category : 'private - deferring' }
SpAbstractWidgetPresenter >> processDeferredActions [

	deferredActions ifNil: [ ^ self ].
	[
		deferredActions do: [ :eachBlock | eachBlock value ] ]
	ensure: [ 
		deferredActions := nil ]
]

{ #category : 'private' }
SpAbstractWidgetPresenter >> replaceLayoutWith: aLayout [
	"do nothing, widgets do not have updatable layouts"
]

{ #category : 'private - traversing' }
SpAbstractWidgetPresenter >> traverseInFocusOrderDo: aBlock excluding: excludes [

	self canTakeKeyboardFocus ifFalse: [ ^ self ].
	
	excludes add: self.
	aBlock value: self
]

{ #category : 'private - traversing' }
SpAbstractWidgetPresenter >> traversePresentersDo: aBlock excluding: excludes [
	"Terminate"

	excludes add: self.
	aBlock value: self
]

{ #category : 'api - drag and drop' }
SpAbstractWidgetPresenter >> wantsDrop [
	^ wantsDrop
]

{ #category : 'api - drag and drop' }
SpAbstractWidgetPresenter >> wantsDrop: aBlock [
	wantsDrop := aBlock
]

{ #category : 'TOREMOVE' }
SpAbstractWidgetPresenter >> whenBorderColorChangedDo: aBlock [
	"Set a block to be performed when the brder width changed"

	self property: #borderColor whenChangedDo: aBlock
]

{ #category : 'TOREMOVE' }
SpAbstractWidgetPresenter >> whenBorderWidthChangedDo: aBlock [
	"Set a block to be performed when the brder width changed"

	self property: #borderWidth whenChangedDo: aBlock
]

{ #category : 'api - events' }
SpAbstractWidgetPresenter >> whenDragStartDo: aBlock [
	"Informs user a drag is taking place. 
	 `aBlock` receives an SpDragStartAnnouncement as argument."

	self announcer 
		when: SpDragStartAnnouncement 
		do: aBlock
		for: aBlock receiver
]

{ #category : 'api - events' }
SpAbstractWidgetPresenter >> whenEnabledChangedDo: aBlock [
	"Inform when enabled status has changed. 
	 `aBlock` has three optional arguments: 
	 - new value
	 - old value
	 - the announcement triggering this action"

	self property: #enabled whenChangedDo: aBlock
]

{ #category : 'api - events' }
SpAbstractWidgetPresenter >> whenHelpChangedDo: aBlock [
	"Inform when help property has changed. 
	 `aBlock` has three optional arguments: 
	 - new value
	 - old value
	 - the announcement triggering this action"

	self property: #help whenChangedDo: aBlock
]

{ #category : 'private - deferring' }
SpAbstractWidgetPresenter >> withAdapterPerformOrDefer: aBlock [ 

	self adapter 
		ifNotNil: [ :anAdapter | aBlock value: anAdapter ]
		ifNil: [ self addDeferredAction: [ aBlock value: self adapter ] ]
]
