extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = value is Object
	self.expected = expected
	self.result = "%s is %s built in: Object" % [str(value), "" if self.success else "not"]