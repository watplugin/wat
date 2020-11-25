extends Node

# const strategy: Script = preload("res://addons/WAT/core/test_runner/strategy.gd")
const COMPLETED: String = "completed"
signal ended

var JunitXML = preload("res://addons/WAT/resources/JUnitXML.gd").new()
var test_loader: Reference = preload("test_loader.gd").new()
var test_results: Resource = WAT.Results
var strategy: Reference = preload("res://addons/WAT/test_runner/strategy.gd").new()
var test_double_registry: Node = preload("res://addons/WAT/double/registry.gd").new()

var _tests: Array = []
var _cases: Array = []
var is_editor: bool = true
var _time: float
var time_taken: float

func _ready() -> void:
	$Client.join()
	_time = OS.get_ticks_msec()
	if get_tree().root.get_child(0) == self:
		# We don't want to start if we're being run as a scene directly rather..
		# ..than via editor
		# In future iterations we will handle this via TCP
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
	if not strategy.method().empty():
		test._methods = [strategy.method()]
	else:
		test._methods = test.methods()
	return test

func run(test) -> void:
	var testcase = test._testcase
	var start_time = OS.get_ticks_msec()
	add_child(test)
	test.run()
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
	$Client.send_results(_cases)
	#yield(get_tree().create_timer(2), "timeout")
	$Client.quit()
	if(is_editor):
		get_tree().quit()
