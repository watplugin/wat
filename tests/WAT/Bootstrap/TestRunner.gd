extends WATTest

var cases: Array = []
var filesystem
var runner

func title():
	return "TestRunner"
	
func pre():
	cases = []
	filesystem = load("res://addons/WAT/filesystem.gd")
	runner = load("res://addons/WAT/Runner/runner.gd").new(filesystem)
	runner.connect("ended", self, "display")
	add_child(runner)

func post():
	filesystem = null
	remove_child(runner)
	runner.disconnect("ended", self, "display")
	runner.queue_free()
	
func test_Runner_with_invalid_path():
	describe("Running with an invalid path")

	runner.run("")
	yield(until_signal(runner, "ended", 1.0), YIELD)

	expect.is_true(cases.empty(), "No Testcases emitted")
	
func test_Runner_with_no_tests():
	describe("Running no tests")

	# Act
	runner.run("res://Examples/Bootstrap/Empty")
	yield(until_signal(runner, "ended", 2.0), YIELD)

	# Assert
	expect.is_true(cases.empty(), "Runner emits no testcases (times out at 2 seconds)")

func test_Runner_with_one_test_that_has_no_test_methods():
	describe("Running one test that has no test methods")
	
	runner.run("res://Examples/Bootstrap/empty_test.gd")
	yield(until_signal(runner, "ended", 2.0), YIELD)
	
	expect.is_equal(cases.size(), 1, "Emits 1 Testcase")
	expect.is_false(cases[0].success, "that failed")
	
func test_Runner_with_one_passing_test():
	describe("Running 1 correct test")
	
	# Guard (If this fails, then we have left over data from last test)
	expect.is_true(cases.empty(), "Before running, testcases are empty")
	
	# Act
	runner.run("res://Examples/Bootstrap/passing_test.gd")
	yield(until_signal(runner, "ended", 10.0), YIELD)
	
	# Assert
	expect.is_equal(cases.size(), 1, "emits a list of 1 testcase")
	expect.is_true(cases[0].success, "which is a success")
	

func display(cases):
	# HelperMethod
	self.cases = cases

