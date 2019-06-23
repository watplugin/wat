extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is AABB
	self.expected = expected
	self.result = "%s is %s built in: AABB" % [str(value), "not" if self.success else ""]