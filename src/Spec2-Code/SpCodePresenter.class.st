"
I'm a code (Pharo code) presenter. 
I will style and provide completion according to the behaviour being edited.

"
Class {
	#name : 'SpCodePresenter',
	#superclass : 'SpTextPresenter',
	#instVars : [
		'#syntaxHighlight => ObservableSlot',
		'#smartCharacters => ObservableSlot',
		'#lineNumbers => ObservableSlot',
		'#interactionModel => ObservableSlot',
		'#overrideContextMenu',
		'#submitBlock',
		'#resetBlock',
		'#environment',
		'#systemNavigation',
		'#syntaxHighlightTheme => ObservableSlot',
		'#styleScheme'
	],
	#category : 'Spec2-Code-Base',
	#package : 'Spec2-Code',
	#tag : 'Base'
}

{ #category : 'specs' }
SpCodePresenter class >> adapterName [

	^ #CodeAdapter
]

{ #category : 'commands' }
SpCodePresenter class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [

	aCmCommandsGroup beDisplayedAsGroup.
	aCmCommandsGroup register: (self codeSelectionActionCommandsGroupWith: presenter).
	aCmCommandsGroup register: (self codeNavigationCommandsGroupWith: presenter)
]

{ #category : 'commands' }
SpCodePresenter class >> buildEditionCommandsGroupWith: presenter forRoot: aCmCommandsGroup [

	super buildEditionCommandsGroupWith: presenter forRoot: aCmCommandsGroup.	
	aCmCommandsGroup register: (self codeAcceptCommandsGroupWith: presenter)
]

{ #category : 'commands' }
SpCodePresenter class >> codeAcceptCommandsGroupWith: aPresenter [
	| commandGroup |

	commandGroup := (CmCommandGroup named: 'Accept commands') asSpecGroup
		description: 'Accept or cancel changes.';
		beDisplayedAsGroup;
		yourself.
	
	aPresenter hasSubmitAction ifTrue: [ 
		commandGroup register: (SpAcceptChangesCommand forSpecContext: aPresenter) ].
	aPresenter hasResetAction ifTrue: [ 
		commandGroup register: (SpCancelChangesCommand forSpecContext: aPresenter) ].

	^ commandGroup
]

{ #category : 'commands' }
SpCodePresenter class >> codeNavigationCommandsGroupWith: aPresenter [
	| group |
	
	group := (CmCommandGroup named: 'Code search') asSpecGroup
		description: 'Search the system from code selection.';
		beDisplayedAsSubMenu;
		yourself.
		
	self flag: #TODO. "This looks like a very bad way to do this :P"	
	{ 
		SpBrowseClassCommand.		
		SpBrowseImplementorsCommand.
		SpBrowseSendersCommand.
		SpBrowseMethodReferencesCommand.	
		SpBrowseMethodsMatchingStringInsensitiveCommand.
		SpBrowseMethodsMatchingStringSensitiveCommand.
		SpBrowseMethodsContainingStringCommand.
	 } 
	do:[ :commandClass | 
		group register: (commandClass forSpecContext: aPresenter) ].
	
	^ group
]

{ #category : 'commands' }
SpCodePresenter class >> codeSelectionActionCommandsGroupWith: presenter [
	| group |
	
	group := (CmCommandGroup named: 'Selection action commands') asSpecGroup.
	group
		description: 'Actions on code selection.';
		beDisplayedAsGroup.
	
	SpCodeSelectionCommand allOrdered 
		do: [ :cmdClass | group register: (cmdClass forSpecContext: presenter) ].
	
	^ group
]

{ #category : 'documentation' }
SpCodePresenter class >> documentFactoryMethodSelector [

	^ #newCode
]

{ #category : 'examples' }
SpCodePresenter class >> example [

	^ self new
		text: '42 factorial';
		open
]

{ #category : 'examples' }
SpCodePresenter class >> exampleChangingSchemeAndHighlightTheme [
	
	"if you are using a dark theme, this will not look different (use 'codeLight' scheme to see
	 something cool) ;)"
	^ self new
		syntaxHighlightTheme: 'Dark';
		styleScheme: 'codeDark';
		text: '42 factorial';
		open
]

{ #category : 'examples' }
SpCodePresenter class >> exampleOverridingContextMenu [
	"This example will show a code presenter, but context menu will be overriden and 
	 it will show just what is defined in #contextMenu: send"
	
	^ self new
		overridingContextMenu;
		addActionWith: [ :action| action name: 'Testing' ];
		text: 'some method: 42';
		open
]

{ #category : 'api' }
SpCodePresenter >> allowingContextMenu [
	"Indicates the default context menu should be shown (this is the default behaviour). 
	 When allowing the code context menu, visible operations will be collected from  `SpPresenter>>#rootCommandsGroup` and `SpTextPresenter>>#editionCommandsGroup`, and what user 
	 define on `SpAbstractTextPresenter>>contextMenu:` will be appended between those groups."
	
	self overrideContextMenu: false
]

{ #category : 'private' }
SpCodePresenter >> basicInteractionModel: anInteractionModel [

	interactionModel := anInteractionModel
]

{ #category : 'api - model' }
SpCodePresenter >> beForBehavior: aBehavior [
	"used when browsing classes or alike"

	self interactionModel: (SpCodeBehaviorInteractionModel on: aBehavior)
]

{ #category : 'api - model' }
SpCodePresenter >> beForMethod: aMethod [
	"used when browsing methods"

	self interactionModel: (SpCodeMethodInteractionModel on: aMethod)
]

{ #category : 'api - model' }
SpCodePresenter >> beForObject: anObject [
	"Used when inspecting objects"

	self interactionModel: (SpCodeObjectInteractionModel on: anObject)
]

{ #category : 'api - model' }
SpCodePresenter >> beForScripting [
	"Use in playgrounds"

	self interactionModel: SpCodeScriptingInteractionModel new
]

{ #category : 'private - bindings' }
SpCodePresenter >> behavior [
	"Return the class corresponding to the method class of the source code you are editing"
	
	^ self interactionModel ifNotNil: [ :im | im behavior ]
]

{ #category : 'private - bindings' }
SpCodePresenter >> behavior: aClass [
	"Set the class corresponding to the method class of the source code you are editing"
	
]

{ #category : 'private - bindings' }
SpCodePresenter >> bindingOf: aString [

	self interactionModel ifNotNil:  [ :im | ^ im bindingOf: aString  ].
	^ nil
]

{ #category : 'testing' }
SpCodePresenter >> canAddBindingOf: name [

	^ self interactionModel
		  ifNotNil: [ :sp | sp canAddBindingOf: name ]
		  ifNil: [ false ]
]

{ #category : 'api' }
SpCodePresenter >> clearInteractionModel [

	self interactionModel: SpCodeNullInteractionModel new
]

{ #category : 'commands' }
SpCodePresenter >> doBrowseClass [
	| result |

	result := self 
		evaluate: self selectedTextOrLine
		onCompileError: [ ^ self ]
		onError: [ :e | ^ self ].
	(result isKindOf: Symbol)
		ifTrue: [ 
				| classToBrowse |
				classToBrowse := self class environment at: result ifAbsent: [ nil ].	
					classToBrowse ifNotNil: [ ^ self systemNavigation browse: classToBrowse ] ].
	self systemNavigation browse: result 
]

{ #category : 'commands' }
SpCodePresenter >> doBrowseClassReferences [
	| result class |

	result := self 
		evaluate: self selectedTextOrLine
		onCompileError: [ ^ self ]
		onError: [ :e | ^ self ].
		
	(result isClass or: [ result isTrait ])
		ifFalse: [ result := result class ].

	class := result instanceSide.
	class isTrait
		ifTrue: [ self systemNavigation browseAllUsersOfTrait: class ]
		ifFalse: [ self systemNavigation browseAllCallsOnClass: class ]
]

{ #category : 'commands' }
SpCodePresenter >> doBrowseHierarchy [
	| result |

	result := self 
		evaluate: self selectedTextOrLine
		onCompileError: [ ^ self ]
		onError: [ :e | ^ self ].
	(result isClass or: [ result isTrait ])
		ifFalse: [ result := result class ].
	self systemNavigation browseHierarchy: result
]

{ #category : 'commands' }
SpCodePresenter >> doBrowseImplementors [
	| variableOrClassName variable |
	
	variableOrClassName := self selectedSelector ifNil: [ ^ nil ].
	variable := self lookupEnvironment lookupVar: variableOrClassName.
	
	"For global and class variables, implementors-of browses the class of the value of the variable, 
	for classes this means it browses the class"
	(variable isNotNil and: [variable isGlobalVariable or: [variable isClassVariable]]) 
		ifTrue: [ self systemNavigation browse: variable value ]
		ifFalse: [ self systemNavigation browseAllImplementorsOf: variableOrClassName ]
]

{ #category : 'commands' }
SpCodePresenter >> doBrowseMethodReferences [
	"Browse references to Variables (Cmd-shift-n)"
	| variableOrClassName variable usingMethods |

	variableOrClassName := self selectedSelector ifNil: [ ^ nil ].

	variable := self lookupEnvironment lookupVar: variableOrClassName.
	variable ifNil: [ ^ self doBrowseSenders ].
	usingMethods := variable usingMethods ifEmpty: [
		                ^ self inform: 'No users found.' ].

	"the dialog sadly hard-codes 'senders'"
	^ self systemNavigation
		  openBrowserFor: variable name
		  withMethods: usingMethods
]

{ #category : 'commands' }
SpCodePresenter >> doBrowseMethodsContainingString [
	
	self systemNavigation 
		browseMethodsWithSourceString: self selectedTextOrLine 
		matchCase: false
]

{ #category : 'commands' }
SpCodePresenter >> doBrowseMethodsMatchingStringInsensitive [
	
	self systemNavigation 
		browseMethodsWithString: self selectedTextOrLine 
		matchCase: false
]

{ #category : 'commands' }
SpCodePresenter >> doBrowseMethodsMatchingStringSensitive [
	
	self systemNavigation 
		browseMethodsWithString: self selectedTextOrLine 
		matchCase: true
]

{ #category : 'commands' }
SpCodePresenter >> doBrowseSenders [
	| variableOrClassName variable |
	
	variableOrClassName := self selectedSelector ifNil: [ ^ nil ].
	variable := self lookupEnvironment lookupVar: variableOrClassName.

	"For global and class variables, sender-of shows intead the using methods"
	(variable isNotNil and: [(variable isGlobalVariable or: [variable isClassVariable])]) 
		ifTrue: [ self systemNavigation openBrowserFor: variable name withMethods: variable usingMethods  ]
		ifFalse: [ self systemNavigation browseAllReferencesTo: variableOrClassName  ]
		
	
]

{ #category : 'private - bindings' }
SpCodePresenter >> doItContext [

	^ self interactionModel ifNotNil: [ :im | im doItContext ]
]

{ #category : 'private - bindings' }
SpCodePresenter >> doItContext: anObject [

]

{ #category : 'private - bindings' }
SpCodePresenter >> doItReceiver [
	
	^ self interactionModel ifNotNil: [ :im | im doItReceiver ]
]

{ #category : 'private - bindings' }
SpCodePresenter >> doItReceiver: anObject [

]

{ #category : 'command support' }
SpCodePresenter >> environment [

	^ environment ifNil: [ self class environment ]
]

{ #category : 'command support' }
SpCodePresenter >> environment: anEnvironment [
	"Set system environment to be used in commands"
	
	environment := anEnvironment
]

{ #category : 'command support' }
SpCodePresenter >> evaluate: aString onCompileError: compileErrorBlock onError: errorBlock [ 
	"evaluate aString. 
	 evaluate compileErrorBlock if there are compilation errors. 
	 evaluate errorBlock is anything happens *during* evaluation (code compiled, but it does not 
	 executes.). 
	 NOTE for future me. This is how I understand the evaluation works and why we need to catch 
	 differently the error: If there is a syntax error (avoiding compilation), it will evaluate 
	 requestor>>#notify:at:in: to notify the error and then it will call failBlock: *which is not 
	 intended to be used to throw an error*, since that should be handled (and it is) in the 
	 notification. Instead, most users of failBlock: use it to return execution without doing 
	 anything. 
	 Instead, the on:do: will catch all errors happening while executing the code once it is 
	 compiled. "
	| result oldBindings |
	
	^ [
		self announcer announce: (SpCodeWillBeEvaluatedAnnouncement newContent: aString).
		oldBindings := self interactionModel bindings copy.
		result := self interactionModel compiler
			source: aString;
			environment: self environment;
			failBlock:  [ 
				self announcer announce: (SpCodeEvaluationFailedAnnouncement newContent: aString).
				^ compileErrorBlock value ];
			evaluate.
		oldBindings size = self interactionModel bindings size 
			ifFalse: [ self refreshStyling ].
		self announcer announce: (SpCodeEvaluationSucceedAnnouncement newContent: aString).
		result ]
	on: Error 
	do: [ :e |
		self announcer announce: (SpCodeEvaluationFailedAnnouncement 
			newContent: aString
			error: e).
		errorBlock value: e ]
]

{ #category : 'private - bindings' }
SpCodePresenter >> hasBindingOf: aString [

	self interactionModel ifNotNil: [ :im | ^ im hasBindingOf: aString ].
	^ false
]

{ #category : 'private - bindings' }
SpCodePresenter >> hasBindingThatBeginsWith: aString [ 
	
	^ self interactionModel
		ifNotNil: [ :im | im hasBindingThatBeginsWith: aString ] 
		ifNil: [ false ]
]

{ #category : 'private - testing' }
SpCodePresenter >> hasEditionContextMenu [
	"Answer if edition context menu is active. 
	 Edition context menu is available by default, but it can be disabled by calling `SpTextPresenter>>#withoutEditionContextMenu` or `SpCodePresenter>>#overridingContextMenu`"

	^ super hasEditionContextMenu and: [ self isOverrideContextMenu not ]
]

{ #category : 'testing' }
SpCodePresenter >> hasLineNumbers [

	^ lineNumbers
]

{ #category : 'testing' }
SpCodePresenter >> hasResetAction [

	^ resetBlock isNotNil
]

{ #category : 'testing' }
SpCodePresenter >> hasSmartCharacters [

	^ smartCharacters
]

{ #category : 'testing' }
SpCodePresenter >> hasSubmitAction [

	^ submitBlock isNotNil
]

{ #category : 'testing' }
SpCodePresenter >> hasSyntaxHighlight [

	^ syntaxHighlight
]

{ #category : 'initialization' }
SpCodePresenter >> initialize [ 

	super initialize.

	"Use the default menu"
	overrideContextMenu := false.
	
	self withSyntaxHighlight.
	self withSmartCharacters.
	self withLineNumbers.
	
	self registerEventsForStyling.
	self clearInteractionModel
]

{ #category : 'api' }
SpCodePresenter >> insertErrorPopover: aPresenter atIndex: location [

	self selectionInterval: ((location + 1) to: location).
	self insertPopoverAfterCurrentSelection: aPresenter style: 'error'.  
]

{ #category : 'api' }
SpCodePresenter >> insertPopover: aPresenter atIndex: location [

	self selectionInterval: ((location + 1) to: location).
	self insertPopoverAfterCurrentSelection: aPresenter
]

{ #category : 'api' }
SpCodePresenter >> insertPopoverAfterCurrentSelection: aPresenter [

	self 
		insertPopoverAfterCurrentSelection: aPresenter
		style: nil
]

{ #category : 'api' }
SpCodePresenter >> insertPopoverAfterCurrentSelection: aPresenter style: styleName [
	"Popups a popover with contents `aPresenter` after current text selection. 
	 It adds `styleName` to the popover style."

	self withAdapterDo: [ :anAdapter |
		anAdapter insertPopoverAfterCurrentSelection: aPresenter style: styleName ]
]

{ #category : 'api' }
SpCodePresenter >> insertPrintPopoverAfterCurrentSelection: anObject [
	"Inserts a print-it result popover. 
	 This is for use of SpCodePrintItCommand"

	self 
		insertPopoverAfterCurrentSelection: (SpCodePopoverPrintPresenter 
			newCode: self
			object: anObject)
		style: 'print'
]

{ #category : 'api' }
SpCodePresenter >> interactionModel [

	^ interactionModel
]

{ #category : 'api' }
SpCodePresenter >> interactionModel: anInteractionModel [

	anInteractionModel owner: self.
	self basicInteractionModel: anInteractionModel
]

{ #category : 'private - testing' }
SpCodePresenter >> isOverrideContextMenu [

	^ overrideContextMenu
]

{ #category : 'private - bindings' }
SpCodePresenter >> isScripting [

	^ self interactionModel 
		ifNotNil: [ :im | im isScripting ]
		ifNil: [ false ]
]

{ #category : 'private' }
SpCodePresenter >> lineNumbers: aBoolean [

	lineNumbers := aBoolean
]

{ #category : 'command support' }
SpCodePresenter >> lookupEnvironment [
	"when searching for variables, start here"
	^((interactionModel doItContext
		ifNil: [ interactionModel behavior ])
			ifNil: [ environment
				ifNil: [ self class environment ] ])
]

{ #category : 'private - testing' }
SpCodePresenter >> needRequestorScope [

	^ self interactionModel
		  ifNotNil: [ :sp | sp needRequestorScope ]
		  ifNil: [ false ]
]

{ #category : 'private' }
SpCodePresenter >> overrideContextMenu: aBoolean [
	"This property set the type of menu to use: if #overrideContextMenu is false (the default), 
	 the contextMenu will include code presenter default entries. If #overrideContextMenu is true, 
	 just what is defined in #contextMenu will be displayed"

	overrideContextMenu := aBoolean
]

{ #category : 'api' }
SpCodePresenter >> overridingContextMenu [
	"Indicates the context menu should will be overriden. This disabled the default context menu 
	 which includes all operations that can be executed in the context of code.
	 When overriding the code context menu, the only visible operations will be the ones you define 
	 on `SpAbstractTextPresenter>>contextMenu:`"
	
	self overrideContextMenu: true
]

{ #category : 'api' }
SpCodePresenter >> refreshStyling [

	self withAdapterDo: [ :anAdapter | anAdapter refreshStyling ]
]

{ #category : 'initialization' }
SpCodePresenter >> registerEventsForStyling [

	self whenInteractionModelChangedDo: [ :im |
		self withAdapterDo: [ :anAdapter |
			anAdapter interactionModel: im ] ]
]

{ #category : 'api' }
SpCodePresenter >> selectedBehavior [

	^ self behavior
]

{ #category : 'private - bindings' }
SpCodePresenter >> selectedClassOrMetaClass [

	^ self interactionModel ifNotNil: [ :im | im selectedClassOrMetaClass ]
]

{ #category : 'command support' }
SpCodePresenter >> selectedSelector [
	"If text is selected, extract the selectors from the selected text. If there is no selection, try to extract the selectors under the caret position."
	| extractor selectedText fullSource |

	fullSource := self text.
	fullSource ifNil: [ ^ nil ].
	extractor := CNSelectorExtractor new.
	selectedText := self selectedText.
	^ selectedText
		  ifNotEmpty: [ 
				extractor extractSelectorFromSelection: selectedText ]
		  ifEmpty: [ | index |
				index := (self cursorPositionIndex ifNil: [ 1 ]).
				self isScripting 
					ifTrue: [ 
						extractor
						  extractSelectorFromSource: fullSource
						  atPosition: index ]
					ifFalse: [ 
						extractor extractSelectorFromAST: (RBParser parseFaultyMethod: fullSource)
		  					atPosition: index ]
					]
]

{ #category : 'api' }
SpCodePresenter >> selectedTextOrLine [

	self selectedText ifNotEmpty: [ :aString | ^ aString ].
	self selectLine.
	^ self selectedText
]

{ #category : 'private' }
SpCodePresenter >> smartCharacters: aBoolean [

	smartCharacters := aBoolean
]

{ #category : 'api' }
SpCodePresenter >> styleScheme [
	"The name of the style scheme theme to use (e.g. 'Adwaita', 'Adwaita-dark', 'classic', 
	 'classic-dark', 'cobalt', 'cobalt-light', 'kate', 'kate-dark', 'oblivion', 'solarized-dark', 
	 'solarized-light', 'tango'"

	^ styleScheme
]

{ #category : 'api' }
SpCodePresenter >> styleScheme: aSymbol [
 
	"The name of the style scheme theme to use (e.g. 'Adwaita', 'Adwaita-dark', 'classic', 
	 'classic-dark', 'cobalt', 'cobalt-light', 'kate', 'kate-dark', 'oblivion', 'solarized-dark', 
	 'solarized-light', 'tango'. 

	 Note: In morphic this will be interpreted as a simple style (since you can use a style
	 to define a scheme)"

	 styleScheme := aSymbol
]

{ #category : 'private' }
SpCodePresenter >> syntaxHighlight: aBoolean [

	syntaxHighlight := aBoolean 
]

{ #category : 'api' }
SpCodePresenter >> syntaxHighlightTheme [
	"The name of the syntax highlight theme to use (e.g. 'Blue', 'Vintage', 'Solarized', 'Tango'). 
	 If not defined, the component will take the default value from the system."

	^ syntaxHighlightTheme
]

{ #category : 'api' }
SpCodePresenter >> syntaxHighlightTheme: aSymbol [
	"The name of the syntax highlight theme to use (e.g. 'Blue', 'Vintage', 'Solarized', 'Tango')"

	syntaxHighlightTheme := aSymbol
]

{ #category : 'command support' }
SpCodePresenter >> systemNavigation [

	^ (systemNavigation ifNil: [ super systemNavigation ])
		environment: self environment;
		yourself
]

{ #category : 'command support' }
SpCodePresenter >> systemNavigation: aSystemNavigation [

	systemNavigation := aSystemNavigation
]

{ #category : 'api - events' }
SpCodePresenter >> triggerResetAction [

	resetBlock ifNil: [ ^ self ].
	resetBlock value
]

{ #category : 'api - events' }
SpCodePresenter >> triggerSubmitAction [

	submitBlock ifNil: [ ^ self ].
	submitBlock value: self text
]

{ #category : 'api' }
SpCodePresenter >> userActionDuring: aBlock [
	"There are a buch of operations that will all trigger a backend update. A tipical case, 
	 changing text and interactionModel will trigger the text-changed event 3 times and that 
	 may cause an excesive compute that we want to avoid. 
	 We use #userActionDuring: to avoid that. 
	[[[language=Smalltalk
	aCodePresenter userActionDuring: [ 
		aCodePresenter
			beForScription;
			text: '42 factorial' ]
	]]]."
	
	self withAdapterDo: [ :anAdapter | 
		anAdapter userActionDuring: aBlock.
		^ self ].
	
	aBlock value
]

{ #category : 'api - events' }
SpCodePresenter >> whenInteractionModelChangedDo: aBlock [
	"Set a block to perform when the behavior class changed"
	
	self 
		property: #interactionModel
		whenChangedDo: aBlock
]

{ #category : 'api - events' }
SpCodePresenter >> whenLineNumbersChangedDo: aBlock [
	"Set a block to perform when the syntax highlight is enabled/disabled"

	self property: #lineNumbers whenChangedDo: aBlock
]

{ #category : 'api - events' }
SpCodePresenter >> whenResetDo: aBlock [

	resetBlock := aBlock.
	super whenResetDo: aBlock
]

{ #category : 'api - events' }
SpCodePresenter >> whenSmartCharactersChangedDo: aBlock [
	"Set a block to perform when the smart characters is enabled/disabled"

	self property: #smartCharacters whenChangedDo: aBlock
]

{ #category : 'api - events' }
SpCodePresenter >> whenSubmitDo: aBlock [
	"This method will add a 'submit' event to the widget. It will react when user 
	 presses <meta+s> key (this is for historical reasons) and with enter (cr).
	 `aBlock` receives one argument (the submited text)"

	submitBlock := aBlock.
	super whenSubmitDo: aBlock
]

{ #category : 'api - events' }
SpCodePresenter >> whenSyntaxHighlightChangedDo: aBlock [
	"Set a block to perform when the syntax highlight is enabled/disabled"

	self property: #syntaxHighlight whenChangedDo: aBlock
]

{ #category : 'api - events' }
SpCodePresenter >> whenSyntaxHighlightThemeChangedDo: aBlock [
	"Set a block to perform when the syntax highlight theme is changed"

	self property: #syntaxHighlightTheme whenChangedDo: aBlock
]

{ #category : 'private' }
SpCodePresenter >> windowTitle [

	^ 'Code'
]

{ #category : 'api' }
SpCodePresenter >> withLineNumbers [

	self lineNumbers: true
]

{ #category : 'api' }
SpCodePresenter >> withSmartCharacters [

	self smartCharacters: true
]

{ #category : 'api' }
SpCodePresenter >> withSyntaxHighlight [

	self syntaxHighlight: true
]

{ #category : 'api' }
SpCodePresenter >> withoutLineNumbers [

	self lineNumbers: false
]

{ #category : 'api' }
SpCodePresenter >> withoutSmartCharacters [

	self smartCharacters: false
]

{ #category : 'api' }
SpCodePresenter >> withoutSyntaxHighlight [

	self syntaxHighlight: false
]
