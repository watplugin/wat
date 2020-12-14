extends Node

const Results: Resource = preload("res://addons/WAT/cache/Results.tres")
export(Script) var TestController
export(Script) var TestCase
export(Script) var Assertions
export(Script) var Yielder
export(Script) var Double
export(Script) var SignalWatcher
export(Script) var Parameters
export(Script) var Recorder
export(Script) var TestDoubleRegistry
export(Array, Script) var tests = []
var results = []
var test_double_registry
var _cursor: int = 0

func _ready() -> void:
	print("Initializing TestRunner")
	print(tests)
	test_double_registry = TestDoubleRegistry.new()
	_run()

func _run() -> void:
	# In Threaded versions, we could replace this with a system in process using "isRunning" boolean
	while not is_done():
		var test = get_next_test()
		add_child(test)
		test.run()
		yield(test, "finished")
		remove_child(test)
		results.append(test.results)
	Results.save(results)
	_terminate()
	
func get_next_test() -> Node:
	var script = tests[_cursor]
	while not Directory.new().file_exists(script.resource_path):
		_cursor += 1
		script = tests[_cursor]
	var test = script.new()
	var testcase = TestCase.new(test.title(), test.path())
	var yielder = Yielder.new()
	var double = Double.new()
	var test_controller = TestController.new(test, yielder, testcase)
	double.registry = test_double_registry
	test.yielder = yielder
	test.direct = double
	test.recorder = Recorder
	test.asserts = Assertions.new()
	test.watcher = SignalWatcher.new()
	test.parameters = Parameters.new()
	test.asserts.connect("asserted", testcase, "_on_asserted")
	test.connect("described", testcase, "_on_test_method_described")
	yielder.connect("finished", test_controller, "_next")
	_cursor += 1
	return test_controller
	
func is_done() -> bool:
	return _cursor == tests.size()
	
func _terminate() -> void:
	print("Terminating TestRunner")
	get_tree().quit()
