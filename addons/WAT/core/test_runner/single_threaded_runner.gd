extends Node

const Log: Script = preload("res://addons/WAT/log.gd")
const TestController: Script = preload("test_controller.gd")
signal run_completed

# Ignore threads here, this is just for abvoe
func run(tests: Array, threads: int = 0) -> void:
	Log.method("run", self)
	var results: Array = []
	var _test_controller: TestController = TestController.new()
	add_child(_test_controller)
	for test in tests:
		_test_controller.run(test)
		yield(_test_controller, "finished")
		results.append(_test_controller.get_results())
	_test_controller.queue_free()
	Log.method("run_completed", self)
	emit_signal("run_completed", results)
