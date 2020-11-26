extends Node

### RUN ORDER
# Initialize Connections
# Get Strategy From Editor
#	-> Loader = _get_scripts(strategy) # can we add metadata to a script? Answer: YES
#	-> Factory = _get_loaded_scripts() // Knows about strategy?
#	-> Factory -> New Test
#	-> Factory -> New TestController(test)
#	-> Runner = _run()
# Single Test Finished

onready var Client: Node = get_node("Client")
onready var Factory: Node = get_node("Factory")
onready var Loader: Node = get_node("Loader")
onready var Executor: Node = get_node("Executor")
onready var Run: Node = get_node("Run")

func _ready() -> void:
	_initialize()

func _initialize() -> void:
	print("NEW TEST RUNNER READY")
	Client.connect("StrategyReceived", self, "_run")
	Client.join()
	
func _run(strategy: Dictionary) -> void:
	# In Threaded versions, we could replace this with a system in process using "isRunning" boolean
	Factory.get_test_scripts(Loader.load_test_scripts(strategy))
	while not Factory.is_done():
		print("getting_next_test")
		var test = Factory.get_next_test()
		add_child(test)
		yield(test, "completed")
		# run.add_results?
	_terminate()
	
func _terminate() -> void:
	print("NEW TEST RUNNER QUITTING")
	Client.quit()
	get_tree().quit()
