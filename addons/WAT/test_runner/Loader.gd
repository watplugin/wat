extends Node

func load_test_scripts(strategy: Dictionary) -> Array:
#	match strategy.strategy:
#		"directory", "script":
#			pass
#		"method":
#			pass
#
#	#if(strategy.has("method")):
#
#	# check for method (if so, add method to meta)
#	# check for suites (if so, do what?)
	return _duplicate_per_repeat(_load(strategy.paths), strategy.repeat)

func _load(paths: Array) -> Array:
	var scripts: Array = []
	for path in paths:
		# We're assuming scripts are valid, we may need closer inspection later
		scripts.append(load(path))
	return scripts

func _duplicate_per_repeat(tests: Array, repeats: int):
	var repeated: Array = tests
	for repeat in repeats:
		repeated += tests.duplicate(true)
	return repeated
