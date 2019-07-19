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
	_add_tests(filesystem.file_list(path))
	print("WAT: Starting Test Runner")
	if self.tests.empty():
		OS.alert("No Scripts to Tests")
		return
	_start()

func _add_tests(files: Array) -> void:
	# Testnote: Input tests path into runner, compare against results to see if all valid
	for file in files:
		var test: Script = load(file.path)
		if _is_WAT_test(test):
			tests.append(test)

static func _is_WAT_test(script: Script) -> bool:
	return script.get("IS_WAT_TEST") and script.IS_WAT_TEST

func _start() -> void:
	if tests.empty():
		print("WAT: Ending Test Runner")
		emit_signal("ended", caselist)
		return
	var test = tests.pop_front().new()
	var case = CASE.new(test)
	var yielder = YIELD.new()
	var adapter = TEST_ADAPTER.new(test, case, yielder)
	adapter.add_child(yielder)
	adapter.add_child(test)
	add_child(adapter)
	adapter.connect("ENDED", self, "end")
	adapter.start()

func end(case):
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

func clear() -> void:
	tests.clear()
	caselist.clear()