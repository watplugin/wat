extends Node
class_name WATCase

var details: String
var success: bool = true
var tests: Dictionary = {}
var _current_method: String


func _init(details: String) -> void:
	self.details = details.replace("test_", "")
	
func add_method(method: String) -> void:
	# Called by the Test Script
	method = method.replace("test_", "")
	self.current_method = method
	self.tests[method] = {"details": method, "success": true, "expectations": []}
	
func _add_expectations(expectation: String, success: bool) -> void:
	# Called via signal from expectations.gd
	self.tests[self._current_method] = {"details": expectation, "success": success}
	if not success:
		self.tests[self._current_method].success = false