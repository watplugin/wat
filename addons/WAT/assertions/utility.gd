extends "assertion.gd"

static func fail(context: String = "Test Not Implemented") -> Dictionary:
	# Intentionally Fails Test
	return _result(false, "N/A", "N/A", context)
	
static func auto_pass(context: String = "Auto Pass") -> Dictionary:
	return _result(true, "N/A", "N/A", context)

# Callv does not work on virtual classes (Array etc)
static func that(obj, method: String, arguments: Array = [], context: String = "", passed: String = "", failed: String = "") -> Dictionary:
	var success = obj.callv(method, arguments)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

# asserts.that(array, "empty", [], "Array is empty", "Empty", "Found %s items" % array.size())
