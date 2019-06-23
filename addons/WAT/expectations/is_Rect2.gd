extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = value is Rect2
	self.expected = expected
	self.result = "%s is %s built in: Rect2" % [str(value), "" if self.success else "not"]