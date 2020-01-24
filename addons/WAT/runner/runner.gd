extends Node

const MAIN: String = "TestRunner"
#const TestAdapter: Script = preload("res://addons/WAT/runner/test_adapter.gd")
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
	if name == MAIN:
		print("Starting WAT Test Runner")
	_tests = _test_loader.withdraw()
	begin()

func configure(config: Resource) -> void:
	configured = true
	_test_loader = config.test_loader
	_test_results = config.test_results
	_exit = config.exit.new()

func begin() -> void:
	if _tests.empty():
		end()
		return
	run()

	
func run(test: WAT.Test = _tests.pop_front().new()) -> void:
	var testcase = WAT.TestCase.new(test.title(), test.path())
	test.connect("finish", self, "_on_test_finished", [test, testcase])
	test.connect("finish", self, "begin", [], CONNECT_DEFERRED)
	test.setup(WAT.Asserts.new(), WAT.Yielder.new(), testcase, WAT.TestDoubleFactory.new(), \
					 WAT.SignalWatcher.new(), WAT.Parameters.new())
	add_child(test)
	
func _on_test_finished(adapter, testcase) -> void:
	testcase.calculate()
	_cases.append(testcase.to_dictionary())
	remove_child(adapter)
	adapter.queue_free()
	
func end() -> void:
	if name == MAIN: print("Ending WAT Test Runner")
	_test_results.deposit(_cases)
	emit_signal("ended")
	add_child(_exit)
	WAT.clear()
	_exit.execute()
