extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is PoolVector2Array
	self.expected = expected
	self.result = "%s is %s built in: PoolVector2Array" % [str(value), "not" if self.success else ""]