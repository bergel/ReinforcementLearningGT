Class {
	#name : #RLExample,
	#superclass : #Object,
	#category : #'ReinforcementLearningGT-Core'
}

{ #category : #raw }
RLExample >> exampleZombie [
	<script: 'self new exampleZombie'>

	| grid actionUP actionDown actionLeft actionRight actions startState newCarPos act r numberOfEpisodes maxEpisodeSteps minAlpha alphas gamma eps qTable q chooseAction currentState totalReward alpha isDone currentAction tt nextState currentReward result |
	grid := RLGrid new setContent:  '.z.i'.
	actionUP := 1.
	actionDown := 2.
	actionLeft := 3.
	actionRight := 4.
	actions := { actionUP . actionDown . actionLeft . actionRight }.
	startState := RLState new grid: grid; position: 1 @ 1.
	newCarPos := [ :aState :action |
		"return a new position"
		| delta |
		delta := { 0@ -1 . 0@1 . -1@0 . 1@0 } at: action ifAbsent: [ self error: 'Unknown action' ].
		((aState position + delta) min: aState grid extent) max: 1 @ 1
		 ].
	
	act := [ :aState :action |
		| reward newGrid p gridItem tDone |
		p := newCarPos value: aState value: action.
		gridItem := aState grid atPosition: p.
		newGrid := aState grid copy.
		gridItem = $z ifTrue: [ reward := -100. tDone := true ].
		gridItem = $i ifTrue: [ reward := 1000. tDone := true ].
		gridItem = $. ifTrue: [ reward := -1. tDone := false. 
			newGrid atPosition: aState position put: $. .
			newGrid atPosition: p put: $c ].
		gridItem = $c ifTrue: [ reward := -1. tDone := false ].
		{ RLState new grid: newGrid; position: p . reward . tDone }
	].

	r := Random seed: 42.
	numberOfEpisodes := 20.
	maxEpisodeSteps := 100.
	minAlpha := 0.02.
	alphas := (minAlpha to: 1.0 count: numberOfEpisodes) reversed.
	gamma := 1.0.
	eps := 0.2.
	qTable := Dictionary new.
	
	q := [ :state :action |
		qTable at: state ifAbsentPut: [ (1 to: actions size) collect: [ :nU | 0 ] ].
		action isNil 
			ifTrue: [ qTable at: state ]
			ifFalse: [ (qTable at: state) at: action ]
		 ].
	
	chooseAction := [ :state |
		r next < eps
			ifTrue: [ actions atRandom: r ]
			ifFalse: [ (q value: state value: nil) argmax ]
		 ].

	result := OrderedCollection new.
	1 to: numberOfEpisodes do: [ :e |
		currentState := startState.
		totalReward := 0.
		alpha := alphas at: e.
		isDone := false.
		maxEpisodeSteps timesRepeat: [ 
			isDone ifFalse: [ 
				currentAction := chooseAction value: currentState.
				tt := act value: currentState value: currentAction.
				nextState := tt first.
				currentReward := tt second.
				isDone := tt third.
				totalReward := totalReward + currentReward.
				
				(q value: currentState value: nil) at: currentAction put: (
					(q value: currentState value: currentAction) + (alpha * (currentReward + (gamma * (q value: nextState value: nil) max) - (q value: currentState value: currentAction)))).
				currentState := nextState
			]
		].
		Transcript show: ('Episode {1}: total reward -> {2}' format: { e . totalReward }); cr.
		result add: totalReward.
	].
	^ result asArray












]

{ #category : #raw }
RLExample >> exampleZombie02 [
	<script: 'self new exampleZombie02'>

	| grid actionUP actionDown actionLeft actionRight actions startState newCarPos act r numberOfEpisodes maxEpisodeSteps minAlpha alphas gamma eps qTable q chooseAction currentState totalReward alpha isDone currentAction tt nextState currentReward result |
	grid := RLGrid new setContent: '.zz....zi'.
	actionUP := 1.
	actionDown := 2.
	actionLeft := 3.
	actionRight := 4.
	actions := { actionUP . actionDown . actionLeft . actionRight }.
	startState := RLState new grid: grid; position: 1 @ 1.
	newCarPos := [ :aState :action |
		"return a new position"
		| delta |
		delta := { 0@ -1 . 0@1 . -1@0 . 1@0 } at: action ifAbsent: [ self error: 'Unknown action' ].
		((aState position + delta) min: aState grid extent) max: 1 @ 1
		 ].
	
	act := [ :aState :action |
		| reward newGrid p gridItem tDone |
		p := newCarPos value: aState value: action.
		gridItem := aState grid atPosition: p.
		newGrid := aState grid copy.
		gridItem = $z ifTrue: [ reward := -100. tDone := true ].
		gridItem = $i ifTrue: [ reward := 1000. tDone := true ].
		gridItem = $. ifTrue: [ reward := -1. tDone := false. 
			newGrid atPosition: aState position put: $. .
			newGrid atPosition: p put: $c ].
		gridItem = $c ifTrue: [ reward := -1. tDone := false ].
		{ RLState new grid: newGrid; position: p . reward . tDone }
	].

	r := Random seed: 42.
	numberOfEpisodes := 50.
	maxEpisodeSteps := 100.
	minAlpha := 0.02.
	alphas := (minAlpha to: 1.0 count: numberOfEpisodes) reversed.
	gamma := 1.0.
	eps := 0.2.
	qTable := Dictionary new.
	
	q := [ :state :action |
		qTable at: state ifAbsentPut: [ (1 to: actions size) collect: [ :nU | 0 ] ].
		action isNil 
			ifTrue: [ qTable at: state ]
			ifFalse: [ (qTable at: state) at: action ]
		 ].
	
	chooseAction := [ :state |
		r next < eps
			ifTrue: [ actions atRandom: r ]
			ifFalse: [ (q value: state value: nil) argmax ]
		 ].

	result := OrderedCollection new.
	1 to: numberOfEpisodes do: [ :e |
		currentState := startState.
		totalReward := 0.
		alpha := alphas at: e.
		isDone := false.
		maxEpisodeSteps timesRepeat: [ 
			isDone ifFalse: [ 
				currentAction := chooseAction value: currentState.
				tt := act value: currentState value: currentAction.
				nextState := tt first.
				currentReward := tt second.
				isDone := tt third.
				totalReward := totalReward + currentReward.
				
				(q value: currentState value: nil) at: currentAction put: (
					(q value: currentState value: currentAction) + (alpha * (currentReward + (gamma * (q value: nextState value: nil) max) - (q value: currentState value: currentAction)))).
				currentState := nextState
			]
		].
		Transcript show: ('Episode {1}: total reward -> {2}' format: { e . totalReward }); cr.
		result add: totalReward.
	].
	^ result asArray

]

{ #category : #raw }
RLExample >> simple [
	<script: 'self new simple inspect'>

	| rl |
	rl := RL new setInitialGrid: (RLGrid new setSize: 8; setZombies: 10; setIceCreamBottomRight).
	rl numberOfEpisodes: 500.
	rl epsilon: 0.1.
	rl run.

	rl play.
	^ rl
]
