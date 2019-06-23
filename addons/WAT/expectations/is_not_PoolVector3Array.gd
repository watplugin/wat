extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is PoolVector3Array
	self.expected = expected
	self.result = "%s is %s built in: PoolVector3Array" % [str(value), "not" if self.success else ""]