extends "base.gd"

func _init(condition: bool, expected: String) -> void:
	self.success = condition
	self.expected = expected
	self.result = "True is True" if self.success else "False is not True"
