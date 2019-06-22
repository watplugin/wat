extends Reference
tool


const TOP_DIRECTORY = ""
const TEST_DIRECTORY = "res://tests/"
const CONFIG = preload("res://addons/WAT/Settings/Config.tres")

class TestInfo:
	var directory: String
	var path: String
	var methods: Array = []

static func tests() -> Array:
	var dirs: Array = [TOP_DIRECTORY]
	var tests: Array = []
	if CONFIG.tests_include_subdirectories:
		dirs += _get_subdirs()
	for subdirectory in dirs:
		tests += _collect_tests(subdirectory)
	return tests

static func _collect_tests(subdirectory) -> Array:
	var path: String = TEST_DIRECTORY + subdirectory
	var results: Array = []
	var ONLY_SEARCH_CHILDREN: bool = true
	var dir: Directory = Directory.new()
	dir.open("%s%s" % [TEST_DIRECTORY, subdirectory])
	dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
	var title: String = dir.get_next()
	while title != "":
		if _valid_test(path, title):
			results.append(load(TEST_DIRECTORY + subdirectory + "/" + title))
		title = dir.get_next()
	return results
#export(Array, String) var test_scripts_with_prefixes = []
static func _valid_test(path: String, title) -> bool:
	if not title.ends_with(".gd"):
		return false

	print(CONFIG.test_scripts_with_prefixes, " <- prefix list")
	if not CONFIG.test_scripts_with_prefixes.empty():
		print("searching through prefixes")
		var found_match = false
		for prefix in CONFIG.test_scripts_with_prefixes:
			print("checking prefix")
			if title.begins_with(prefix):
				print("found matching prefix: %s in script: %s/%s" % [prefix, path, title])
				found_match = true

		if not found_match:
			print("no match found")
			return false

	var test = load(path + "/" + title).new()
	if not test is WATTest:
		test.free()
		return false
	print("returning test: %s/%s" % [path, title])
	# if is WATTest
	test.free()
	return true

static func _get_subdirs() -> Array:
	var results: Array = []
	var ONLY_SEARCH_CHILDREN: bool = true
	var dir: Directory = Directory.new()
	dir.open(TEST_DIRECTORY)
	dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
	var title: String = dir.get_next()

	while title != "":
		if dir.current_is_dir():
			results.append(title)
		title = dir.get_next()
	return results


static func methods(test) -> Array:
	var results: Array = []
	for method in test.get_method_list():
		if is_valid_method(method.name):
			results.append(method.name)
	return results

static func is_valid_method(method: String) -> bool:
	if CONFIG.test_methods_with_prefixes.empty():
		return true
	else:
		for prefix in CONFIG.test_methods_with_prefixes:
			if method.begins_with(prefix):
				return true
	return false

