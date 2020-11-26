extends Node

func load_test_scripts(strategy: Dictionary) -> Array:
	push_warning("Test Loader Lacks Implementation")
	return _duplicate_per_repeat(_load(strategy.paths), strategy.repeat)

func _load(paths: Array) -> Array:
	for path in paths:
		print(path)
	return []

func _duplicate_per_repeat(tests: Array, repeats: int):
	var repeated: Array = tests
	for repeat in repeats:
		repeated += tests.duplicate(true)
	return repeated
