extends Node
tool

const MAIN: String = "Main"
const TEST_ADAPTER = preload("res://addons/WAT/Runner/test_adapter.gd")
const CASE = preload("res://addons/WAT/Runner/case.gd")
const YIELD = preload("res://addons/WAT/Runner/Yielder.gd")
var filesystem: Reference
var tests: Array = []
var caselist: Array = []
signal errored
signal ended

func _init(filesystem: Reference) -> void:
	self.filesystem = filesystem
	
func _create_temp():
	if not Directory.new().dir_exists("%s/WATemp" % OS.get_user_data_dir()):
		Directory.new().make_dir("%s/WATemp" % OS.get_user_data_dir())

func run(path: String) -> void:
	_create_temp()
	caselist = []
	tests = []
	if not _valid_path(path):
		push_warning("%s is invalid" % path)
		emit_signal("ended", caselist)
		return
	if name == MAIN:
		print("WAT: Starting Test Runner")
	_add_tests(filesystem.file_list(path))
	_start()

func _add_tests(files: Array) -> void:
	# Testnote: Input tests path into runner, compare against results to see if all valid
	for file in files:
		var test: Script = load(file.path)
		if test.get("IS_WAT_TEST") and test.IS_WAT_TEST:
			tests.append(test)
		elif test.get("IS_WAT_SUITE") and test.IS_WAT_SUITE:
			var t = test.new()
			var inner_tests: Array = t.subtests()
			for inner in inner_tests:
				tests.append(inner)

func _no_tests_to_execute() -> bool:
	return tests.empty() and caselist.empty()

func _all_tests_executed() -> bool:
	return tests.empty() and not caselist.empty()

func _start() -> void:
	if _no_tests_to_execute():
		if name == MAIN:
			push_warning("WAT: No Scripts to Test")
		emit_signal("ended", caselist)
		return
	elif _all_tests_executed():
		if name == MAIN:
			print("WAT: Ending Test Runner")
		for case in caselist:
			case.calculate()
		emit_signal("ended", caselist)
		return
	else:
		_execute_next_test()

func _execute_next_test() -> void:
	var test: WATTest = tests.pop_front().new()
	var adapter: TEST_ADAPTER = TEST_ADAPTER.new(test, YIELD.new(), CASE.new())
	add_child(adapter)
	adapter.connect("ENDED", self, "_end")
	test.connect("clear", filesystem, "clear_temporary_files")
	adapter.start()

func _end(case: CASE) -> void:
	caselist.append(case)
	filesystem.clear_temporary_files()
	call_deferred("_start")

func _valid_path(path: String) -> bool:
	if _path_is_empty(path):
		emit_signal("errored")
		if name == MAIN:
			push_warning("WAT: TestPath %s is empty" % path)
		return false
	if _directory_does_not_exist(path):
		emit_signal("errored")
		if name == MAIN:
			push_warning("WAT: Directory %s does not exist" % path)
		return false
	elif _script_does_not_exist(path):
		emit_signal("errored")
		if name == MAIN:
			push_warning("WAT: Script %s does not exist" % path)
		return false
	return true
	
func _path_is_empty(path: String) -> bool:
	return path == ""

func _script_does_not_exist(path: String) -> bool:
	return path.ends_with(".gd") and not Directory.new().file_exists(path)

func _directory_does_not_exist(path: String) -> bool:
	return not path.ends_with(".gd") and not Directory.new().dir_exists(path)
