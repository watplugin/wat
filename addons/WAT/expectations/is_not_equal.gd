extends "base.gd"

#func is_false(condition: bool, expected: String) -> void:
#	output(not


func is_false(condition: bool, expected: String) -> void:
	self.success = not condition
	self.expected = expected
	self.result = "False is False" if not condition else "True is not False"