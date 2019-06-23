extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = value is Plane
	self.expected = expected
	self.result = "%s is %s built in: Plane" % [str(value), "" if self.success else "not"]