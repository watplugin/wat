extends Reference
tool


const TOP_DIRECTORY = ""
const CONFIG = preload("res://addons/WAT/Settings/Config.tres")
const TEST_DIRECTORY = CONFIG.main_test_folder

class TestInfo:
	var directory: String
	var path: String
	var methods: Array = []

static func tests() -> Array:
	if TEST_DIRECTORY.empty() or TEST_DIRECTORY == "res://" or TEST_DIRECTORY == "" or not Directory.new().dir_exists(TEST_DIRECTORY):
		OS.alert("You must set a valid main test folder. You cannot use tests directly in res://")
		return []
	var dirs: Array = [TOP_DIRECTORY]
	var tests: Array = []
	if CONFIG.tests_include_subdirectories:
		dirs += _get_subdirs()
	for subdirectory in dirs:
		tests += _collect_tests("/" + subdirectory)
	return tests

static func _collect_tests(subdirectory) -> Array:
	var path: String = TEST_DIRECTORY + subdirectory
	var results: Array = []
	var ONLY_SEARCH_CHILDREN: bool = true
	var dir: Directory = Directory.new()
	dir.open("%s" % [path])
	dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
	var title: String = dir.get_next()
	while title != "":
		if _valid_test(path, title):
			results.append(load(TEST_DIRECTORY + "/" + subdirectory + "/" + title))
		title = dir.get_next()
	return results
#export(Array, String) var test_scripts_with_prefixes = []
static func _valid_test(path: String, title) -> bool:
	if not title.ends_with(".gd"):
		return false

	if not CONFIG.test_script_prefixes.empty():
		var found_match = false
		for prefix in CONFIG.test_script_prefixes:
			if title.begins_with(prefix):
				found_match = true

		if not found_match:
			return false

	var test = load(path + "/" + title).new()
	if not test is WATTest:
		test.free()
		return false
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
	return method.begins_with(CONFIG.test_method_prefix)