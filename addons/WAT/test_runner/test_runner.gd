extends Node

# const strategy: Script = preload("res://addons/WAT/core/test_runner/strategy.gd")
const COMPLETED: String = "completed"
var JunitXML = preload("res://addons/WAT/resources/JUnitXML.gd").new()
var test_loader: Reference = preload("test_loader.gd").new()
var test_results: Resource = WAT.Results
var _tests: Array = []
var _cases: Array = []
var is_editor: bool = true
signal ended
var _time: float
var strategy: Reference = preload("res://addons/WAT/test_runner/strategy.gd").new()
var test_double_registry: Node = preload("res://addons/WAT/double/registry.gd").new()
var time_taken: float

func _ready() -> void:
	_time = OS.get_ticks_msec()
	if get_tree().root.get_child(0) == self:
		print("Starting WAT Test Runner")
	OS.window_minimized = ProjectSettings.get_setting(
			"WAT/Minimize_Window_When_Running_Tests")
	_begin()
	
func _begin():
	_tests = get_tests()
	if _tests.empty():
		push_warning("No Scripts To Test")
	_run_tests()
	
func get_tests() -> Array:
	return test_loader.get_tests(strategy)

func _run_tests() -> void:
	while not _tests.empty():
		yield(run(create_test()), COMPLETED)
	time_taken = _time / 1000.0
	end()
		
func create_test(test_script: WAT.Test = _tests.pop_front()) -> Node:
	var test = test_script.new()
	var testcase = WAT.TestCase.new(test.title(), test.path())
	test.setup(WAT.Asserts.new(), WAT.Yielder.new(), testcase, \
		WAT.TestDoubleFactory.new(), WAT.SignalWatcher.new(), WAT.Parameters.new(),
		WAT.Recorder, test_double_registry)
	return test

func run(test) -> void:
	var testcase = test._testcase
	var start_time = OS.get_ticks_msec()
	add_child(test)
	
	# Add strategy Here?
	if not strategy.method().empty():
		test._methods = [strategy.method()]
	else:
		test._methods = test.methods()
	
	test._start()
	var time = OS.get_ticks_msec() - start_time
	testcase.time_taken = time / 1000.0
	yield(test, COMPLETED)
	testcase.calculate()
	_cases.append(testcase.to_dictionary())
	remove_child(test)
	
func end() -> void:
	print("Ending WAT Test Runner")
	OS.window_minimized = false
	JunitXML.save(_cases, time_taken)
	test_results.deposit(_cases)
	emit_signal("ended")
	if(is_editor):
		get_tree().quit()
