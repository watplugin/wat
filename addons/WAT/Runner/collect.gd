extends Reference
tool

#
#
#class TestScript:
#	var directory: String
#	var path: String
#	var methods: Array = []
#
#static func _tests() -> Array:
#	pass
#
#static func methods(test) -> Array:
#	var results: Array = []
#	for method in test.get_method_list():
#		if is_valid_method(method.name):
#			results.append(method.name)
#	return results
#
#static func is_valid_method(method: String) -> bool:
#	for prefix in Array(WATConfig.method_prefixes().split(",")):
#		if method.begins_with(prefix.dedent() + "_"):
#			return true
#	return false
#
#static func ___tests() -> Array:
#	var tests: Array = []
#	var dirs: Array = _get_subdirs()
#	dirs.push_front("")
#	for d in dirs:
#		tests += _testloop(d)
#	return tests
#
#static func ____get_subdirs() -> Array:
#	var results: Array = []
#	var ONLY_SEARCH_CHILDREN: bool = true
#	var dir: Directory = Directory.new()
#	dir.open(TEST_DIRECTORY)
#	dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
#	var title: String = dir.get_next()
#	while title != "":
#		if dir.current_is_dir():
#			results.append(title)
#		title = dir.get_next()
#	return results
#
#static func _testloop(d):
#	var results: Array = []
#	var ONLY_SEARCH_CHILDREN: bool = true
#	var dir: Directory = Directory.new()
#	dir.open("%s%s" % [TEST_DIRECTORY, d])
#	dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
#	var title: String = dir.get_next()
#	while title != "":
#		if valid_title(title):
#			results.append(load(TEST_DIRECTORY + d + "/" + title))
#		title = dir.get_next()
#	return results
#
#static func valid_title(title: String) -> bool:
#	if not title.ends_with(".gd"):
#		return false
#	for prefix in Array(WATConfig.script_prefixes().split(",")):
#		if title.begins_with(prefix.dedent() + "_"):
#			return true
#	return false
#
