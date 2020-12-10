extends Node

export(Script) var TestController
export(Script) var TestCase
export(Script) var Assertions
export(Script) var Yielder
export(Script) var Double
export(Script) var SignalWatcher
export(Script) var Parameters
export(Script) var Recorder
export(Script) var TestDoubleRegistry

var test_double_registry
var _test_scripts: Array = []
var _cursor: int = 0

func initialize(scripts: Array) -> void:
	test_double_registry = TestDoubleRegistry.new()
	_test_scripts = scripts

func get_next_test() -> Node:
	var script = _test_scripts[_cursor]
	while not Directory.new().file_exists(script.resource_path):
		_cursor += 1
		script = _test_scripts[_cursor]
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
	return true if _cursor == _test_scripts.size() else false
