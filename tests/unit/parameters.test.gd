extends WAT.Test

func title():
	return "Given the Addition Operator"

func test_add():
	parameters([["addend", "augend", "result"], [2, 2, 4], [5, 3, 8], [7, 6, 13]])
	describe("When we add %s to %s we get %s" % [p.addend as String, p.augend as String, p.result as String])
	var expected = p.result
	var actual = calculator.add(p.addend, p.augend)
	asserts.is_equal(actual, expected)

func test_subtract():
	parameters([["addend", "augend", "result"], [2, 2, 0], [5, 3, 2], [7, 6, 1]])
	describe("When we subtract %s from %s we get %s" % [p.addend as String, p.augend as String, p.result as String])
	var expected = p.result
	var actual = calculator.sub(p.addend, p.augend)
	asserts.is_equal(actual, expected)

class calculator:
	static func add(a, b):
		return a + b;
	
	static func sub(a, b):
		return a - b;
