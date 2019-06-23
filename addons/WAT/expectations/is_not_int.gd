extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is int
	self.expected = expected
	self.result = "%s is %s built in: int" % [str(value), "not" if self.success else ""]