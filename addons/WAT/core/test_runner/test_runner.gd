extends Node

const Strategy: Script = preload("res://addons/WAT/core/test_runner/strategy.gd")
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

func _ready() -> void:
	_time = OS.get_ticks_msec()
	if get_tree().root.get_child(0) == self:
		print("Starting WAT Test Runner")
	OS.window_minimized = ProjectSettings.get_setting(
			"WAT/Minimize_Window_When_Running_Tests")
	_create_test_double_registry()
	_begin()
	
func _begin():
	_repeat = Strategy.repeat()
	_tests = get_tests()
	
	if _tests.empty():
		push_warning("No Scripts To Test")
	_run_tests()
	
func get_tests() -> Array:
	match Strategy.get_current_strategy():
		Strategy.RUN_ALL:
			return test_loader.all()
		Strategy.RUN_DIRECTORY:
			return test_loader.directory(Strategy.directory())
		Strategy.RUN_SCRIPT:
			return test_loader.script(Strategy.script())
		Strategy.RUN_TAG:
			return test_loader.tag(Strategy.tag())
		Strategy.RUN_METHOD:
			return test_loader.script(Strategy.script())
		Strategy.RERUN_FAILED:
			return test_loader.last_failed()
		_:
			return _tests

var time_taken: float
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
		WAT.Recorder)
	var start_time = OS.get_ticks_msec()
	add_child(test)
	# Add Strategy Here?
	if not Strategy.method().empty():
		test._methods = [Strategy.method()]
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
	clear()
	if(is_editor):
		get_tree().quit()

func _create_test_double_registry() -> void:
	if not ProjectSettings.has_setting("WAT/TestDouble"):
		var registry = load("res://addons/WAT/core/double/registry.gd")
		ProjectSettings.set_setting("WAT/TestDouble", registry.new())
		
func clear() -> void:
	if ProjectSettings.has_setting("WAT/TestDouble"):
		ProjectSettings.get_setting("WAT/TestDouble").clear()
		ProjectSettings.get_setting("WAT/TestDouble").free()

