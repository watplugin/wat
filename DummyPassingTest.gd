extends WAT.Test
	
func title():
	return "Passing Test"
	
func test_easy_pass():
	describe("Easy Pass")
	
	asserts.is_true(true, "Easy Pass")
