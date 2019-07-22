extends WATTest

var cases: Array = []

func title():
	return "TestRunner"
	
func test_Runner_with_no_tests():
	describe("Running no tests")

	var filesystem = load("res://addons/WAT/filesystem.gd")
	var runner: Node = load("res://addons/WAT/Runner/runner.gd").new(filesystem)
	runner.connect("ended", self, "display")
	add_child(runner)

	# Act
	runner.run("res://Examples/Bootstrap/Empty")
	yield(until_signal(runner, "ended", 2.0), YIELD)

	# Assert
	expect.is_true(cases.empty(), "Runner emits no testcases (times out at 2 seconds)")

	# Teardown
	cases = []
	remove_child(runner)
	runner.queue_free()
	

func test_Runner_with_one_passing_test():
	describe("Running 1 correct test")
	
	# Arrange
	var filesystem = load("res://addons/WAT/filesystem.gd")
	var runner: Node = load("res://addons/WAT/Runner/runner.gd").new(filesystem)
	runner.connect("ended", self, "display")
	add_child(runner)
	
	# Guard (If this fails, then we have left over data from last test)
	expect.is_true(cases.empty(), "Before running, testcases are empty")
	
	# Act
	runner.run("res://Examples/Bootstrap")
	yield(until_signal(runner, "ended", 10.0), YIELD)
	
	# Assert
	expect.is_equal(cases.size(), 1, "emits a list of 1 testcase")
	expect.is_true(cases[0].success, "which is a success")
	
	# Teardown
	cases = []
	remove_child(runner)
	runner.queue_free()
	
func display(cases):
	# HelperMethod
	self.cases = cases
