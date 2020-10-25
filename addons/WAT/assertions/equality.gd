extends "assertion.gd"

static func is_equal(a, b, context: String) -> AssertionResult:
	var typeofa = type2str(a)
	var typeofb = type2str(b)
	var passed: String = "|%s| %s is equal to |%s| %s" % [typeofa, a, typeofb, b]
	var failed: String = "|%s| %s is not equal to |%s| %s" % [typeofa, a, typeofb, b]
	var success = (a == b)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func is_not_equal(a, b, context: String) -> AssertionResult:
	var success = (a != b)
	var expected = "|%s| %s != |%s| %s" % [type2str(a), a, type2str(b), b]
	var result = "|%s| %s %s |%s| %s" % [type2str(a), a, ("is not equal to" if success else "is equal to"), type2str(b),b]
	return _result(success, expected, result, context)
	
static func is_less_than(a, b, context: String) -> AssertionResult:
	var typeofa = type2str(a)
	var typeofb = type2str(b)
	var passed: String = "|%s| %s is less than |%s| %s" % [typeofa, a, typeofb, b]
	var failed: String = "|%s| %s is equal or greater than |%s| %s" % [typeofa, a, typeofb, b]
	var success = (a < b)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func is_greater_than(a, b, context: String) -> AssertionResult:
	var typeofa = type2str(a)
	var typeofb = type2str(b)
	var passed: String = "|%s| %s is greater than |%s| %s" % [typeofa, a, typeofb, b]
	var failed: String = "|%s| %s if equal or less than |%s| %s" % [typeofa, a, typeofb, b]
	var success = (a > b)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func is_equal_or_less_than(a, b, context: String) -> AssertionResult:
	var typeofa = type2str(a)
	var typeofb = type2str(b)
	var passed: String = "|%s| %s is equal or less than |%s| %s" % [typeofa, a, typeofb, b]
	var failed: String = "|%s| %s is greater than |%s| %s" % [typeofa, a, typeofb, b]
	var success = (a <= b)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func is_equal_or_greater_than(a, b, context: String) -> AssertionResult:
	var typeofa = type2str(a)
	var typeofb = type2str(b)
	var passed: String = "|%s| %s is equal or greater |%s| %s" % [typeofa, a, typeofb, b]
	var failed: String = "|%s| %s is less than |%s| %s" % [typeofa, a, typeofb, b]
	var success = (a >= b)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)


