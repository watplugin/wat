extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = value is bool
	self.expected = expected
	self.result = "%s is %s built in: bool" % [str(value), "" if self.success else "not"]