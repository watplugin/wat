extends Node

const Results: Resource = preload("res://addons/WAT/cache/Results.tres")
export(Script) var TestController
export(Array, Script) var tests = []
var results = []
var _cursor: int = 0
# In Threaded Versions, we'll create a controller per thread
var test_controller

func _ready() -> void:
	test_controller = TestController.new()
	add_child(test_controller)
	print("Initializing TestRunner")
	print(tests)
	_run()

func _run() -> void:
	# In Threaded versions, we could replace this with a system in process using "isRunning" boolean
	while not is_done():
		var test = get_next_test()
		test_controller.run(test)
		yield(test_controller, "finished")
		results.append(test_controller.results)
	Results.save(results)
	_terminate()
	
func get_next_test() -> Node:
	var script = tests[_cursor]
	while not Directory.new().file_exists(script.resource_path):
		_cursor += 1
		script = tests[_cursor]
	var test = script.new()
	_cursor += 1
	return test
	
func is_done() -> bool:
	return _cursor == tests.size()
	
func _terminate() -> void:
	print("Terminating TestRunner")
	get_tree().quit()
