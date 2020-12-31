extends Node

signal finished
export(Script) var TestController
export(Array, Dictionary) var tests = []
var is_editor: bool = true
var results = []
var _cursor: int = 0
# In Threaded Versions, we'll create a controller per thread
var test_controller

func _ready() -> void:
	test_controller = TestController.new()
	add_child(test_controller)
	print("Initializing TestRunner")
	_run()

func _run() -> void:
	# In Threaded versions, we could replace this with a system in process using "isRunning" boolean
	while not _cursor == tests.size():
		test_controller.run(tests[_cursor])
		_cursor += 1
		yield(test_controller, "finished")
		results.append(test_controller.results)
	get_tree().root.get_node("WATNamespace").Settings.results().save(results)
	_terminate()
	
func _terminate() -> void:
	print("Terminating TestRunner")
	get_tree().quit() if is_editor else emit_signal("finished")
