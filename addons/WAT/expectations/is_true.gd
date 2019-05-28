extends "base.gd"

func _init(a, expected: String) -> void:
	self.success = a
	self.expected = expected
	self.result = "%s == true" % a if self.success else "%s != true" % a
