extends "base.gd"


func _init(a, b, expected: String) -> void:
	self.success = (a >= b)
	self.expected = expected
	self.result = "%s %s %s" % [a, ('>=' if self.success else '<='), b]