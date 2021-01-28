extends Node

const TestController: Script = preload("res://addons/WAT/core/test_runner/test_controller.gd")
var _results: Array = []
var _threads: Array = []
signal run_completed

func run(tests: Array, threads: int) -> void:
	var testlists = split_and_sort(tests, threads)
	for testlist in testlists:
		var thread = Thread.new()
		_threads.append(thread)
		thread.start(self, "_run", [testlist, thread])
		
func _run(userdata: Array) -> void:
	var results: Array = []
	var thread: Thread = userdata[1]
	var tests: Array = userdata[0]
	var _test_controller: TestController = TestController.new()
	add_child(_test_controller)
	for test in tests:
		_test_controller.run(test)
		yield(_test_controller, "finished") 
		results.append(_test_controller.get_results())
	_test_controller.queue_free()
	call_deferred("run_completed", thread, results)
	
func run_completed(thread, results) -> void:
	thread.wait_to_finish()
	_results += results

func _process(delta: float) -> void:
	if(_all_threads_inactive()):
		emit_signal("run_completed", _results)
	
func _all_threads_inactive() -> bool:
	if _threads.size() > 0:
		for thread in _threads:
			if thread.is_active():
				return false
		return true
	return false
		
func split_and_sort(tests: Array, threads: int) -> Array:
	
	for test in tests:
		_set_calculated_yield_time(test)
	
	tests.sort_custom(YieldSorter, "sort_ascending")

	# Takes splits tests into N arrays where N is threads and..
	# ..then returns thems in a 2D Dimensional Array
	
	# Create 2D Array of N size where N is threadcount
	var sorted: Array = []
	for thread in threads:
		sorted.append([])
	# Loop through tests, adding a test to sorted[cursor]
	var cursor: int = 0
	for test in tests:
		sorted[cursor].append(test)
		cursor += 1
		if cursor == threads:
			# We loop back to start adding tests at the start of the 2D Array
			cursor = 0
	return sorted
	
func _sort_by_yield_time(tests: Array) -> Array:
	
	return []
	
func _set_calculated_yield_time(test: Dictionary) -> void:
	var time: float = 0.0
	var source = test["script"].source_code.split("\n")
	var lines: PoolStringArray = []
	for line in source:
		if "yield(until_timeout" in line:
			var more = line.replace("yield(until_timeout(", "").replace("), YIELD)", "")
			time += more as float
		elif "yield(until_signal" in line:
			line = line.replace("), YIELD)", "")
			line = line.substr(line.find_last(", ") + 1, line.length())
			time += line as float
	test["yield_time"] = time

class YieldSorter:
	
	static func sort_ascending(a, b) -> bool:
		if a["yield_time"] < b["yield_time"]:
			return true
		return false
