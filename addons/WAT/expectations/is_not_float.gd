extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is float
	self.expected = expected
	self.result = "%s is %s built in: float" % [str(value), "not" if self.success else ""]