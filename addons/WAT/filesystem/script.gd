extends Reference

var name: String setget ,_get_sanitized_name
var dir: String
var path: String setget ,_get_path
var methods: Array # TestMethods
var names: Array # MethodNames
var time: float = 0.0 # YieldTime
var parse: int # stores error code (int) of last load()

# Constructor for script.gd reference.
# script_path: Resource path of the script.
# load_result: Error code when resource path is reloaded.
func _init(script_path: String = "", load_result: int = OK):
	path = script_path
	parse = load_result

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
	return [{"dir": dir, "name": self.name, "path": self.path, "methods": names, "time": time, "parse": parse}]
