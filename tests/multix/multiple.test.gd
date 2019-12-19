extends WAT_TEST_SUITE

class Example extends WATTest:
	
	func title():
		return "Running Example"
		
	func test_add() -> void:
		describe("When we add 2 + 2")
		
		asserts.is_equal(4, 2 + 2, "We get four")