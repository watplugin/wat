extends "base.gd"


func _init(value, type: int, expected: String) -> void:
	self.success = (typeof(value)) == type
	self.expected = expected
	self.result = "%s %s %s" % [value, ("is builtin type: " if self.success else "is not builtin type: "), type]