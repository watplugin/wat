extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = value is NodePath
	self.expected = expected
	self.result = "%s is %s built in: NodePath" % [str(value), "" if self.success else "not"]