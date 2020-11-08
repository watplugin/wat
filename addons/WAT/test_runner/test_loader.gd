extends Reference

const FileSystem: Script = preload("res://addons/WAT/system/filesystem.gd")

func get_tests(strategy) -> Array:
	match strategy.get_current_strategy():
		strategy.RUN_ALL:
			return _get_all()
		strategy.RUN_DIRECTORY:
			return _get_directory(strategy.directory())
		strategy.RUN_SCRIPT:
			return _get_script(strategy.script())
		strategy.RUN_TAG:
			return _get_tagged(strategy.tag())
		strategy.RUN_METHOD:
			return _get_script(strategy.script())
		strategy.RERUN_FAILED:
			return _get_last_failed()
		_:
			return []
			
func _get_all() -> Array:
	return _load_tests(FileSystem.scripts(ProjectSettings.get_setting("WAT/Test_Directory")))
	
func _get_directory(_directory: String) -> Array:
	return _load_tests(FileSystem.scripts(_directory))
	
func _get_script(_script: String) -> Array:
	return _load_tests([_script])
	
func _get_last_failed() -> Array:
	return _load_tests(load("res://addons/WAT/resources/results.tres").failures)
	
func _get_tagged(tag: String) -> Array:
	var tagged: Array = []
	var path = ProjectSettings.get_setting("WAT/Test_Directory")
	var loadpath: String = "res://.test/metadata.tres"
	var Index = load(loadpath)
	for i in Index.scripts.size():
		if Index.tags[i].has(tag):
			tagged.append(Index.scripts[i].resource_path)
	var tests = _load_tests(tagged)
	return tests
	
func metadata() -> Resource:
	var path = ProjectSettings.get_setting("WAT/Test_Directory")
	var loadpath: String = "%s/.test/metadata.tres" % path
	var object = load(loadpath)
	return object

func _load_tests(_tests: Array) -> Array:
	var tests: Array = []
	for path in _tests:
		# Can't load WAT.Test here for whatever reason
		if path is String and not path.ends_with(".gd"):
			path = path.substr(0, path.find(".gd") + 3)
		var test = load(path) if path is String else path
		if test.get("TEST") != null:
			tests.append(test)
		elif test.get("IS_WAT_SUITE") and Engine.get_version_info().minor == 2:
			tests += _suite_of_suites_3p2(test)
		elif test.get("IS_WAT_SUITE") and Engine.get_version_info().minor == 1:
			tests += _suite_of_suites_3p1(test)
	return tests

func _suite_of_suites_3p2(suite_of_suites) -> Array:
	var subtests: Array = []
	for constant in suite_of_suites.get_script_constant_map():
		var expression: Expression = Expression.new()
		expression.parse(constant)
		var subtest = expression.execute([], suite_of_suites)
		if subtest.get("TEST") != null:
			subtest.set_meta("path", "%s.%s" % [suite_of_suites.get_path(), constant])
			subtests.append(subtest)
	return subtests
	
func _suite_of_suites_3p1(suite_of_suites) -> Array:
	var subtests: Array = []
	var source = suite_of_suites.source_code
	for l in source.split("\n"):
		if l.begins_with("class"):
			var classname = l.split(" ")[1]
			var expr = Expression.new()
			expr.parse(classname)
			var subtest = expr.execute([], suite_of_suites)
			if subtest.get("TEST") != null:
				subtest.set_meta("path", "%s.%s" % [suite_of_suites.get_path(), classname])
				subtests.append(subtest)
	return subtests
