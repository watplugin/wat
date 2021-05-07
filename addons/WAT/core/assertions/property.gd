extends "assertion.gd"

# ONLY FOR CONTAINER CLASSES. NOT FOR OBJECTS
static func has(value, container, context: String) -> Dictionary:
	var passed: String = "%s has %s" % [container, value]
	var failed: String = "%s has %s" % [container, value]
	var success = container.has(value)
	var expected = "%s has %s" % [container, value]
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func does_not_have(value, container, context: String) -> Dictionary:
	var passed: String = "%s does not have %s" % [container, value]
	var failed: String = "%s has %s" % [container, value]
	var success = not container.has(value)
	var expected  = "%s does not have %s" % [container, value]
	var result = passed if success else failed
	return _result(success, expected, result, context)
