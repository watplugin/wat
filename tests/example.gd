extends WAT.Test 

func test_simple():
	asserts.is_true(true)

func test_fail():
	asserts.fail("forced")
