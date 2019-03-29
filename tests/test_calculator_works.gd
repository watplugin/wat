extends WATTest

func test_calculator_add_works():
	var calc = Calculator.new()
	expect.is_equal(calc.add(5, 5), 10, "5 + 5 is equal to 10")
	expect.is_equal(calc.subtract(10, 5), 5, "10 - 5 is equal to 5")
	
	
	
	
	
	
	
	
	