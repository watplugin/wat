extends WAT.Test

func test_assert_that():
	asserts.that(Obj.new(), "getValue", [], "Obj get value", "got true", "got false")
	
func test_auto_pass():
	asserts.auto_pass("Auto Passing") 

class Obj:
	
	func getValue():
		return true
