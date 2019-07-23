extends WATTest

# RunManyTests (like 100, 10000)
# RunTestWithManyMethods
# RunTestMethodWithYields?

var cases: Array = []
var filesystem
var runner

func title():
	return "TestRunner"
	
func start():
	filesystem = load("res://addons/WAT/filesystem.gd")
	runner = load("res://addons/WAT/Runner/runner.gd").new(filesystem)
	runner.connect("ended", self, "display")
	add_child(runner)
	
func pre():
	cases = []
	
func end():
	filesystem = null
	remove_child(runner)
	runner.queue_free()
	
func test_Runner_with_invalid_path():
	describe("Runs using an invalid path")

	runner.run("")
	yield(until_signal(runner, "ended", 1.0), YIELD)

	expect.is_true(cases.empty(), "Creates 0 TestCases")
	
func test_Runner_with_no_tests():
	describe("Runs using an empty directory")

	# Act
	runner.run("res://Examples/Bootstrap/Empty")
	yield(until_signal(runner, "ended", 2.0), YIELD)

	# Assert
	expect.is_true(cases.empty(), "Creates 0 TestCases")

func test_Runner_with_one_test_that_has_no_test_methods():
	describe("Runs one test that has no test methods")
	
	runner.run("res://Examples/Bootstrap/empty_test.gd")
	yield(until_signal(runner, "ended", 2.0), YIELD)
	
	expect.is_equal(cases.size(), 1, "Creates 1 TestCase")
	expect.is_false(cases[0].success, "Fails TestCase")
	
func test_Runner_with_one_test_that_has_one_test_method_with_no_asserts():
	describe("Runs one test that has a method without asserts")
	
	runner.run("res://Examples/Bootstrap/one_test_method_no_asserts.gd")
	yield(until_signal(runner, "ended", 2.0), YIELD)
	
	expect.is_equal(cases.size(), 1, "Creates 1 TestCase")
	expect.is_false(cases[0].success, "Fails TestCase")
	
func test_Runner_with_one_failing_test():
	describe("Runs one failing test")
	
	runner.run("res://Examples/Bootstrap/failing_test.gd")
	yield(until_signal(runner, "ended", 2.0), YIELD)
	
	expect.is_equal(cases.size(), 1, "Creates 1 TestCase")
	expect.is_false(cases[0].success, "Fails TestCase")

func test_Runner_with_XXXX_passing_tests():
	parameters([["count"], [1], [100], [1000]])
	describe("Runs %s passing tests" % p.count as String)
	cases = []
	clear_temp()
	var directory: String = "user://WATemp"
	Directory.new().make_dir(directory)
	var test = load("res://Examples/Bootstrap/passing_test.gd")
	for i in p.count:
#		yield(until_timeout(0.0001), YIELD) # Helps but slow
		ResourceSaver.save("%s/%s.gd" % [directory, i as String], test)

	runner.run(directory)
	yield(until_signal(runner, "ended", 5.0), YIELD)
	
	expect.is_equal(cases.size(), p.count, "Creates %s TestCases" % p.count as String)
	expect.is_true(all_testcases_pass_in_range(p.count), "Passes all TestCases")
	
	# Cleanup
	clear_temp()


func display(cases):
	# HelperMethod
	self.cases = cases

func all_testcases_pass_in_range(number: int) -> bool:
	for i in number:
		if cases.empty() or cases.size() < i or not cases[i].success:
			return false
	return true