tool
extends Node

const Settings: GDScript = preload("res://addons/WAT/settings.gd")
const Splitter: GDScript = preload("splitter.gd")
const COMPLETED: String = "completed"
signal completed

func _ready() -> void:
	name = "TestRunner"
	if not Engine.is_editor_hint():
		OS.window_size = Settings.window_size()
		OS.window_minimized = Settings.minimize_window_when_running_tests()

func run(tests, threads) -> void:
	var results: Array = []
	var testthreads = Splitter.split(tests, threads)
	for thread in testthreads:
		add_child(thread.controller)
		thread.start(self, "_run", thread)
		thread.wait_to_finish()
	for count in testthreads:
		results += yield(self, COMPLETED)
	print("returning results")
	return results

	
func _run(thread: Thread) -> void:
	print("running thread")
	var results: Array = []
	for test in thread.tests:
		results.append(yield(thread.controller.run(test), COMPLETED))
	thread.controller.queue_free()
	print("returning from thread")
	emit_signal(COMPLETED, results)



