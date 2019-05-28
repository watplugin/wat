extends "base.gd"

func _init(instance, type: Script, expected: String) -> void:
	self.success = instance is type
	self.expected = expected
	self.result = "%s %s %s" % [instance, ("is" if self.success else "is not"), type]