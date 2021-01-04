extends Node

const LOCKED = true
signal finished
export(Script) var TestController
export(Array, Dictionary) var tests = []
export(int) var threads = 4
var running_tests: Array = []
var is_editor: bool = true
var results = []
var _cursor: int = 0
var controllers: Dictionary = {}

# In Threaded Versions, we'll create a controller per thread
#var test_controller

func _ready() -> void:
	for thread in threads:
		var controller = TestController.new()
		controllers[controller] = Thread.new()
		controller.connect("finished", self, "_on_controller_finished", [controller])
		add_child(controller)
	print("Initializing TestRunner")
	_run()
	
func _process(delta) -> void:
	_run()
	
func _on_controller_finished(controller) -> void:
	controllers[controller].wait_to_finish()
	results.append(controller.results)
	
func _run() -> void:
	# Controller passes itself in via signal when it is ready for another test
#	if _cursor < tests.size() - 1:
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

func _terminate() -> void:
	WAT.results().save(results)
	print("Terminating TestRunner")
	get_tree().quit() if is_editor else emit_signal("finished")
