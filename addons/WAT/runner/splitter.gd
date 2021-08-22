extends Node

static func split(tests: Array, threads: int = 1) -> Array:
	tests.sort_custom(YieldTimeSorter, "sort_ascending")
	threads = calibrate_threads(tests.size(), threads)
	return _testthreads(_distribute(_testpools(threads), tests, threads))
	
static func calibrate_threads(tests: int, threads: int) -> int:
	if tests < threads:
		push_warning("Readjusting thread count to match low test size")
		threads = tests
	return threads
	
static func _testpools(count: int) -> Array:
	var pools: Array = []
	for pool in count:
		pools.append([])
	return pools

static func _distribute(pools: Array, tests: Array, count: int) -> Array:
	var idx: int = 0
	for test in tests:
		pools[idx].append(test)
		idx = 0 if idx == count - 1 else idx + 1
	return pools
	
static func _testthreads(pools: Array) -> Array:
	# Our tests are sorted from slowest to quickest..
	# ..so we loop through each pool in order to disaparate time
	var threads: Array = []
	for pool in pools:
		threads.append(TestThread.new(pool))
	return threads
		
class TestThread extends Thread:
	var tests: Array
	var controller: Node = load("res://addons/WAT/runner/test_controller.gd").new()
	
	func _init(_tests):
		tests = _tests

class YieldTimeSorter:
	
	static func sort_ascending(a: Dictionary, b: Dictionary) -> bool:
		return a["time"] < b["time"]


