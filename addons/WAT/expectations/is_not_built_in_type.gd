extends "base.gd"

func _init(value, type: int, expected: String) -> void:
	self.success = not (typeof(value)) == type
	self.expected = expected
	self.result = "%s %s %s" % [value, ("is not builtin type: " if self.success else "is builtin type: "), type]