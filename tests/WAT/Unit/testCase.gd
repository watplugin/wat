extends WATTest

var case
var test

func pre():
	self.test = WATTest.new()
	self.test.queue_free()
	self.case = load("res://addons/WAT/Runner/case.gd").new(self.test)
	

func test_calculate_passing_when_all_tests_passed() -> void:
	describe("calculate() sets testcase to success when all tests are passing")
	
	# Arrange
	var add = {title = "add", expectations = [], total = 0, passed = 0, success = false, context = ""}
	var subtract = {title = "subtract", expectations = [], total = 0, passed = 0, success = false, context = ""}
	var divide = {title = "divide", expectations = [], total = 0, passed = 0, success = false, context = ""}
	add.expectations.append({success = true})
	subtract.expectations.append({success = true})
	divide.expectations.append({success = true})
	case.methods += [add, subtract, divide]
	
	# Act
	case.calculate()
	
	# Assert
	expect.is_true(case.success, "case is a success")
	expect.is_equal(case.passed, case.total, "passed tests are equal to total tests")
	expect.is_greater_than(case.total, 0, "there was at least one test")
	
func test_calculate_failure_when_there_are_no_tests() -> void:
	describe("calculate() sets testcase to failure when there are no tests")
	
	# Act
	case.calculate()
	
	# Assert
	expect.is_false(case.success, "case is a failure")
	expect.is_equal_or_less_than(case.passed, 0, "there are no passed tests")
	expect.is_equal_or_less_than(case.total, 0, "there are no tests at all")

func test_calculate_failure_when_there_are_failed_tests() -> void:
	describe("calculate() sets testcase to failure when some but not all tests failed")
	
	# Arrange
	var add = {title = "add", expectations = [], total = 0, passed = 0, success = false, context = ""}
	var subtract = {title = "subtract", expectations = [], total = 0, passed = 0, success = false, context = ""}
	var divide = {title = "divide", expectations = [], total = 0, passed = 0, success = false, context = ""}
	add.expectations.append({success = true})
	subtract.expectations.append({success = false})
	divide.expectations.append({success = true})
	case.methods += [add, subtract, divide]
	
	# Act
	case.calculate()
	
	# Assert
	expect.is_false(case.success, "case is a failure")
	expect.is_equal(case.total, 3, "there are three tests in total")
	expect.is_equal(case.passed, 2, "there are two passing tests")
