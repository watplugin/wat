extends "base.gd"

func _init(instance, type: Script, expected: String) -> void:
	self.success = not instance is type
	self.expected = expected
	self.result = "|%s| %s %s %s" % [type2str(instance), instance, ("is not" if self.success else "is"), type]