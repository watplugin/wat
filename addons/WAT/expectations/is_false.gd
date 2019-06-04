extends "base.gd"


func _init(a, expected: String) -> void:
	self.success = not a
	self.expected = expected
	self.result = "|%s| %s == false" % [type2str(a), a] if self.success else "<%s> %s != false" % [type2str(a), a]
