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
		elif test.get("IS_WAT_SUITE") and Engine.get_version_info().minor == 2:
			for constant in test.get_script_constant_map():
				var expression: Expression = Expression.new()
				expression.parse(constant)
				var subtest = expression.execute([], test)
				if subtest.get("TEST") != null:
					subtest.set_meta("path", "%s.%s" % [path, constant])
					tests.append(subtest)
		elif test.get("IS_WAT_SUITE") and Engine.get_version_info().minor == 1:
			var source = test.source_code
			for l in source.split("\n"):
				if l.begins_with("class"):
					var classname = l.split(" ")[1]
					var expr = Expression.new()
					expr.parse(classname)
					var subtest = expr.execute([], test)
					if subtest.get("TEST") != null:
						subtest.set_meta("path", "%s.%s" % [path, classname])
						tests.append(subtest)
	_tests = []
	ResourceSaver.save(resource_path, self)
	return tests
