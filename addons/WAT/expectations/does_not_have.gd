extends "base.gd"

func _init(value, container, expected: String) -> void:
	self.success = not container.has(value)
	self.expected = expected
	self.result = "%s %s %s" % [container, ("does not have" if self.success else "has"), value]