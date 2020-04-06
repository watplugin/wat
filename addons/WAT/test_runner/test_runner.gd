extends Node

const COMPLETED: String = "completed"
var primary: bool = true
### BEGIN EXPORT?
# We're just going to make these public, not the best but better than the ugly set up
var test_loader: Reference = preload("res://addons/WAT/test_runner/test_loader.gd").new()
var test_results: Resource = WAT.Results
### END EXPORT?
var _tests: Array = []
var _cases: Array = []
signal ended

func _ready() -> void:
	WAT.Settings.handle_window()
	WAT.Settings.create() # bad name fix soon
	if primary:
		print("Starting WAT Test Runner")
	# With an updated filesystem, it doesn't need to be withdrawn
	# We can just duplicate the array of scripts
	# (this also lets us check if said array is empty!)
	_tests = test_loader.withdraw()
	if _tests.empty():
		# Check this before loading the runner?
		push_warning("No Scripts To Test")
	_run_tests()

var time_taken: float
func _run_tests() -> void:
	var time = OS.get_ticks_msec()
	while not _tests.empty():
		yield(run(), COMPLETED)
	time_taken = time / 1000.0
	end()

func run(test: WAT.Test = _tests.pop_front().new()) -> void:
	var testcase = WAT.TestCase.new(test.title(), test.path())
	test.setup(WAT.Asserts.new(), WAT.Yielder.new(), testcase, \
		WAT.TestDoubleFactory.new(), WAT.SignalWatcher.new(), WAT.Parameters.new())
	var start_time = OS.get_ticks_msec()
	add_child(test)
	var time = OS.get_ticks_msec() - start_time
	testcase.time_taken = time / 1000.0
	yield(test, COMPLETED)
	testcase.calculate()
	_cases.append(testcase.to_dictionary())
	remove_child(test)
	
func end() -> void:
	print("Ending WAT Test Runner")
	OS.window_minimized = false
	preload("res://addons/WAT/JUnitXML.gd").new().save(_cases, time_taken)
	test_results.deposit(_cases)
	emit_signal("ended")
	WAT.Settings.clear()
	get_tree().quit()
