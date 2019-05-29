extends "base.gd"


func _init(double, nodepath: String, method: String, expected: String) -> void:
	self.success = double.call_count(nodepath, method) <= 0
	self.expected = expected
	self.result = "method: %s was %s called from %s" % [method, ("not" if self.success else ""), nodepath]