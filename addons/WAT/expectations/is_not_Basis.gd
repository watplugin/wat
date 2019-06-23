extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = not value is Basis
	self.expected = expected
	self.result = "%s is %s built in: Basis" % [str(value), "not" if self.success else ""]