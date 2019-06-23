extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = value is Transform2D
	self.expected = expected
	self.result = "%s is %s built in: Transform2D" % [str(value), "" if self.success else "not"]