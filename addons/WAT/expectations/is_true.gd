extends "base.gd"

#output(condition, expected, "True")

func _init(condition: bool, expected: String) -> void:
	self.success = condition
	self.expected = expected
	self.result = "True is True" if self.condition else "False is not True"
	self.notes = "No Notes"
