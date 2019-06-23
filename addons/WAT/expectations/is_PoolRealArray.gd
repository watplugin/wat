extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = value is PoolRealArray
	self.expected = expected
	self.result = "%s is %s built in: PoolRealArray" % [str(value), "" if self.success else "not"]