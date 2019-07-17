extends "base.gd"

func _init(double, nodepath: String, method: String, context: String) -> void:
	var passed: String = "%s was not called from %s" % [method, nodepath]
	var failed: String = "%s was called from %s" % [method, nodepath]
	self.context = context
	self.success = double.call_count(nodepath, method) <= 0
	self.expected = passed
	self.result = passed if self.success else failed