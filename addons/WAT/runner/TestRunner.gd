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

func run(tests: Array, repeat: int, threads: int, results_view: Node = null) -> Array:
	var results: Array = []
	tests = _repeat(tests, repeat)
	var testthreads = Splitter.split(tests, threads)
	for thread in testthreads:
		thread.controller.results = results_view
		add_child(thread.controller)
		thread.start(self, "_run", thread)
		thread.wait_to_finish()
	for count in testthreads:
		results += yield(self, COMPLETED)
	return results

func _run(thread: Thread) -> void:
	var results: Array = []
	for test in thread.tests:
		results.append(yield(thread.controller.run(test), COMPLETED))
	thread.controller.queue_free()
	emit_signal(COMPLETED, results)

func _repeat(tests: Array, repeat: int) -> Array:
	var duplicates: Array = []
	for idx in repeat:
		for test in tests:
			duplicates.append(test)
	duplicates += tests
	return duplicates

