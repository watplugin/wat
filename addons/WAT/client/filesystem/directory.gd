extends Reference

var is_root: bool = false
var name: String setget ,_get_sanitized_name
var path: String setget ,_get_path
var relative_subdirs: Array
var nested_subdirs: Array
var tests: Array = []

func _get_sanitized_name() -> String:
	# Required for interface compability
	return path
	
func _get_path() -> String:
	# res:/// should be res://f
	return path.replace("///", "//") # 

func get_tests() -> Array:
	var requested: Array = []
	if is_root:
		for subdir in nested_subdirs:
			requested += subdir.get_tests()
	for script in tests:
		requested += script.get_tests()
	return requested
	
func is_empty() -> bool:
	return tests.empty()
