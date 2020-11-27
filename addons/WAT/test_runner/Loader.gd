extends Node

func load_test_scripts(strategy: Dictionary) -> Array:
	# Check for suites at some point too (unless we can load 'em directly?)
	var scripts = _load(strategy.paths)
	if(strategy.has("method")):
		print("setting method: ", strategy.method)
		scripts[0].set_meta("method", strategy.method)
	return _duplicate_per_repeat(scripts, strategy.repeat)

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
