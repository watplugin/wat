extends "base.gd"

func _init(value, string: String, expected: String) -> void:
	self.success = not string.begins_with(value)
	self.expected = expected
	self.result = "%s %s %s" % [string, ("does not begin with" if self.success else "begins with"), value]
