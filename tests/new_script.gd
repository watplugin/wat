extends WATTest

func test_inline_data():
	parameters([["a", "b", "expected"], [2, 2, 4], [5, 5, 10], [7, 7, 14]])
	var calc = Calculator.new()
	expect.is_equal(calc.add(p.a, p.b), p.expected, "%s + %s == %s" % [p.a, p.b, p.expected])
	calc.free()

func test_inline_expectations():
	expect.loop("is_equal", [[2, 2, "2 == 2"], [5, 5, "5 == 5"], [10, 5, "10 == 5"]])