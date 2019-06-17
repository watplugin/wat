extends WATTest

func test_partial_doubling():
	var calc = DOUBLE.script(Calculator, DOUBLE.PARTIAL)
	expect.is_equal(4, calc.instance.add(2, 2), "Partial Double Calculator returns super value")
	calc.default("add", 9999)
	expect.is_equal(9999, calc.instance.add(2, 2), "Add returns incorrect value after being stubbed")
	