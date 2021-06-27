extends Node

const COMPLETED: String = "completed"
signal completed
var _test: Node #Test
var _case: Node

var _yielder = preload("res://addons/WAT/test/yielder.gd").new()

func _init() -> void:
	add_child(_yielder)
	
func run(test: Dictionary) -> void:
	var _methods: PoolStringArray = []
	_test = load(test["path"]).new()
	_case = preload("res://addons/WAT/test/case.gd").new(_test, test)
	_test.yielder = _yielder # Requires CSharp Version
	if test.has("method"):
		_methods.append(test["method"])
	else:
		_methods = _test.methods()
	if _methods.empty():
		push_warning("No Tests found in " + test["path"] + "")
		call_deferred("_complete")
		return
	_test.connect("cancelled", self, "_on_test_cancelled")
	_test.connect("described", _case, "_on_test_method_described")
	_test.asserts.connect("asserted", _case, "_on_asserted")
	_test.asserts.connect("asserted", _test, "_on_last_assertion")
	_test.connect("method_begun", _case, "add_method")
	add_child(_test)
	
	# Core run
	print("begin")
	yield(_test.run(_methods), COMPLETED)
	print("end")
	_test.queue_free()
	return get_results()
	
func get_results() -> Dictionary:
	_case.calculate()
	var results: Dictionary = _case.to_dictionary()
	_case.free()
	return results
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE and is_instance_valid(_case):
		_case.free()
