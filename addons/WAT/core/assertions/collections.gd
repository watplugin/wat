extends "assertion.gd"

static func is_empty(value, context: String) -> Dictionary:
	var passed: String = "Array is empty"
	var failed: String = "Collection is not empty (%s)" % str(value)
	var success = value.empty()
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
