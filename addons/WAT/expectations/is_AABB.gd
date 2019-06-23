extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = value is AABB
	self.expected = expected
	self.result = "%s is %s built in: AABB" % [str(value), "" if self.success else "not"]