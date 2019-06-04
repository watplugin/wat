extends "base.gd"


func _init(value, type: int, expected: String) -> void:
	self.success = (typeof(value)) == type
	self.expected = expected
	var string_type = self.TYPES.to_string(type)
	self.result = "%s %s %s" % [value, ("is builtin type: " if self.success else "is not builtin type: "), string_type]