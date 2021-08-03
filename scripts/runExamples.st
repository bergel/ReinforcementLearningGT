Metacello new
	baseline: 'ReinforcementLearningGT';
	repository: 'github://bergel/ReinforcementLearningGT/src';
	load.

path := '/tmp/result.txt'.
path asFileReference exists ifTrue: [ path asFileReference delete ].
file := path asFileReference writeStream.

(#'gtExample' gtPragmas & 'ReinforcementLe' gtPackageMatches ) do: [ :each | 
  result := each gtExample run.
  result isSuccess ifFalse: [ file next ].
  file nextPutAll: each asString.
  file crlf
].

file close.

SmalltalkImage current quitPrimitive
