extends "base.gd"


func _init(a, b, context: String) -> void:
	self.success = (a != b)
	self.context = "[Expect.IsNotEqual] %s" % context
	self.result = "|%s| %s %s |%s| %s" % [type2str(a), a, ("!=" if self.success else "=="), type2str(b),b]