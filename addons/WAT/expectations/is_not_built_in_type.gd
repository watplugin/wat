extends "base.gd"

func _init(value, type: int, context: String) -> void:
	self.success = not (typeof(value)) == type
	self.context = "[Expect.IsNotBuiltInType] %s" % context
	var string_type = self.TYPES.to_string(type)
	self.result = "|%s| %s %s %s" % [type2str(value), value, ("is not builtin type: " if self.success else "is builtin type: "), string_type]