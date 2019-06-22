extends WATTest

func test_partial_doubling():
	output("Hello from Test Partial")
	var calc = DOUBLE.script(Calculator, DOUBLE.PARTIAL)
	expect.is_equal(4, calc.instance.add(2, 2), "Partial Double Calculator returns super value")
	expect.was_called(calc, "add", "add was called")
	expect.is_equal(calc.call_count("add"), 1, "add was called once")
	calc.default("add", 9999)
	expect.is_equal(9999, calc.instance.add(2, 2), "Add returns incorrect value after being stubbed")
	expect.is_equal(calc.call_count("add"), 2, "add was called twice")
	calc.instance.free()
