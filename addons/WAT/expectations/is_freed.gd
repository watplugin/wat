extends "base.gd"

func _init(obj: Object, expected: String) -> void:
	self.expected = expected
	self.success = not is_instance_valid(obj)
	self.result = "%s is %s freed" % [obj, "" if self.success else "not"]