extends "base.gd"

func _init(value, context: String) -> void:
	var passed: String = "%s is not builtin: Vector3" % value
	var failed: String = "%s is builtin: Vector3" % value
	self.context = "[Expect.IsNotVector3] %s" % context
	self.success = not value is Vector3 
	self.expected = passed
	self.result = passed if self.success else failed