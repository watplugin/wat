extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = value is PoolVector3Array
	self.expected = expected
	self.result = "%s is %s built in: PoolVector3Array" % [str(value), "" if self.success else "not"]