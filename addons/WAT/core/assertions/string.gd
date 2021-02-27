extends "assertion.gd"

static func begins_with(value: String, string: String, context: String) -> Dictionary:
	var passed: String = "%s begins with %s" % [string, value]
	var failed: String = "%s does not begins with %s" % [string, value]
	var success = string.begins_with(value)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func contains(value: String, string: String, context: String) -> Dictionary:
	var passed: String = "%s contains %s" % [string, value]
	var failed: String = "%s does not contain %s" % [string, value]
	var success = value in string
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func does_not_begin_with(value: String, string: String, context: String) -> Dictionary:
	var passed: String = "%s does not begin with %s" % [string, value]
	var failed: String = "%s begins with %s" % [string, value]
	var success = not string.begins_with(value)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func does_not_contain(value: String, string: String, context: String) -> Dictionary:
	var passed: String = "%s does not contain %s" % [string, value]
	var failed: String = "%s contains %s" % [string, value]
	var success = not value in string
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func does_not_end_with(value: String, string: String, context: String) -> Dictionary:
	var passed: String = "%s does not end with %s" % [string, value]
	var failed: String = "%s ends with %s" % [string, value]
	var success = not string.ends_with(value)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func ends_with(value: String, string: String, context: String) -> Dictionary:
	var passed: String = "%s ends with %s" % [string, value]
	var failed: String = "%s does not end with %s" % [string, value]
	var success = string.ends_with(value)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func is_empty(value: String, context: String) -> Dictionary:
	var passed: String = "String is empty"
	var failed: String = "String %s is not empty" % [value]
	var success = value.empty()
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

