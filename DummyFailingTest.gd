extends WAT.Test

func title():
	return "Failing Test"
	
func test_easy_fail():
	describe("Easy Fail")
	
	asserts.is_true(false, "Easy Fail")