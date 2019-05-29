extends "base.gd"


func _init(double, method: String, expected: String) -> void:
	self.success = double.call_count(method) > 0
	self.expected = expected
	self.result = "method: %s was %s called" % [method, ("" if self.success else "not")]