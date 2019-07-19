extends Node
tool

const TESTWRAPPER = preload("res://addons/WAT/runner/test_wrapper.gd")
const CASE = preload("res://addons/WAT/runner/case.gd")
const YIELD = preload("res://addons/WAT/runner/Yielder.gd")
var Results
var settings: Resource
var filesystem: Reference
var validate: Reference
var tests: Array = []
var caselist: Array = []
signal errored
signal ended

func _init(validate: Reference, filesystem: Reference, settings: Resource, Results) -> void:
	self.validate = validate
	self.filesystem = filesystem
	self.settings = settings
	self.Results = Results

func _run(path: String = "res://tests") -> void:
	if not _valid_path(path):
		return
	clear()
	print("WAT: Starting Test Runner")
	self.tests = validate.tests(filesystem.file_list(path))
	if self.tests.empty():
		OS.alert("No Scripts to Tests")
		return
	_start()

func _start() -> void:
	if tests.empty():
		print("WAT: Ending Test Runner")
		Results.display(caselist)
		emit_signal("ended")
		return
	var test = load(tests.pop_front()).new()
	var methods = validate.methods(test.get_method_list(), settings.test_method_prefix)
	var case = CASE.new(test)
	var yielder = YIELD.new()
	var wrapper = TESTWRAPPER.new(test, methods, case, yielder)
	wrapper.add_child(yielder)
	wrapper.add_child(test)
	add_child(wrapper)
	wrapper.connect("ENDED", self, "end")
	wrapper.start()

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
	Results.clear()