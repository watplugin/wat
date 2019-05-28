extends "base.gd"

func _init(value, container, expected: String) -> void:
	self.success = container.has(value)
	self.expected = expected
	self.result = "%s %s %s" % [container, ("has" if self.success else "does not have"), value]
