extends WATTest

func title() -> String:
	return "Boolean Test"
	
func test_is_true() -> void:
	describe("Simple IsTrue")
	asserts.is_true(true, "true is true")
	
func test_is_false() -> void:
	describe("Simple IsFalse")
	asserts.is_false(false, "false is false")

func test_force_fail() -> void:
	asserts.fail("forced for action test")
