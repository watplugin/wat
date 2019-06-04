extends "base.gd"

#func is_false(condition: bool, expected: String) -> void:
#	output(not

func _init(a, b, expected: String):
	self.success = (a == b)
	self.expected = expected
	self.result = "|%s| %s %s |%s| %s" % [type2str(a), a, ("==" if self.success else "!="), type2str(b), b]