extends Node

var _total: int = 0
var _passed: int = 0
var _title: String
var _path: String
var _methods: Array = []
var _success: bool = false
var _time_taken: float = 0.0
var _test: Node

func _init(test: Node, path: String) -> void:
	_test = test
	_title = test.title()
	_path = path

func add_method(name: String) -> void:
	var contxt = name.replace("_", " ").lstrip("test")
	_methods.append({fullname = name, context = contxt, assertions = [], total = 0, passed = 0, success = false, time = 0.0})

func _on_test_method_described(description: String) -> void:
	_methods.back().context = description
	
func _on_asserted(assertion: Dictionary) -> void:
	_methods.back().assertions.append(assertion)
	
func calculate() -> void:
	for method in _methods:
		for assertion in method.assertions:
			method.passed += assertion.success as int
		method.total = method.assertions.size()
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
			}
