extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is Vector2
	self.expected = expected
	self.result = "%s is %s built in: Vector2" % [str(value), "not" if self.success else ""]