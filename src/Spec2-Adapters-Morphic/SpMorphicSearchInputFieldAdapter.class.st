"
I'm a morphic adapter to provide a search input field
"
Class {
	#name : 'SpMorphicSearchInputFieldAdapter',
	#superclass : 'SpMorphicTextInputFieldAdapter',
	#category : 'Spec2-Adapters-Morphic-Base',
	#package : 'Spec2-Adapters-Morphic',
	#tag : 'Base'
}

{ #category : 'factory' }
SpMorphicSearchInputFieldAdapter >> buildWidget [
	| textMorph iconsContainer |

	textMorph := super buildWidget.
	textMorph submorphsDo: [ :aMorph | 
		aMorph setProperty: #constraints toValue: SpOverlayConstraints new ].

	iconsContainer := Morph new
		extent: 14 @ 12;
		color: Color transparent;
		changeTableLayout;
		listDirection: #topToBottom;
		addMorph: (IconicButtonMorph new
			target: self;
			actionSelector: #clearText;
			labelGraphic: (self iconNamed: #windowCloseInactive);
			color: Color transparent;
			extent: 12 @ 12;
			borderWidth: 0;
			yourself);
		setProperty: #constraints toValue: (SpOverlayConstraints new
			beOverlay;
			hAlignEnd;
			vAlignStart;
			yourself);
		yourself.

	textMorph
		layoutPolicy: SpMorphicOverlayLayout new;
		addMorph: iconsContainer.

	^ textMorph
]

{ #category : 'actions' }
SpMorphicSearchInputFieldAdapter >> clearText [

	self widgetDo: [ :w | w setTextWith: '' ] 
]
