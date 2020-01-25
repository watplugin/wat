extends Node

const COMPLETED: String = "completed"
var primary: bool = true
var _test_loader: Resource
var _test_results: Resource
var _exit: Node
var _tests: Array = []
var _cases: Array = []
var configured: bool = false
var config: Resource
signal ended

func _ready() -> void:
	if not configured:
		configure(WAT.DefaultConfig)
	if primary:
		print("Starting WAT Test Runner")
	_tests = _test_loader.withdraw()
	call_deferred("_run_tests")
	
func _run_tests() -> void:
	if _tests.empty():
		end()
	else:
		yield(run(), COMPLETED)
		call_deferred("_run_tests")

func configure(config: Resource) -> void:
	configured = true
	_test_loader = config.test_loader
	_test_results = config.test_results
	_exit = config.exit.new()

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
	if primary: print("Ending WAT Test Runner")
	_test_results.deposit(_cases)
	emit_signal("ended")
	add_child(_exit)
	WAT.clear()
	_exit.execute()
