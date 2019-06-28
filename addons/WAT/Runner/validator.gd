extends Reference

static func tests(files: Array, prefixes: Array) -> Array:
	var results: Array = []
	for file in files:
		if _has_valid_name(file.name, prefixes):
			results.append(file.path)
	return results

static func methods(methodlist: Array, prefix: String) -> Array:
	var results: Array = []
	for method in methodlist:
		if _is_valid_method(method.name, prefix):
			results.append(method.name)
	return results

static func _is_valid_method(method: String, prefix: String) -> bool:
	return method.begins_with(prefix)

static func _has_valid_name(scriptname: String, prefixes: Array) -> bool:
	for prefix in prefixes:
		if scriptname.begins_with(prefix):
			return true
	return false

static func test_method_prefix_is_set(prefix: String) -> bool:
	if prefix.empty() or prefix == "":
		OS.alert("You must have a test method prefix set")
		return false
	return true