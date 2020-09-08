extends "../base.gd"

static func is_false(value, context: String) -> AssertionResult:
	var type = type2str(value)
	var passed: String = "|%s| %s == false" % [type, value]
	var failed: String = "|%s| %s != false" % [type, value]
	var success = (value == false)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
