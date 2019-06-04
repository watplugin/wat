extends "base.gd"

func _init(a, b, expected: String) -> void:
	self.success = (a < b)
	self.expected = expected
	self.result = "|%s| %s %s |%s| %s" % [type2str(a), a, ("<" if self.success else ">="), type2str(b), b]