extends "base.gd"

func _init(value, string: String, expected: String) -> void:
	self.success = string.ends_with(value)
	self.expected = expected
	self.result = "%s %s %s" % [string, ("ends with" if self.success else "does not end with"), value]