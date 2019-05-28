extends "base.gd"

func _init(a, expected: String) -> void:
	self.success = (a != null)
	self.expected = expected
	self.result = "%s %s null" % [a, ("!=" if self.success else "==")]