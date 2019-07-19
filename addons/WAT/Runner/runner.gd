extends Node
tool

const TEST_ADAPTER = preload("res://addons/WAT/runner/test_adapter.gd")
const CASE = preload("res://addons/WAT/runner/case.gd")
const YIELD = preload("res://addons/WAT/runner/Yielder.gd")
var filesystem: Reference
var tests: Array = []
var caselist: Array = []
signal errored
signal ended

func _init(filesystem: Reference) -> void:
	self.filesystem = filesystem

func run(path: String) -> void:
	if not _valid_path(path):
		return
	print("WAT: Starting Test Runner")
	caselist = []
	tests = []
	_add_tests(filesystem.file_list(path))
	_start()

func _add_tests(files: Array) -> void:
	# Testnote: Input tests path into runner, compare against results to see if all valid
	for file in files:
		var test: Script = load(file.path)
		if test.get("IS_WAT_TEST") and test.IS_WAT_TEST:
			tests.append(test)

func _no_tests_to_execute() -> bool:
	return tests.empty() and caselist.empty()

func _all_tests_executed() -> bool:
	return tests.empty() and not caselist.empty()

func _start() -> void:
	if _no_tests_to_execute():
		OS.alert("No Scripts to Tests")
		return
	elif _all_tests_executed():
		print("WAT: Ending Test Runner")
		emit_signal("ended", caselist)
		return
	else:
		_execute_next_test()

func _execute_next_test():
	var test = tests.pop_front().new()
	var case = CASE.new(test)
	var yielder = YIELD.new()
	var adapter = TEST_ADAPTER.new(test, case, yielder)
	adapter.add_child(yielder)
	adapter.add_child(test)
	add_child(adapter)
	adapter.connect("ENDED", self, "_end")
	adapter.start()

func _end(case):
	caselist.append(case)
	filesystem.clear_temporary_files()
	call_deferred("_start")

func _valid_path(path: String) -> bool:
	if _script_does_not_exist(path):
		emit_signal("errored")
		push_error("WAT: Script %s does not exist" % path)
		return false
	elif _directory_does_not_exist(path):
		emit_signal("errored")
		push_error("WAT: Directory %s does not exist" % path)
		return false
	return true

func _script_does_not_exist(path: String) -> bool:
	return path.ends_with(".gd") and not Directory.new().file_exists(path)

func _directory_does_not_exist(path: String) -> bool:
	return not path.ends_with(".gd") and not Directory.new().dir_exists(path)