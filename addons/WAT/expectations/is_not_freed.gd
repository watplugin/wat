extends "base.gd"

func _init(obj: Object, context: String) -> void:
	self.context = "[Expect.IsNotFreed] %s" % context
	self.success = is_instance_valid(obj)
	self.result = "%s is %s freed" % [obj, "not" if self.success else ""]