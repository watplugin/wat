extends WAT.Test

func title():
	return "Given an Equality Assertion"

func test_when_calling_is_equal():
	describe("When calling asserts.is_equal(1, 1)")
	
	asserts.is_equal(1, 1, "Then it passes")
	
func test_when_calling_is_greater_than():
	describe("When calling asserts.is_greater_than(2, 1)")
	
	asserts.is_greater_than(2, 1, "Then it passes")
	
func test_when_calling_is_less_than():
	describe("When calling asserts.is_less_than(2, 1)")

	asserts.is_less_than(1, 2, "Then it passes")
	
func test_when_calling_is_equal_or_greater_than():
	describe("When calling asserts.is_equal_or_greater_than(2, 1)")
	
	asserts.is_equal_or_greater_than(2, 1, "Then it passes")
	
func test_when_calling_is_equal_or_greater_than_with_equal_values():
	describe("When calling asserts.is_equal_or_greater_than(1, 1)")
	
	asserts.is_equal_or_greater_than(1, 1, "Then it passes")
	
func test_when_calling_is_equal_or_less_than_with_equal_values():
	describe("When calling asserts.is_equal_or_less_than(1, 1)")
	
	asserts.is_equal_or_less_than(1, 1, "Then it passes!")
	
func test_when_calling_is_not_equal():
	describe("When callign asserts.is_not_equal(5, 6)")
	
	asserts.is_not_equal(5, 6, "Then it passes")
