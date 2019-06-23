extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is String
	self.expected = expected
	self.result = "%s is %s built in: String" % [str(value), "not" if self.success else ""]