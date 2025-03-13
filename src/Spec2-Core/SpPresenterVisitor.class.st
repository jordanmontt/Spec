Class {
	#name : 'SpPresenterVisitor',
	#superclass : 'Object',
	#category : 'Spec2-Core-Base',
	#package : 'Spec2-Core',
	#tag : 'Base'
}

{ #category : 'visiting' }
SpPresenterVisitor >> visit: aPresenter [
	
	aPresenter acceptVisitor: self
]

{ #category : 'visiting' }
SpPresenterVisitor >> visitDialogWindowPresenter: aPresenter [
]

{ #category : 'visiting' }
SpPresenterVisitor >> visitPopoverPresenter: aPresenter [
]

{ #category : 'visiting' }
SpPresenterVisitor >> visitPresenter: aPresenter [
]

{ #category : 'visiting' }
SpPresenterVisitor >> visitWindowPresenter: aPresenter [
]
