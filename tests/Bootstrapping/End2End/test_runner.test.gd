extends WATTest
tool
# RunManyTests (like 100, 10000)
# RunTestWithManyMethods
# RunTestMethodWithYields?

var cases: Array = []
var filesystem
var runner

func title():
	return "Given A Test Runner"
	
func start():
	filesystem = load("res://addons/WAT/filesystem.gd")
	runner = load("res://addons/WAT/Runner/runner.gd").new(filesystem)
	runner.connect("ended", self, "display")
	runner.name = "NotM"
	add_child(runner)
	
func pre():
	cases = []
	
func end():
	filesystem = null
	remove_child(runner)
	runner.queue_free()
		
func test_When_we_run_tests_using_an_invalid_path():
	describe("When we run tests using an invalid path")

	runner.run("")
	yield(until_signal(runner, "ended", 1.0), YIELD)

	asserts.is_true(cases.empty(), "Then no test cases are created")
	
func test_When_we_run_a_directory_with_no_test_scripts():
	describe("When we run a directory with no test scripts")

	# Act
	runner.run("res://Examples/Bootstrap/Empty")
	yield(until_signal(runner, "ended", 2.0), YIELD)

	# Assert
	asserts.is_true(cases.empty(), "Then no test cases are created")

func test_When_we_run_one_test_script_with_no_test_methods():
	describe("When we run one test script with no test methods")
	
	runner.run("res://Examples/Bootstrap/empty_test.gd")
	yield(until_signal(runner, "ended", 2.0), YIELD)
	
	asserts.is_equal(cases.size(), 1, "Then one test case is created")
	asserts.is_false(cases[0].success, "And it fails")
	
func test_When_we_run_one_test_method_with_no_assertions():
	describe("When we run one test method with no assertions")

	runner.run("res://Examples/Bootstrap/one_test_method_no_asserts.gd")
	yield(until_signal(runner, "ended", 2.0), YIELD)

	asserts.is_equal(cases.size(), 1, "Then one test case is created")
	asserts.is_false(cases[0].success, "And it fails")
	
func test_When_we_run_one_failing_test():
	describe("When we run one failing test")
	
	runner.run("res://Examples/Bootstrap/failing_test.gd")
	yield(until_signal(runner, "ended", 2.0), YIELD)

	asserts.is_equal(cases.size(), 1, "Then one test is created")
	asserts.is_false(cases[0].success, "And it fails")
#
#func test_Runner_with_XXXX_passing_tests():
	# Tested with 1000, seems fine but slow. Might want to work
	# on slow tests seperately
func test_When_we_run_a_hundred_passing_tests():
	describe("When we run a hundred passing tests")
	
	cases = []
	clear_temp()
	var directory: String = "user://WATemp"
	Directory.new().make_dir(directory)
	var test = load("res://Examples/Bootstrap/passing_test.gd")
	for i in 100:
#		yield(until_timeout(0.0001), YIELD) # Helps but slow
		ResourceSaver.save("%s/%s.gd" % [directory, i as String], test)

	runner.run(directory)
	yield(until_signal(runner, "ended", 5.0), YIELD)

	asserts.is_equal(cases.size(), 100, "Then a hundred test cases are created")
	asserts.is_true(all_testcases_pass_in_range(100), "And all a hundred test cases pass")


func display(cases):
	# HelperMethod
	self.cases = cases

func all_testcases_pass_in_range(number: int) -> bool:
	for i in number:
		if cases.empty() or cases.size() < i or not cases[i].success:
			return false
	return true
