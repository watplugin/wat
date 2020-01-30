extends WAT.Test

func title():
	return "Given the Addition Operator"

func test_add():
	parameters([["addend", "augend", "result"], [2, 2, 4], [5, 3, 8], [7, 6, 13]])
	describe("When we add {addend} to {augend}".format(p))
	var expected = p.result
	var actual = p.addend + p.augend
	asserts.is_equal(actual, expected, "Then we get {result}".format(p))
