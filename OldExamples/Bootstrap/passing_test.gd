extends WATTest

func title():
	return "TestCalculator"

func test_add_two_plus_two_returns_four():
	describe("add 2 plus 2")
	
	# Arrange
	var calculator = Calculator.new()
	var expected: int = 4
	
	# Act
	var actual = calculator.add(2, 2)
	
	# Assert
	asserts.is_equal(expected, actual, "returns four")
	
	# Cleanup
	calculator.free()
