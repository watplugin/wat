extends Node

const TestController: Script = preload("res://addons/WAT/core/test/test_controller.gd")
var _test_controllers: Dictionary = {} # K = Controller, V = Thread
var _tests: Array = []
var _results: Array = []
signal run_completed

func run(tests: Array, threads: int) -> void:
	_tests = tests
	_create_thread_controllers(threads)
	_run()
		
func _create_thread_controllers(threads: int) -> void:
	for thread in threads:
		var _test_controller: TestController = TestController.new()
		_test_controllers[_test_controller] = Thread.new()
		_test_controller.connect("finished", self, "_on_controller_finished", [_test_controller])
		add_child(_test_controller)

func _run() -> void:
	if not _tests.empty():
		# Seeking free threads for _test_controller // Can't I just use thread I got?
		for _test_controller in _test_controllers:
			if not _test_controllers[_test_controller].is_active():
				var test = _tests.pop_front()
				_test_controllers[_test_controller].start(_test_controller, "run", test)
	else:
		# Making sure no active tests exist
		for _test_controller in _test_controllers:
			if _test_controllers[_test_controller].is_active():
				return
		emit_signal("run_completed", _results)
	
func _process(delta: float) -> void:
	_run()
	
func _on_controller_finished(test_controller) -> void:
	_test_controllers[test_controller].wait_to_finish()
	_results.append(test_controller.results)
	call_deferred("_run")
