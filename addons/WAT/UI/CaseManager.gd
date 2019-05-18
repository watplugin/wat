extends Node
tool

var list: Array = []

func create(title):
	var case = Case.new(title)
	list.append(case)
	return case
	
class Case:
	var details: String
	var success: bool = true
	var _tests: Dictionary = {}
	var _current_method: String
	
	func _init(details: String) -> void:
		self.details = details
	
	func add_method(method: String) -> void:
		# Called by the Test Script
		_current_method = method # Hash?
		_tests[method] = {"details": _clean_method(method), "success": true, "expectations": []}
	
	func _add_expectation(success: bool, expected: String, result: String, notes: String) -> void:
		# Called via signal from expectations.gd
		_tests[_current_method].expectations.append({"details": expected, "success": success, "result": result, "notes": notes})
		if not success:
			_tests[_current_method].success = false
			self.success = false
			
	func _clean_method(method: String) -> String:
		return method.substr(method.find("_"), method.length()).replace("_", " ").dedent()
	
	func tests() -> Array:
		return _tests.values()