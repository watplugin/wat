extends WAT.TestSuite

class Example extends WATTest:
	
	func title():
		return "Running Example"
		
	func test_add() -> void:
		describe("When we add 2 + 2")
		
		asserts.is_equal(4, 2 + 2, "We get four")
		
class Example2 extends WATTest:
	
	func title():
		return "NewTest"
		
	func test_add() -> void:
		describe("When we add 10 + 2")
		
		asserts.is_equal(12, 10 + 2, "We get twelve")