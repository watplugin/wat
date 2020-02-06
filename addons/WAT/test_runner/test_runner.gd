extends Node

const COMPLETED: String = "completed"
var primary: bool = true
var _test_loader
var _test_results: Resource
var _tests: Array = []
var _cases: Array = []
var _setup: bool = false
signal ended

func _ready() -> void:
	WAT.Settings.create() # bad name fix soon
	if not _setup:
		setup()
	if primary:
		print("Starting WAT Test Runner")
	_tests = _test_loader.withdraw()
	if _tests.empty():
		push_warning("No Scripts To Test")
	_run_tests()
	
func setup(loader = preload("test_loader.gd").new(), results: Resource = WAT.Results):
	_setup = true
	_test_loader = loader
	_test_results = results

func _run_tests() -> void:
	while not _tests.empty():
		yield(run(), COMPLETED)
	end()

func run(test: WAT.Test = _tests.pop_front().new()) -> void:
	var testcase = WAT.TestCase.new(test.title(), test.path())
	test.setup(WAT.Asserts.new(), WAT.Yielder.new(), testcase, \
		WAT.TestDoubleFactory.new(), WAT.SignalWatcher.new(), WAT.Parameters.new())
	add_child(test)
	yield(test, COMPLETED)
	testcase.calculate()
	_cases.append(testcase.to_dictionary())
	remove_child(test)
	
func end() -> void:
	print("Ending WAT Test Runner")
	_test_results.deposit(_cases)
	emit_signal("ended")
	WAT.Settings.clear(primary)
	get_tree().quit()
