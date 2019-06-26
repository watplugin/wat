extends Reference

const CONFIG = preload("res://addons/WAT/Settings/Config.tres")

static func tests(files: Array) -> Array:
	var results: Array = []
	for file in files:
		if _has_valid_name(file.name) and _is_valid_test(file.path):
			results.append(file.path)
	return results
	
static func methods(methodlist: Array) -> Array:
	var results: Array = []
	for method in methodlist:
		if _is_valid_method(method.name):
			results.append(method.name)
	return results

static func _is_valid_method(method: String) -> bool:
	return method.begins_with(CONFIG.test_method_prefix)

static func _has_valid_name(scriptname: String) -> bool:
	if CONFIG.test_script_prefixes.empty():
		return true
	for prefix in CONFIG.test_script_prefixes:
		if scriptname.begins_with(prefix):
			return true
	return false

static func _is_valid_test(path: String) -> bool:
	var x = load(path).new()
	x.queue_free()
	return x is WATTest