extends "base.gd"

func _init(double, method: String, args: Dictionary, context: String) -> void:
	self.result = "method: %s was not called with arguments: %s" % [method, var2str(args).replace("\n", "")]
	self.context = context
	if double.call_count(method) == 0:
		self.success = false
		self.result = "method %s was not called at all" % method
	else:
		for call in double._methods[method].calls:
			if key_value_match(args, call):
				self.result = "method: %s was called with arguments: %s" % [method, var2str(args).replace("\n", "")]
				self.success = true

func key_value_match(a: Dictionary, b: Dictionary) -> bool:
	for key in a:
		if a[key] != b[key]:
			return false
	return true