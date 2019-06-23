extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is Array
	self.expected = expected
	self.result = "%s is %s built in: Array" % [str(value), "not" if self.success else ""]