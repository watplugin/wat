extends "assertion.gd"

static func fail(context: String = "Test Not Implemented") -> AssertionResult:
	# Intentionally Fails Test
	return _result(false, "N/A", "N/A", context)

static func that(obj, method: String, arguments: Array, context: String, passed: String, failed: String) -> AssertionResult:
	passed = passed % ([obj] + arguments)
	failed = failed % ([obj] + arguments)
	var success = obj.callv(method, arguments)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
