extends "base.gd"

func _init(value, string: String, expected: String) -> void:
	self.success = not string.ends_with(value)
	self.expected = expected
	self.result = "%s %s %s" % [string, ("does not end with" if self.success else "ends with"), value]