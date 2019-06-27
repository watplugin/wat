extends WATTest

func test_Doubling_Calculator_When_Double_Strategy_is_set_to_Partial():
	var calc = DOUBLE.script(Calculator, DOUBLE.PARTIAL)
	expect.is_equal(4, calc.instance.add(2, 2), "add(2, 2) returns correct value (4)")
	expect.is_equal(calc.call_count("add"), 1, "Partially Doubled Calculator called {method: add} exactly once")
	calc.default("add", 9999)
	expect.is_equal(9999, calc.instance.add(2, 2), "add(2, 2) returns 9999 after its default return value was stubbed to 9999")
	expect.is_equal(calc.call_count("add"), 2, "add was called twice")
	calc.instance.free()
