extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is PoolStringArray
	self.expected = expected
	self.result = "%s is %s built in: PoolStringArray" % [str(value), "not" if self.success else ""]