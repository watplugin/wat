extends Reference

static func tests(files: Array) -> Array:
	var results: Array = []
	for file in files:
		if _is_WAT_test(load(file.path)):
			results.append(file.path)
	return results

static func methods(methods: Array) -> Array:
	var results: Array = []
	for method in methods:
		if method.name.begins_with("test"):
			results.append(method.name)
	return results

static func _is_WAT_test(script: Script) -> bool:
	return script.get("IS_WAT_TEST") and script.IS_WAT_TEST