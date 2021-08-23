extends Node

var _total: int = 0
var _passed: int = 0
var _directory: String
var _title: String
var _path: String
var _methods: Array = []
var _success: bool = false
var _time_taken: float = 0.0
var _test: Node
var _names: Array = []

func _init(directory, filepath, title, test) -> void:
	_test = test
	_title = title
	_path = filepath
	_directory = directory

func add_method(name: String) -> void:
	if name in _names:
		# We're running a test with multiple arguments
		return
	_names.append(name)
	var contxt = name.replace("_", " ").lstrip("test")
	_methods.append({fullname = name, context = contxt, assertions = [], total = 0, passed = 0, success = false, time = 0.0})

func _on_test_method_described(description: String) -> void:
	_methods.back().context = description
	
	# We pass this to the controller who passes it to the runner who passes 
func _on_asserted(assertion: Dictionary) -> void:
	assertion["method"] = _methods.back()["fullname"]
	assertion["script"] = _path
	# Handle on demand so we can pass it on to live updaters
	_methods.back().assertions.append(assertion)
	_methods.back()["total"] += 1
	_methods.back()["passed"] += assertion["success"] as int # false = 0, true = 1
	
func calculate() -> void:
	for method in _methods:
		method.success = method.total > 0 and method.total == method.passed
		_passed += method.success as int
	_total = _methods.size()
	_success = _total > 0 and _total == _passed
	
func to_dictionary() -> Dictionary:
	return { total = _total, 
			 passed = _passed, 
			 context = _title, 
			 methods = _methods, 
			 success = _success,
			 path = _path,
			 time_taken = _time_taken,
			 dir = _directory,
			}
