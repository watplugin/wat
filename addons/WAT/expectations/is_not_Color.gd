extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is Color
	self.expected = expected
	self.result = "%s is %s built in: Color" % [str(value), "not" if self.success else ""]