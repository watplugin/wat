extends "base.gd"

func _init(instance, type: Script, expected: String) -> void:
	self.success = not instance is type
	self.expected = expected
	self.result = "%s %s %s" % [instance, ("is not" if self.success else "is"), type]