extends "assertion.gd"

static func is_empty(value, context: String) -> Dictionary:
	var passed: String = "Array is empty"
	var failed: String = "Collection is not empty (%s)" % str(value)
	var success = value.empty()
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)

static func is_size(collection, value: int, context: String) -> Dictionary:
	# var type2str(array
	var size = collection.size()
	var passed: String = "Collection size is %s" % value
	var failed: String = "Collection size is not %s (Actual size is %s)" % [value, size]
	var success = (value == size)
	var expected = passed
	var result = passed if success else failed
	return _result(success, expected, result, context)
