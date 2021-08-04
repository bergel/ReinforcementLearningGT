Extension { #name : #SequenceableCollection }

{ #category : #'*ReinforcementLearningGT' }
SequenceableCollection >> argmax [

	"#(1 -3 5 1) argmax >>> 3"

	"#(1 1 1 1) argmax >>> 1"

	^ self indexOf: self max
]
