extends "base.gd"


func _init(condition: bool, expected: String) -> void:
	self.success = not condition
	self.expected = expected
	self.result = "False is False" if not condition else "True is not False"
