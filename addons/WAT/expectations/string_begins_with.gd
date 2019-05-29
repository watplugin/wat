extends "base.gd"

func _init(value, string: String, expected: String) -> void:
	self.success = string.begins_with(value)
	self.expected = expected
	self.result = "%s %s %s" % [string, ("begins with" if self.success else "does not begin with"), value]