extends WATTest

class Calc extends Reference:

	func add(a, b):
		pass

	func subtract(a, b):
		pass

	func divide(a, b):
		pass

	func multiply(a, b):
		pass

func title():
	return "Calculator"

func test_add():
	describe("Adds 2 and 2")
	asserts.is_equal(4, Calc.new().add(2, 2), "Returns 4")

func test_add2():
	describe("Adds 5 and 5")
	asserts.is_equal(10, Calc.new().add(5, 5), "Returns 10")

func test_divide():
	describe("Divides 8 by 2")
	asserts.is_equal(4, Calc.new().divide(8, 2), "Returns 4")

func test_divide2():
	describe("Divides 20 by 10")
	asserts.is_equal(2, Calc.new().divide(20, 10), "Returns 2")