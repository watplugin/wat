extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = value is Quat
	self.expected = expected
	self.result = "%s is %s built in: Quat" % [str(value), "" if self.success else "not"]