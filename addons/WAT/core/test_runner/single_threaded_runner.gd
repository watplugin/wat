extends Node

const TestController: Script = preload("res://addons/WAT/core/test/test_controller.gd")
var _test_controller: TestController
signal run_completed

func run(tests: Array) -> void:
	var results: Array = []
	_test_controller = TestController.new()
	add_child(_test_controller)
	while not tests.empty():
		_test_controller.run(tests.pop_front())
		yield(_test_controller, "finished")
		results.append(_test_controller.results)
	emit_signal("run_completed", results)
