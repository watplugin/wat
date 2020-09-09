extends "assertion.gd"

static func is_in_range(value, low, high, context: String) -> AssertionResult:
	var passed: String = "%s is in range(%s, %s)" % [value, low, high]
	var failed: String = "%s is not in range(%s, %s)" % [value, low, high]
	var success = value in range(low, high)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func is_not_in_range(value, low, high, context: String) -> AssertionResult:
	var passed: String = "%s is not in range(%s, %s)" % [value, low, high]
	var failed: String = "%s is in range(%s, %s)" % [value, low, high]
	var success = not value in range(low, high)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
