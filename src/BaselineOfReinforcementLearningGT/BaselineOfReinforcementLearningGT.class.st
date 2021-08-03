Class {
	#name : #BaselineOfReinforcementLearningGT,
	#superclass : #BaselineOf,
	#category : #BaselineOfReinforcementLearningGT
}

{ #category : #baselines }
BaselineOfReinforcementLearningGT >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			package: #'ReinforcementLearningGT'.
		spec 
			group: 'default' with: #( 'ReinforcementLearningGT' ). ].

]
