extends Node

var details: String
var success: bool = true
var _tests: Dictionary = {}
var _current_method: String

func _init(details: String) -> void:
	self.details = details

func add_method(method: String) -> void:
	# Called by the Test Script
	_current_method = method
	var _clean_name: String = method.replace("test_", "").replace("_", " ")
	_tests[method] = {"details": _clean_name, "success": true, "expectations": []}

func _add_expectation(success: bool, expected: String, result: String, notes: String) -> void:
	# Called via signal from expectations.gd
	_tests[_current_method].expectations.append({"details": expected, "success": success, "result": result, "notes": notes})
	if not success:
		_tests[_current_method].success = false
		self.success = false

func tests() -> Array:
	return _tests.values()