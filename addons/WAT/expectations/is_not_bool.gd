extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is bool
	self.expected = expected
	self.result = "%s is %s built in: bool" % [str(value), "not" if self.success else ""]