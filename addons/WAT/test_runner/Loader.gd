extends Node

func load_test_scripts(strategy: Dictionary) -> Array:
	var scripts = _load(strategy.paths)
	if strategy.has("method"):
		scripts[0].set_meta("method", strategy.method)
	return _duplicate_per_repeat(scripts, strategy.repeat)

func _load(paths: Array) -> Array:
	var scripts: Array = []
	for path in paths:
		var script = load(path)
		if script.get("TEST") != null:
			scripts.append(script)
		elif script.get("IS_WAT_SUITE"):
			scripts += _load_suite(script)
	return scripts
	
func _load_suite(suite: Script):
	var tests: Array = []
	for constant in suite.get_script_constant_map():
		var expr: Expression = Expression.new()
		expr.parse(constant)
		var test = expr.execute([], suite)
		if test.get("TEST") != null:
			test.set_meta("path", "%s.%s" % [suite.get_path(), constant])
			tests.append(test)
	return tests
	
func _duplicate_per_repeat(tests: Array, repeats: int):
	var repeated: Array = tests
	for repeat in repeats:
		repeated += tests.duplicate(true)
	return repeated
