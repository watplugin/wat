extends "base.gd"

func _init(a, expected: String) -> void:
	self.success = a
	self.expected = expected
	self.result = "|%s| %s == true" % [type2str(a), a] if self.success else "<%s> %s != true" % [type2str(a), a]
