extends Reference

const FileSystem: Script = preload("res://addons/WAT/system/filesystem.gd")
var _tests: Array = []

func metadata() -> Resource:
	var path = ProjectSettings.get_setting("WAT/Test_Directory")
	var loadpath: String = "%s/.test/metadata.tres" % path
	var object = load(loadpath)
	return object

func deposit(tests: Array) -> void:
	_tests = tests

func withdraw(path: String = ProjectSettings.get("WAT/ActiveRunPath")) -> Array:
	if path.begins_with("Tag."):
		deposit(_tag(path.replace("Tag.", "")))
	elif not path.empty():
		deposit(FileSystem.scripts(path))
	var tests: Array = []
	for path in _tests:
		# Can't load WAT.Test here for whatever reason
		var test = load(path) if path is String else path
		if test.get("TEST") != null:
			tests.append(test)
		elif test.get("IS_WAT_SUITE") and Engine.get_version_info().minor == 2:
			tests += _suite_of_suites_3p2(test)
		elif test.get("IS_WAT_SUITE") and Engine.get_version_info().minor == 1:
			tests += _suite_of_suites_3p1(test)
	_tests = []
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

func _tag(tag):
	var tagged: Array = []
	var path = ProjectSettings.get_setting("WAT/Test_Directory")
	var loadpath: String = "%s/.test/metadata.tres" % path
	var Index = load(loadpath)
	for i in Index.scripts.size():
		if Index.tags[i].has(tag):
			tagged.append(Index.scripts[i].resource_path)
	return tagged
