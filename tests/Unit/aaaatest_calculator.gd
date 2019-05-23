extends WATTest

signal a

func test_calculator_add_works():
	var calc = Calculator.new()
	expect.is_equal(calc.add(5, 5), 10, "5 + 5 is equal to 10")
	expect.is_equal(calc.subtract(10, 5), 5, "10 - 5 is equal to 5")
	yield(until_signal(self, "a", 1.0), YIELD)
	expect.is_true(true, "true is true miss calculator")
	calc.free()
	expect.has(4, [1, 2, 3], "4 in [123]")