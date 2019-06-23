extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is Quat
	self.expected = expected
	self.result = "%s is %s built in: Quat" % [str(value), "not" if self.success else ""]