extends Node

onready var Factory: Node = get_node("Factory")
const Results: Resource = preload("res://addons/WAT/cache/Results.tres")
const Runnables: Resource = preload("res://addons/WAT/cache/runnables.tres")
var results = []

func _ready() -> void:
	print("Initializing TestRunner")
	_run()

func _run() -> void:
	# In Threaded versions, we could replace this with a system in process using "isRunning" boolean
	Factory.initialize(Runnables.tests)
	while not Factory.is_done():
		var test = Factory.get_next_test()
		add_child(test)
		test.run()
		yield(test, "finished")
		remove_child(test)
		results.append(test.results)
	Results.save(results)
	_terminate()
	
func _terminate() -> void:
	print("Terminating TestRunner")
	Runnables.clear()
	get_tree().quit()
