extends Reference

var paths: Array = []
var _tests: Array = []

func update(results: Array) -> void:
	paths.clear()
	for result in results:
		if not result["success"]:
			paths.append(result["path"])
			
func set_tests(root: Reference) -> void:
	_tests.clear()
	for test in root.get_tests():
		if paths.has(test["path"]):
			_tests.append(test)
	
func get_tests() -> Array:
	return _tests
