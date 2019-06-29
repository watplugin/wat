extends "base.gd"

func _init(double, method: String, args: Dictionary, context: String) -> void:
	var passed: String = "method: %s was called with arguments: %s" % [method, var2str(args).replace("\n", "")]
	var failed: String = "method: %s was not called with arguments: %s" % [method, var2str(args).replace("\n", "")]
	var alt_failed: String = "method: %s was not called at all" % method
	self.context = "[Expect.CalledWithArguments] %s" % context

	if double.call_count(method) == 0:
		self.success = false
		self.result = alt_failed
	elif _found_matching_call(double, method, args):
		self.success = true
		self.result = passed
	else:
		self.success = false
		self.result = failed

func _found_matching_call(double, method: String, args) -> bool:
	for call in double._methods[method].calls:
			if key_value_match(args, call):
				return true
	return false

func key_value_match(a: Dictionary, b: Dictionary) -> bool:
	for key in a:
		if a[key] != b[key]:
			return false
	return true