Extension { #name : 'SpMillerColumnPresenter' }

{ #category : '*Spec2-Examples' }
SpMillerColumnPresenter class >> example [

	^ SpMillerColumnPresenter new
		  presenterBlock: [ :model | 
			  SpEasyListViewPresenter new
				  items: (1 to: model);
				  yourself ];
		  setRootModel: 10;
		  open
]
