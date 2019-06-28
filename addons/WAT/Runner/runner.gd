extends Node
tool

const TESTWRAPPER = preload("res://addons/WAT/runner/test_wrapper.gd")
const CASE = preload("res://addons/WAT/runner/case.gd")
var Results: TabContainer
var Yield: Node
var settings: Resource
var filesystem: Reference
var validate: Reference
var cases: Reference
var tests: Array = []
var caselist: Array = []
signal ended

func _init(validate: Reference, filesystem: Reference, settings: Resource, Yield: Node, Results) -> void:
	self.validate = validate
	self.filesystem = filesystem
	self.settings = settings
	self.Yield = Yield
	self.Results = Results
	add_child(Yield)

func _run(directory: String = "res://tests") -> void:
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
	var wrapper = TESTWRAPPER.new(test, methods, case, Yield)
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