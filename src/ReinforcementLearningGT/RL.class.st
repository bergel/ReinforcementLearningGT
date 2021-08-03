Class {
	#name : #RL,
	#superclass : #Object,
	#instVars : [
		'startState',
		'r',
		'numberOfEpisodes',
		'maxEpisodeSteps',
		'minAlpha',
		'gamma',
		'qTable',
		'rewards',
		'path',
		'epsilon'
	],
	#category : #'ReinforcementLearningGT-Core'
}

{ #category : #running }
RL >> act: aState action: action [
	| reward newGrid p gridItem isDone |
	p := self newCar: aState action: action.
	gridItem := aState grid atPosition: p.
	newGrid := aState grid copy.
	gridItem = $z ifTrue: [ reward := -100. isDone := true ].
	gridItem = $i ifTrue: [ reward := 1000. isDone := true ].
	('zi' includes: gridItem) ifFalse: [ reward := -1. isDone := false ].
"	gridItem = $. ifTrue: [ reward := -1. isDone := false. 
		newGrid atPosition: aState position put: $. .
		newGrid atPosition: p put: $c ].
	gridItem = $c ifTrue: [ reward := -1. isDone := false ]."
	^ { RLState new grid: newGrid; position: p . reward . isDone }

]

{ #category : #actions }
RL >> actions [
	"Return the considered actions"
	^ #(1 2 3 4)
]

{ #category : #running }
RL >> chooseAction: state [
	^ r next < epsilon
		ifTrue: [ self actions atRandom: r ]
		ifFalse: [ 
			"Return the best action"
			(self qState: state) argmax ]

]

{ #category : #accessing }
RL >> epsilon: aFloat [
	"Set the probability to explore the world. The argument is between 0.0 and 1.0"
	epsilon := aFloat
]

{ #category : #accessing }
RL >> gtQTableFor: aView [
	<gtView>
	| tt b |
	b := [ :aValue |
				tt := aValue round: 2.
				(tt > 0) 
					ifTrue: [ tt asString asRopedText foreground: Color green darker darker ]
					ifFalse: [ tt asString asRopedText foreground: Color red ] ].
	^ aView columnedList
		title: 'QTable';
		items: [ qTable associations ];
		column: 'State' text: #key;
		column: '^' text: [ :assoc | b value: assoc value first ] ;
		column: 'V' text: [ :assoc | b value: assoc value second ];
		column: '<' text: [ :assoc | b value: assoc value third ];
		column: '>' text: [ :assoc | b value: assoc value fourth ]
]

{ #category : #accessing }
RL >> gtStepsFor: aView [
	<gtView>
	^ aView list
		title: 'Result steps';
		items: [ self play ]

]

{ #category : #initialization }
RL >> initialize [
	super initialize.
	r := Random seed: 42.
	numberOfEpisodes := 20.
	maxEpisodeSteps := 100.
	minAlpha := 0.02.
	gamma := 1.0.
	epsilon := 0.2.
	qTable := Dictionary new.
	rewards := OrderedCollection new.
	path := OrderedCollection new
]

{ #category : #visualization }
RL >> inspectorQTable [
	<inspectorPresentationOrder: 90 title: 'QTable'>
	
	^ SpRoassal3InspectorPresenter new
		canvas: self visualizeQTable;
		yourself
]

{ #category : #visualization }
RL >> inspectorQTableContext: aContext [
	aContext withoutEvaluator
]

{ #category : #visualization }
RL >> inspectorReward [
	<inspectorPresentationOrder: 90 title: 'Reward'>
	
	^ SpRoassal3InspectorPresenter new
		canvas: self visualizeReward;
		yourself
]

{ #category : #visualization }
RL >> inspectorRewardContext: aContext [
	aContext withoutEvaluator
]

{ #category : #visualization }
RL >> inspectorStartState [
	<inspectorPresentationOrder: 90 title: 'Start state'>
	
	^ SpRoassal3InspectorPresenter new
		canvas: self visualize;
		yourself
]

{ #category : #visualization }
RL >> inspectorStartStateContext: aContext [
	aContext withoutEvaluator
]

{ #category : #accessing }
RL >> maxEpisodeSteps: anInteger [
	maxEpisodeSteps := anInteger 
]

{ #category : #running }
RL >> newCar: state action: action [
	"Return the new position of a car, as a point. The action is a number from 1 to 4.
	**Maybe we should have a RLCar class**
	return a new position"
	| delta |
	delta := { 0@ -1 . 0@1 . -1@0 . 1@0 } at: action ifAbsent: [ self error: 'Unknown action' ].
	^ ((state position + delta) min: state grid extent) max: 1 @ 1

]

{ #category : #accessing }
RL >> numberOfEpisodes: aNumber [
	numberOfEpisodes := aNumber
]

{ #category : #playing }
RL >> play [
	"Return the position of the car"
	| currentState isDone actions tupple maxNumberOfSteps numberOfSteps |
	currentState := startState.
	isDone := false.
	path := OrderedCollection new.
	path add: currentState position.
	maxNumberOfSteps := 100.
	numberOfSteps := 0.
	[ isDone not and: [ numberOfSteps < maxNumberOfSteps ] ] whileTrue: [
		actions := self qState: currentState.
		tupple := self act: currentState action: actions argmax.
		currentState := tupple first.
		path add: currentState position.
		isDone := tupple third.
		numberOfSteps := numberOfSteps + 1.
	].
	
	^ path asArray
	
]

{ #category : #running }
RL >> qState: state [ 
	qTable at: state ifAbsentPut: [ (1 to: self actions size) collect: [ :nU | 0 ] ].
	^ qTable at: state
]

{ #category : #running }
RL >> qState: state action: action [
	qTable at: state ifAbsentPut: [ (1 to: self actions size) collect: [ :nU | 0 ] ].
	^ (qTable at: state) at: action
]

{ #category : #running }
RL >> run [

	| alphas currentState totalReward alpha isDone currentAction tupple nextState currentReward |
	alphas := (minAlpha to: 1.0 count: numberOfEpisodes) reversed.
	rewards := OrderedCollection new.
	1 to: numberOfEpisodes do: [ :e |
		currentState := startState.
		totalReward := 0.
		alpha := alphas at: e.
		isDone := false.
		maxEpisodeSteps timesRepeat: [ 
			isDone ifFalse: [ 
				currentAction := self chooseAction: currentState.
				tupple := self act: currentState action: currentAction.
				nextState := tupple first.
				currentReward := tupple second.
				isDone := tupple third.
				totalReward := totalReward + currentReward.
				
				(self qState: currentState) at: currentAction put: (
					(self qState: currentState action: currentAction) + (alpha * (currentReward + (gamma * (self qState: nextState) max) - (self qState: currentState action: currentAction)))).
				currentState := nextState
			]
		].
		rewards add: totalReward.
	].
	rewards := rewards asArray.
	^ rewards








]

{ #category : #initialization }
RL >> setInitialContent: aString [
	self setInitialGrid: (RLGrid new setContent: aString)
]

{ #category : #initialization }
RL >> setInitialGrid: aGrid [
	startState := RLState new grid: aGrid; position: 1 @ 1.

]

{ #category : #accessing }
RL >> startState [
	^ startState
]

{ #category : #visualization }
RL >> visualize [
	| c s |
	c := startState visualize.
	path do: [ :p |
		s := RSCircle new size: 5; color: Color blue lighter lighter.
		c add: s.
		s translateTo: p - (0.5 @ 0.5) * 20.
	].
	^ c @ RSCanvasController
]

{ #category : #visualization }
RL >> visualizeQTable [
	| c state values allBoxes sortedAssociations |
	c := RSCanvas new.
	
	c add: (RSLabel text: 'State').
	c add: (RSLabel text: '^').
	c add: (RSLabel text: 'V').
	c add: (RSLabel text: '<').
	c add: (RSLabel text: '>').
	
	sortedAssociations := qTable associations reverseSortedAs: [ :assoc | assoc value average ].
	sortedAssociations do: [ :assoc |
		state := RSLabel model: assoc key.
		values := RSBox 
						models: (assoc value collect: [ :v | v round: 2 ]) 
						forEach: [ :s :m | s extent: 40 @ 20 ].
		c add: state.
		c addAll: values.
	].
	RSCellLayout new lineItemsCount: 5; gapSize: 1; on: c shapes.
	allBoxes := c shapes select: [ :s | s class == RSBox ].
	RSNormalizer color
		shapes: allBoxes;
		from: Color red; to: Color green;
		normalize.
	allBoxes @ RSLabeled middle.
	^ c @ RSCanvasController
]

{ #category : #visualization }
RL >> visualizeReward [
	| c plot |
	c := RSChart new.
	plot := RSLinePlot new.
	plot y: rewards.
	c addPlot: plot.
	c addDecoration: (RSChartTitleDecoration new title: 'Reward evolution'; fontSize: 20).
	c xlabel: 'Episode' offset: 0 @ 10.
	c ylabel: 'Reward' offset: -20 @ 0.
	c addDecoration: (RSHorizontalTick new).
	c addDecoration: (RSVerticalTick new).
	c build.
	^ c canvas
]
