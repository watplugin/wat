extends Reference

var path: String
var dir: String setget ,_get_path
var name: String setget ,_get_sanitized_name

# Method Name != test name
func get_tests() -> Array:
	return [{"dir": dir, "name": name, "path": self.path, "methods": [name], "time": 0.0}]
	
func _get_sanitized_name() -> String:
	var n: String = name.replace("test_", "").replace("_", " ")
	return n
	
func _get_path() -> String:
	# res:/// should be res://
	return path.replace("///", "//") # 
