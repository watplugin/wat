extends "base.gd"


func _init(a, expected: String) -> void:
	self.success = not a
	self.expected = expected
	self.result = "%s == false" % a if self.success else "%s != false" % a
