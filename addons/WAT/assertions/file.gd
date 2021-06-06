extends "assertion.gd"

static func exists(path: String, context: String) -> Dictionary:
	var passed: String = "%s exists" % path
	var failed: String = "%s does not exist" % path
	var success = File.new().file_exists(path)
	var expected = "%s exists" % path
	var result = passed if success else failed
	return _result(success, expected, result, context)
	
static func does_not_exist(path: String, context: String) -> Dictionary:
	var passed: String = "%s does not exist" % path
	var failed: String = "%s exists" % path
	var success = not File.new().file_exists(path)
	var expected = "%s does not exist" % path
	var result = passed if success else failed
	return _result(success, expected, result, context)
