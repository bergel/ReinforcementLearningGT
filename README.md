# ReinforcementLearningGT

Implementation of reinforcement learning and Q-Learning in [GlamourousToolkit](https://gtoolkit.com)

It can be loaded using:
```Smalltalk
Metacello new
  baseline: 'ReinforcementLearningGT';
  repository: 'github://bergel/ReinforcementLearningGT:main';
  load
```

To see it in action, simply inspect the following expression:
```Smalltalk
rl := RL new setInitialGrid: (RLGrid new setSize: 8; setZombies: 10; setIceCreamBottomRight).
rl numberOfEpisodes: 100.
rl epsilon: 0.1.
rl run.
rl play.
rl
```
