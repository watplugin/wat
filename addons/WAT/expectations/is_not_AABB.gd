extends "base.gd"

func _init(value, context: String) -> void:
	var passed: String = "%s is not builtin: AABB" % value
	var failed: String = "%s is builtin: AABB" % value
	self.context = "[Expect.IsNotAabb] %s" % context
	self.success = not value is AABB 
	self.expected = passed
	self.result = passed if self.success else failed