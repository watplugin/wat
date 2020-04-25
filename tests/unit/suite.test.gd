extends WAT.TestSuiteOfSuites

class DummyOne extends WAT.Test:

	func title():
		return "Dummy Passing Test"

	func test_this_method_passes():
		describe("This method passes")

		asserts.is_true(true, "Passing!")
		
class DummyTwo extends WAT.Test:

	func title():
		return "Dummy Test 2"

	func test_this_method_passes():
		describe("This method passes")

		asserts.is_true(true, "Passing!")
		
	func test_fail():
	
		asserts.fail("cause i wanna again")
