extends "assertion.gd"

static func called_with_arguments(double, method: String, args: Array, context: String) -> Dictionary:
	var passed: String = "method: %s was called with arguments: %s" % [method, args]
	var failed: String = "method: %s was not called with arguments: %s" % [method, args]
	var alt_failed: String = "method: %s was not called at all" % method
	var expected = passed

	var success: bool
	var result: String
	if double.call_count(method) == 0:
		success = false
		result = alt_failed
	elif double.found_matching_call(method, args):
		success = true
		result = passed
	else:
		success = false
		result = failed
	return _result(success, expected, result, context)
		
static func was_called(double, method: String, context: String) -> Dictionary:
	var passed: String = "%s was called" % method
	var failed: String = "%s was not called" % method
	var success = double.call_count(method) > 0
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func was_not_called(double, method: String, context: String) -> Dictionary:
	var passed: String = "%s was not called" % method
	var failed: String = "%s was called" % method
	var success = double.call_count(method) <= 0
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
