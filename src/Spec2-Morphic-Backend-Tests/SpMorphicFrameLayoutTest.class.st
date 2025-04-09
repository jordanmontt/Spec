Class {
	#name : 'SpMorphicFrameLayoutTest',
	#superclass : 'TestCase',
	#instVars : [
		'instance',
		'backend'
	],
	#category : 'Spec2-Morphic-Backend-Tests',
	#package : 'Spec2-Morphic-Backend-Tests'
}

{ #category : 'tests' }
SpMorphicFrameLayoutTest >> testFrameWithoutChildThrowsAnError [
	| presenter  |

	presenter := SpPresenter new.
	presenter layout: SpFrameLayout new.

	presenter build.
	self assert: presenter adapter children isEmpty
]

{ #category : 'tests' }
SpMorphicFrameLayoutTest >> testFrameWithoutLabelOpensWithoutError [
	| presenter tabPresenter1 |
	
	presenter := SpPresenter new.
	presenter layout: (SpFrameLayout new 
		child: (SpTabLayout new
			add: (tabPresenter1 := presenter newLabel 
					label: 'Tab1'; 
					yourself)
				label: 'Tab1';
			yourself);
		yourself).

	presenter build.
	
	self assert: presenter adapter widgetLabel isNotNil
]
