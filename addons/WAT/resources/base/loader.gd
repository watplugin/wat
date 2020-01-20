tool
extends Resource

export(Array) var _tests: Array = []

func deposit(tests: Array) -> void:
	_tests = tests
	ResourceSaver.save(resource_path, self)
	
func withdraw() -> Array:
	var tests: Array = []
	for path in _tests:
		# Can't load WAT.Test here for whatever reason
		var test = load(path) if path is String else path
		if test.get("TEST") != null:
			tests.append(test)
	_tests = []
	ResourceSaver.save(resource_path, self)
	return tests
