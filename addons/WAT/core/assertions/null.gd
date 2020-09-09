extends "assertion.gd"


static func is_null(value, context: String) -> AssertionResult:
	var type = type2str(value)
	var passed: String = "|%s| %s == null" % [type, value]
	var failed: String = "|%s| %s != null" % [type, value]
	var success = (value == null)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func is_not_null(value, context: String) -> AssertionResult:
	var type = type2str(value)
	var passed: String = "|%s| %s != null" % [type, value]
	var failed: String = "|%s| %s == null" % [type, value]
	var success = (value != null)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
