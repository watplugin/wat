extends Node

func load_test_scripts(strategy: Dictionary) -> Array:
	push_warning("Test Loader Lacks Implementation")
	return _load(strategy["paths"])

func _load(paths: Array) -> Array:
	for path in paths:
		print(path)
	return []
