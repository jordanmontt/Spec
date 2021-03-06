"
Display the toolbar with icons and label only
"
Class {
	#name : #SpIconAndLabelToolbarDisplayMode,
	#superclass : #SpToolbarDisplayMode,
	#category : #'Spec2-Core-Widgets'
}

{ #category : #configuring }
SpIconAndLabelToolbarDisplayMode >> configureButton: aButton item: aToolbarItem [
	"ask for icon and label"
	aButton getLabelSelector: #label.
	aButton getIconSelector: #icon.
	aButton badgeSelector: #badge.
]

{ #category : #accessing }
SpIconAndLabelToolbarDisplayMode >> extent [
	^ 45@45
]

{ #category : #accessing }
SpIconAndLabelToolbarDisplayMode >> styleName [ 

	^ 'toolBar.iconsAndLabel'
]
