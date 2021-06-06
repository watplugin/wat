extends Node

const Client: Script = preload("res://addons/WAT/network/client.gd")
const Log: Script = preload("res://addons/WAT/log.gd")
const SingleThreadedRunner: Script = preload("single_threaded_runner.gd")
const MultiThreadedRunner: Script = preload("multi_threaded_runner.gd")
var _runner: Node
var _client
var tests: Array
var threads: int = 1
signal run_completed

func _init(_tests: Array = [], _threads: int = 1) -> void:
	threads = _threads
	tests = _tests
	
func _ready() -> void:
	name = "TestRunner"
	if tests.empty() and not Engine.is_editor_hint():
		print("WAT: Seeking Tests from Test Server")
		_client = Client.new()
		_client.connect("test_strategy", self, "run")
		connect("run_completed", _client, "_on_run_completed")
		add_child(_client)
	else:
		run()

func run(_tests = tests, _threads = threads) -> void:
	tests = _tests
	Log.method("run", self)
	if _threads > 1:
		print("WAT: Tests Received from Test Server")
		_runner = MultiThreadedRunner.new()
		_runner.name = "MultiThreadedRunner"
	else:
		_runner = SingleThreadedRunner.new()
		_runner.name = "SingleThreadedRunner"
	_runner.connect("run_completed", self, "_on_run_completed")
	add_child(_runner, true)
	_runner.run(_tests, _threads)


func _on_run_completed(results: Array) -> void:
	_runner.queue_free()
	emit_signal("run_completed", results)
