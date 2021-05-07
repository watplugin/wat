extends WAT.Test

func test_assert_that():
	asserts.that(Obj.new(), "getValue", [], "Obj get value", "got true", "got false") 

class Obj:
	
	func getValue():
		return true
