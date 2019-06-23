extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is PoolColorArray
	self.expected = expected
	self.result = "%s is %s built in: PoolColorArray" % [str(value), "not" if self.success else ""]