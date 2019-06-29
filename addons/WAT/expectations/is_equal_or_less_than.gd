extends "base.gd"

func _init(a, b, context: String) -> void:
	var typeofa = type2str(a)
	var typeofb = type2str(b)
	var passed: String = "|%s| %s <= |%s| %s" % [typeofa, a, typeofb, b]
	var failed: String = "|%s| %s > |%s| %s" % [typeofa, a, typeofb, b]
	self.context = "[Expect.IsEqualOrLessThan] %s" % context
	self.success = (a <= b)
	self.expected = passed
	self.result = passed if self.success else failed