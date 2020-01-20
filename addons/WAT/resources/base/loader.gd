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
		if test.get("IS_WAT_SUITE"):
			for constant in test.get_script_constant_map():
				var expression: Expression = Expression.new()
				expression.parse(constant)
				var subtest = expression.execute([], test)
				if subtest.get("TEST") != null:
					subtest.set_meta("path", "%s.%s" % [path, constant])
					tests.append(subtest)
	_tests = []
	ResourceSaver.save(resource_path, self)
	return tests
