extends "base.gd"

func _init(value, low, high, expected: String) -> void:
	self.success = value > low and value < high
	self.expected = expected
	self.result = "%s is in range %s - %s" % [value, low, high] if self.success else "%s is not in range %s - %s" % [value, low, high]