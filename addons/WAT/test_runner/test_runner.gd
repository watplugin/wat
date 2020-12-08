extends Node

onready var Client: Node = get_node("Client")
onready var Factory: Node = get_node("Factory")
onready var Loader: Node = get_node("Loader")
const Results: Resource = preload("res://addons/WAT/system/Results.tres")
const Runnables: Resource = preload("res://addons/WAT/cache/runnables.tres")
var results = []

func _ready() -> void:
	print("Initializing TestRunner")
	_run()

func _run() -> void:
	# In Threaded versions, we could replace this with a system in process using "isRunning" boolean
	print(Runnables.tests)
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
	#Client.quit()
	get_tree().quit()
