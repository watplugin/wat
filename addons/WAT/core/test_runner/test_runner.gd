extends Node

signal finished
export(Script) var TestController
export(Array, Dictionary) var tests = []
export(int) var threads = 7 # 1 thread = single_core, multi_thread starts at 2
var running_tests: Array = []
var is_editor: bool = true
var results = []
var _cursor: int = 0
var controllers: Dictionary = {}
var _is_terminating = false
var _test_controller

func _ready() -> void:
	if threads == OS.get_processor_count():
		push_warning("Max Available Threads is %s" % (OS.get_processor_count() - 1) as String)
		threads = OS.get_processor_count() - 1
		if threads == 0: # Unlikely event that people only have a single thread?
			threads = 1
	print("Initializing TestRunner")
	_is_terminating = false
	controllers = {}
	if threads > 1:
		for thread in threads:
			var controller = TestController.new()
			controllers[controller] = Thread.new()
			controller.connect("finished", self, "_on_controller_finished", [controller])
			add_child(controller)
		call_deferred("_run_threaded")
	else:
		_test_controller = TestController.new()
		add_child(_test_controller)
		_run_single_thread()
	
func _on_controller_finished(controller) -> void:
	controllers[controller].wait_to_finish()
	results.append(controller.results)
	call_deferred("_run_threaded")
	
func _run_single_thread():
	# In Threaded versions, we could replace this with a system in process using "isRunning" boolean
	while not tests.empty():
		_test_controller.run(tests.pop_front())
		yield(_test_controller, "finished")
		results.append(_test_controller.results)
	_terminate()
	
func _run_threaded() -> void:
	if threads == 1:
		return
	if not tests.empty():
		for controller in controllers:
			# If a Thread is free
			if not controllers[controller].is_active():
				var test = tests.pop_front()
				controllers[controller].start(controller, "run", test)
	else:
		for controller in controllers:
			if controllers[controller].is_active():
				return
		_terminate()
		
func _process(delta):
	_run_threaded()

func _terminate() -> void:
	for controller in controllers:
		controllers.erase(controller)
		remove_child(controller)
		controller.delete()
		controller.queue_free()
	if _test_controller != null:
		_test_controller.delete()
		_test_controller.queue_free()
	if _is_terminating and threads > 1:
		return
	_is_terminating = true
	WAT.ResManager.results().save(results)
	print("Terminating TestRunner")
	get_tree().quit() if is_editor else emit_signal("finished")
