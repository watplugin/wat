extends "base.gd"


func _init(value, string: String, expected: String) -> void:
	self.success = value in string
	self.expected = expected
	self.result = "%s %s %s" % [string, ("contains" if self.success else "does not contain"), value]