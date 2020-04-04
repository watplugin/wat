extends WAT.Test

func title() -> String:
	return "Given A Range Assertion"

func test_when_calling_is_in_range() -> void:
	describe("When calling is (0) in range(0, 10)")

	var value = 0
	var low = 0
	var high = 10
	asserts.is_in_range(value, low, high, "Then it passes")
	
func test_when_calling_is_not_in_range() -> void:
	describe("When calling is (10) not in range (in range(0, 10)")

	var value = 10
	var low = 0
	var high = 10
	asserts.is_not_in_range(value, low, high, "Then it passes")
