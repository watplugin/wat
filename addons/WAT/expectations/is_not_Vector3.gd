extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is Vector3
	self.expected = expected
	self.result = "%s is %s built in: Vector3" % [str(value), "not" if self.success else ""]