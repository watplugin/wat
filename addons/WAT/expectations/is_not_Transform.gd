extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is Transform
	self.expected = expected
	self.result = "%s is %s built in: Transform" % [str(value), "not" if self.success else ""]