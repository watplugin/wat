extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is PoolByteArray
	self.expected = expected
	self.result = "%s is %s built in: PoolByteArray" % [str(value), "not" if self.success else ""]