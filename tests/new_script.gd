extends WATTest

const X = preload("res://addons/WAT/utils/input_output.gd")
const TEST = preload("res://addons/WAT/test/test.gd")

func test_inline_data():
	parameters([["a", "b", "expected"], [2, 2, 4], [5, 5, 10], [7, 7, 14]])
	var calc = Calculator.new()
	expect.is_equal(calc.add(p.a, p.b), p.expected, "%s + %s == %s" % [p.a, p.b, p.expected])
	calc.free()

func test_inline_expectations():
	expect.loop("is_equal", [[2, 2, "2 == 2"], [5, 5, "5 == 5"], [10, 5, "10 == 5"]])
	var x = X.file_list()
	expect.is_greater_than(x.size(), 0, "Elements exist")
	var z = get_script()
	expect.is_class_instance(z, TEST, "self is WATTest")
