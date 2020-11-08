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
var _repeat: int = 1
var strategy: Reference = preload("res://addons/WAT/test_runner/strategy.gd").new()
var test_double_registry: Node = preload("res://addons/WAT/double/registry.gd").new()
var time_taken: float

signal TestScriptCompleted;
var EditorTalk: Node # Communication between game & Editor, delegates info via signals
var TestLoader: Node # # Uses FileSystem to search and parse tests
var TestStrategy: Node # Searchs and returns test strategy + related parameters
var TestFactory: Node # Creates instance from script in loader (avoids construction inside test)
var Results: Node # Stores and Serializes Results

func initialize_REFACTORED() -> void:
	TestFactory.add_test_scripts(TestLoader.load_tests(TestStrategy))

func run_REFACTORED() -> void:
	while TestFactory.can_create_tests:
		var test = TestFactory.create_test(TestLoader.next_script())
		add_child(test)
		yield(test.run(), "TestScriptCompleted")
		Results.add(test)
		remove_child(test)
	
	
func _ready() -> void:
	_time = OS.get_ticks_msec()
	if get_tree().root.get_child(0) == self:
		print("Starting WAT Test Runner")
	OS.window_minimized = ProjectSettings.get_setting(
			"WAT/Minimize_Window_When_Running_Tests")
	_begin()
	
func _begin():
	_repeat = strategy.repeat()
	_tests = get_tests()
	
	if _tests.empty():
		push_warning("No Scripts To Test")
	_run_tests()
	
func get_tests() -> Array:
	return test_loader.get_tests(strategy)

func _run_tests() -> void:
	while not _tests.empty():
		yield(run(), COMPLETED)
	_repeat -= 1
	if _repeat > 0:
		call_deferred("_begin")
	else:
		time_taken = _time / 1000.0
		end()

func run(test: WAT.Test = _tests.pop_front().new()) -> void:
	var testcase = WAT.TestCase.new(test.title(), test.path())
	test.setup(WAT.Asserts.new(), WAT.Yielder.new(), testcase, \
		WAT.TestDoubleFactory.new(), WAT.SignalWatcher.new(), WAT.Parameters.new(),
		WAT.Recorder, test_double_registry)
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
