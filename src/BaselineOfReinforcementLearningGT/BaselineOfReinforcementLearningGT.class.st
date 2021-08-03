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
			package: #'ReinforcementLearning'.
		spec 
			group: 'default' with: #( 'ReinforcementLearning' ). ].

]
