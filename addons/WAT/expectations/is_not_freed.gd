extends "base.gd"

func _init(obj: Object, expected: String) -> void:
	self.expected = expected
	self.success = is_instance_valid(obj)
	self.result = "%s is %s freed" % [obj, "not" if self.success else ""]