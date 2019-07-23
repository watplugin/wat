extends WATTest

func title():
	return "Intentionally Crashing Script"

func start():
	asserts.is_true(false, "This statement is false", CRASH_IF_TEST_FAILS)
	
func test_example():
	describe("If we reached this method, we failed")
	asserts.is_true(true, "This statement is true")