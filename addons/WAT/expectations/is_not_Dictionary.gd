extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is Dictionary
	self.expected = expected
	self.result = "%s is %s built in: Dictionary" % [str(value), "not" if self.success else ""]