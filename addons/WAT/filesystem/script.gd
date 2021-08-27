extends Reference

var name: String setget ,_get_sanitized_name
var dir: String
var path: String setget ,_get_path
var methods: Array # TestMethods
var names: Array # MethodNames
var time: float = 0.0 # YieldTime

func _get_sanitized_name() -> String:
	var n: String = path.substr(path.find_last("/") + 1)
	n = n.replace(".gd", "").replace(".gdc", "").replace(".cs", "")
	n = n.replace(".test", "").replace("test", "").replace("_", " ")
	n[0] = n[0].to_upper()
	return n
	
func _get_path() -> String:
	# res:/// should be res://
	return path.replace("///", "//") # 

func get_tests() -> Array:
	return [{"dir": dir, "name": self.name, "path": self.path, "methods": names, "time": time}]
