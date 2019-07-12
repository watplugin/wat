extends Reference


func _init(b: B, c: C):
	pass

class B:

	func _init(c: C):
		pass

class C:

	func _init(a: int, b: String):
		pass