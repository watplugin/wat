extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = value is Vector2
	self.expected = expected
	self.result = "%s is %s built in: Vector2" % [str(value), "" if self.success else "not"]