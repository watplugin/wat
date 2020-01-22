extends Node

const MAIN: String = "TestRunner"
const TestAdapter: Script = preload("res://addons/WAT/runner/test_adapter.gd")
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
	call_deferred("_run")

func configure(config: Resource) -> void:
	configured = true
	_test_loader = config.test_loader
	_test_results = config.test_results
	_exit = config.exit.new()

func _run() -> void:
	if _tests.empty():
		_test_results.deposit(_cases)
		WAT.clear()
		emit_signal("ended")
		add_child(_exit)
		if name == MAIN:
			print("Ending WAT Test Runner")
		_exit.execute()
		return
	var adapter = _setup_test()
	adapter.start()
	
func _setup_test():
	var test = _tests.pop_front().new()
	var yielder = WAT.Yielder.new()
	var assertions = WAT.Asserts.new()
	var testcase = WAT.TestCase.new()
	var adapter = TestAdapter.new()
	assertions.connect("asserted", testcase, "_on_asserted")
	test.connect("described", testcase, "_on_test_method_described")
	yielder.connect("finished", adapter, "_next")
	adapter.connect("finish", self, "_on_test_finished", [adapter, testcase, test])
	adapter.connect("finish", self, "_run", [], CONNECT_DEFERRED)
	testcase.title = test.title()
	testcase.path = test.path()
	test.initialize(assertions, yielder)
	adapter.initialize(test, yielder, testcase, test.methods() as Array)
	adapter.add_child(yielder)
	adapter.add_child(test)
	add_child(adapter)
	return adapter

func _on_test_finished(adapter, testcase, test) -> void:
	_cases.append(testcase.to_dictionary())
	remove_child(adapter)
	test.free()
	adapter.queue_free()
