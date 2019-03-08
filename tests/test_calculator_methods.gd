extends WATT

func test_add():
	var calc = Calculator.new()
	self.expect.is_true((calc.add(10, 5) == 15), "10 + 5 is equal to 15")
	self.expect.is_true((calc.add(20, 10) == 30), "20 + 10 is equal to 30")
	calc.free()

func test_broken_add():
	var calc = Calculator.new()
	self.expect.is_true((calc.broken_add(10, 45) == 55), "10 + 45 is equal to 55")
	self.expect.is_true((calc.broken_add(4, 4) == 8), "4 + 4 is equal to 8")
	calc.free()