extends Reference

var total: int = 0
var passed: int = 0
var title: String
var path: String
var methods: Array = []
var success: bool = false

func _on_test_method_described(description: String) -> void:
	methods.append({context = description, assertions = [], total = 0, passed = 0, success = false})
	
func _on_asserted(assertion: Object) -> void:
	# keys: success, context, details
	methods.back().assertions.append(assertion.to_dictionary())
	
func calculate() -> void:
	for method in methods:
		for assertion in method.assertions:
			method.passed += assertion.success as int
		method.total = method.assertions.size()
		method.success = method.total > 0 and method.total == method.passed
		passed += method.success as int
	total = methods.size()
	success = total > 0 and total == passed
	
func to_dictionary() -> Dictionary:
	return { "total": total, 
			 "passed": passed, 
			 "context": title, 
			 "methods": methods, 
			 "success": success,
			 "path": path
			}
