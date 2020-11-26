extends Node

onready var Client: Node = get_node("Client")
onready var Factory: Node = get_node("Factory")
onready var Loader: Node = get_node("Loader")
onready var Executor: Node = get_node("Executor")
onready var Run: Node = get_node("Run")
var results = []

func _ready() -> void:
	_initialize()

func _initialize() -> void:
	print("Initializing TestRunner")
	Client.connect("StrategyReceived", self, "_run")
	Client.join()
	
func _run(strategy: Dictionary) -> void:
	# In Threaded versions, we could replace this with a system in process using "isRunning" boolean
	Factory.get_test_scripts(Loader.load_test_scripts(strategy))
	while not Factory.is_done():
		var test = Factory.get_next_test()
		add_child(test)
		test.run()
		yield(test, "finished")
		remove_child(test)
		results.append(test.results)
	Client.send_results(results)
	_terminate()
	
func _terminate() -> void:
	print("Terminating TestRunner")
	Client.quit()
	get_tree().quit()
