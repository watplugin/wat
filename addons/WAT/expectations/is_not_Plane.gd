extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is Plane
	self.expected = expected
	self.result = "%s is %s built in: Plane" % [str(value), "not" if self.success else ""]