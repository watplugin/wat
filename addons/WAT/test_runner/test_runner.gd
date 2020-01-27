extends Node

const COMPLETED: String = "completed"
var primary: bool = true
var _test_loader: WAT.TestLoader
var _test_results: Resource
var _tests: Array = []
var _cases: Array = []
var _setup: bool = false
signal ended

func _ready() -> void:
	if not _setup:
		setup()
	if primary:
		print("Starting WAT Test Runner")
	_tests = _test_loader.withdraw()
	if _tests.empty():
		push_warning("No Scripts To Test")
	_run_tests()
	
func setup(loader: WAT.TestLoader = WAT.TestLoader.new(), results: Resource = WAT.Results):
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
	print(43, primary)
	if primary: print("Ending WAT Test Runner")
	print(45, primary)
	_test_results.deposit(_cases)
	print(47, primary)
	WAT.Settings.clear()
	print(49, primary)
	emit_signal("ended")
	print(51, primary)
	if WAT.Settings.autoquit_is_enabled():
		print(53)
		get_tree().quit()
	print(55, primary)
