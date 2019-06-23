extends "base.gd"

func _init(value, expected: String) -> void:
	self.success = value is RID
	self.expected = expected
	self.result = "%s is %s built in: RID" % [str(value), "" if self.success else "not"]