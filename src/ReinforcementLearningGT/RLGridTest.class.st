Class {
	#name : #RLGridTest,
	#superclass : #Object,
	#category : #'ReinforcementLearningGT-Tests'
}

{ #category : #'test - grid' }
RLGridTest >> testContent [
	<gtExample>
	| g cc |
	g := RLGrid new.
	cc := g content flatCollect: #yourself.
	self assert: cc size equals: 4.
	self assert: cc equals: (Array new: 4 withAll: $.)
]

{ #category : #'test - grid' }
RLGridTest >> testContent02 [
	<gtExample>
	| g |
	g := RLGrid new.
	self assert: (g at: 1 at: 1) equals: $..
	g at: 1 at: 1 put: 2.
	self assert: (g at: 1 at: 1) equals: 2.
]

{ #category : #'test - grid' }
RLGridTest >> testGrid [
	<gtExample>
	| g |
	g := RLGrid new.
	self assert: g content size equals: 2.
	self assert: (g content collect: #size) asSet asArray equals: #(2).
	self assert: g extent equals: 2 @ 2
]

{ #category : #'test - grid' }
RLGridTest >> testGrid02 [
	<gtExample>
	| g |
	g := RLGrid new.
	g setSize: 10.
	self assert: g content size equals: 10.
	self assert: (g content collect: #size) asSet asArray equals: #(10)
]

{ #category : #'test - grid' }
RLGridTest >> testGridPrinting [
	<gtExample>
	| g |
	g := RLGrid new.
	self assert: g printString equals:
'..
..
'
]

{ #category : #'test - grid' }
RLGridTest >> testGridSetContent [
	<gtExample>
	| g |
	g := RLGrid new.
	g setContent: 'i*zc'.
	self assert: g printString equals:
'i*
zc
'
]

{ #category : #'test - grid' }
RLGridTest >> testNumberOfZombies [
	<gtExample>
	| grid |
	grid := RLGrid new setContent: 'i.z.'.
	self assert: grid numberOfZombies equals: 1
]

{ #category : #'test - grid' }
RLGridTest >> testNumberOfZombies02 [
	<gtExample>
	self assert: RLGrid new numberOfZombies equals: 0
]

{ #category : #'test - grid' }
RLGridTest >> testNumberOfZombies03 [
	<gtExample>
	self assert: (RLGrid new setSize: 20; setZombies: 5; numberOfZombies) equals: 5
]

{ #category : #'test - grid' }
RLGridTest >> testSetContent [
	<gtExample>
	| grid |
	grid := RLGrid new setContent: '.zzz....i'.
	self assert: grid extent equals: 3 @ 3.
	self assert: grid contentAsString equals: '.zzz....i'.
	
]

{ #category : #visualization }
RLGridTest >> testVisualization01 [
	<gtExample>
	| g c |
	g := RLGrid new.
	c := g visualize.
	self assert: c class equals: RSCanvas.
	self assert: c numberOfShapes equals: g contentAsString size
]
