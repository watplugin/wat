extends Node

const COMPLETED: String = "completed"
signal completed

class TestThread extends Thread:
	var tests: Array = []
	var controller: Node = preload("res://addons/WAT/runner/test_controller.gd").new()
	
	func _init(_tests: Array) -> void:
		tests = _tests

func run(tests, threads) -> void:
	var results: Array = []
	var testthreads = split(tests, threads)
	print("Testthreads", testthreads.size())
	for thread in testthreads:
		print("Running Thread")
		add_child(thread.controller)
		thread.start(self, "_run", thread)
		thread.wait_to_finish()
	for count in testthreads:
		print("yielding for testthreads")
		results += yield(self, COMPLETED)
	return results
#	get_tree().quit()
	
func _run(thread: TestThread) -> void:
	print("_Running thread")
	print("Tests size? ", thread.tests.size())
	var results: Array = []
	for test in thread.tests:
		results.append(yield(thread.controller.run(test), COMPLETED))
	print("Returned from controller")
	thread.controller.queue_free()
	emit_signal(COMPLETED, results)

func split(tests, threads) -> Array:
	var testpools = []
	for i in threads:
		testpools.append([])
	var pool_idx = 0
	for test in tests:
		testpools[pool_idx].append(test)
		pool_idx += 1
		if pool_idx == threads:
			pool_idx = 0
	var threadpools: Array = []
	for testpool in testpools:
		threadpools.append(TestThread.new(testpool))
	return threadpools
