extends Node

signal finished
var Results: Resource = WAT.Settings.results()
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
	while not is_done():
		test_controller.run(get_next_test())
		yield(test_controller, "finished")
		results.append(test_controller.results)
	Results.save(results)
	_terminate()
	
func get_next_test() -> Node:
	# Handle Inside Test Controller?
	# We also won't need to duplicate tests, just point to them again?
	var script = tests[_cursor].test.new()
	script.path = tests[_cursor]["path"]
	_cursor += 1
	return script
	
func is_done() -> bool:
	return _cursor == tests.size()
	
func _terminate() -> void:
	print("Terminating TestRunner")
	get_tree().quit() if is_editor else emit_signal("finished")
