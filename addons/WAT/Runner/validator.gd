extends Reference

#const CONFIG = preload("res://addons/WAT/Settings/Config.tres")

static func tests(files: Array, prefixes: Array) -> Array:
	var results: Array = []
	for file in files:
		if _has_valid_name(file.name, prefixes) and _is_valid_test(file.path):
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
	if prefixes.empty():
		return true # We accept anything
	for prefix in prefixes:
		if scriptname.begins_with(prefix):
			return true
	return false

static func _is_valid_test(path: String) -> bool:
	var x = load(path).new()
	x.queue_free()
	return x is WATTest

static func test_method_prefix_is_set(prefix: String) -> bool:
	if prefix.empty() or prefix == "":
		OS.alert("You must have a test method prefix set")
		return false
	return true