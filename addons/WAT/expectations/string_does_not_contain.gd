extends "base.gd"


func _init(value, string: String, expected: String) -> void:
	self.success = not value in string
	self.expected = expected
	self.result = "%s %s %s" % [string, ("does not contain" if self.success else "contains"), value]