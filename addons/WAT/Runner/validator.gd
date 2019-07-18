extends Reference

static func tests(files: Array, prefixes: Array) -> Array:
	var results: Array = []
	for file in files:
		if _is_WAT_test(load(file.path)):
			results.append(file.path)
	return results

static func methods(methodlist: Array, prefix: String) -> Array:
	var results: Array = []
	if _test_method_prefix_is_valid(prefix):
		for method in methodlist:
			if _is_valid_method(method.name, prefix):
				results.append(method.name)
	return results

static func _is_valid_method(method: String, prefix: String) -> bool:
	return method.begins_with(prefix)

static func _is_WAT_test(script: Script) -> bool:
	return script.has("IS_WAT_TEST") and script.IS_WAT_TEST

static func _test_method_prefix_is_valid(prefix: String) -> bool:
	if prefix.empty() or prefix == "":
		OS.alert("You must have a test method prefix set")
		return false
	return true