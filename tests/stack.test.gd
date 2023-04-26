extends WAT.Test

func test_simple():
	asserts.is_true(1, "boo")

func test_arrays():
	asserts.is_equal([1, 2, 3], [1, 2, 3], "Array == is by value")

func test_array_with_objs():
	var obj = Obj.new()
	asserts.is_equal([obj], [obj])
	
class Obj:
	
	func _init():
		pass
