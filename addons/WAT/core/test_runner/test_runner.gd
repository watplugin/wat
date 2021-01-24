extends Node
tool

onready var SingleThreadedRunner: Node = preload("res://addons/WAT/core/test_runner/single_threaded_runner.gd").new()
onready var MultiThreadedRunner: Node = preload("res://addons/WAT/core/test_runner/multithreaded_runner.gd").new()
export(Array, Dictionary) var tests = []
export(int) var threads = 7
var is_editor: bool = true
var editor_context: bool = false
signal finished

func _ready() -> void:
	print("ready")
	add_child(SingleThreadedRunner)
	threads = _validate_threads(threads)
	if threads > 1:
		MultiThreadedRunner.connect("run_completed", self, "_on_run_completed")
		MultiThreadedRunner.run(tests, threads)
	else:
		SingleThreadedRunner.connect("run_completed", self, "_on_run_completed")
		SingleThreadedRunner.run(tests)
		
func _on_run_completed(results: Array) -> void:
	if editor_context:
		emit_signal("finished", results)
		print("Terminating TestRunner")
	else:
		WAT.ResManager.results().save(results)
		print("Terminating TestRunner")
		get_tree().quit() if is_editor else emit_signal("finished")
	
func _validate_threads(threads: int) -> int:
	if threads == OS.get_processor_count():
		push_warning("Max Available Threads is %s" % (OS.get_processor_count() - 1) as String)
		threads = OS.get_processor_count() - 1
		if threads == 0: # Unlikely event that people only have a single thread?
			threads = 1
	return threads
