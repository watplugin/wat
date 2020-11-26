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

func _ready() -> void:
	test_double_registry = TestDoubleRegistry.new()

func get_test_scripts(scripts: Array) -> void:
	_test_scripts = scripts

func get_next_test() -> Node:
	var test = _test_scripts[_cursor].new()
	var testcase = TestCase.new(test.title(), test.path())
	var asserts = Assertions.new()
	var yielder = Yielder.new()
	var doubles = Double.new()
	var watcher = SignalWatcher.new()
	var parameters = Parameters.new()
	# Maybe pull this up here
	test.setup(asserts, yielder, testcase, doubles, watcher, parameters, Recorder, test_double_registry)
	_cursor += 1
	var test_controller = TestController.new(test, yielder)
	return test_controller
	
func is_done() -> bool:
	return true if _cursor == _test_scripts.size() else false
