extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = value is String
	self.expected = expected
	self.result = "%s is %s built in: String" % [str(value), "" if self.success else "not"]