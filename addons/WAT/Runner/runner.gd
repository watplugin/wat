extends Node
tool

const TESTWRAPPER = preload("res://addons/WAT/runner/test_wrapper.gd")
const CASE = preload("res://addons/WAT/runner/case.gd")
const YIELD = preload("res://addons/WAT/runner/Yielder.gd")
var Results: TabContainer
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

func _run(directory: String = "res://tests") -> void:
	if not Directory.new().dir_exists(directory):
		emit_signal("errored")
		push_error("WAT: Test Directory: %s does not exist" % directory)
		return
	clear()
	print("WAT: Starting Test Runner")
	self.tests = validate.tests(filesystem.file_list(directory), settings.test_script_prefixes)
	if self.tests.empty():
		OS.alert("No Scripts to Tests")
		return
	_start()

func _start() -> void:
	if tests.empty():
		print("WAT: Ending Test Runner")
		emit_signal("ended")
		Results.display(caselist)
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

func clear() -> void:
	tests.clear()
	caselist.clear()
	Results.clear()