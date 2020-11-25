extends Node


const COMPLETED: String = "completed"
signal ended

var JunitXML = preload("res://addons/WAT/JUnitXML.gd").new()
var test_loader: Reference = preload("test_loader.gd").new()
var test_double_registry: Node = preload("res://addons/WAT/double/registry.gd").new()

var _tests: Array = []
var _cases: Array = []
var is_editor: bool = true
var _time: float
var time_taken: float

func _ready() -> void:
	$Client.join()
	$Client.connect("StrategyReceived", self, "OnStrategyReceived")
	_time = OS.get_ticks_msec()
	if get_tree().root.get_child(0) == self:
		# We don't want to start if we're being run as a scene directly rather..
		# ..than via editor
		# In future iterations we will handle this via TCP
		print("Starting WAT Test Runner")
	OS.window_minimized = ProjectSettings.get_setting("WAT/Minimize_Window_When_Running_Tests")
	
func OnStrategyReceived(strategy):
	_begin(strategy)
	
func _begin(strategy):
	_tests = get_tests(strategy)
	if _tests.empty():
		push_warning("No Scripts To Test")
	_run_tests()
	
func get_tests(strategy) -> Array:
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
	### WARNING - Need To Slide The Method Getting Easily
	#	if not strategy.method().empty():
	#		test._methods = [strategy.method()]
	#	else:
		### WARNING
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
	emit_signal("ended")
	$Client.send_results(_cases)
	$Client.quit()
	if(is_editor):
		get_tree().quit()
