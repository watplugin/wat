extends Node

const COMPLETED: String = "completed"
signal completed
var _test: Node #Test
var _case: Node
var _cursor: int = -1
var _methods: PoolStringArray = []
var _current_method: String

var _yielder = preload("res://addons/WAT/test/yielder.gd").new()

func _init() -> void:
	add_child(_yielder)
	
func run(test: Dictionary) -> void:
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
	add_child(_test)
	
	# Core run
	print("begin")
	var cursor = -1
	yield(call_function("start"), COMPLETED)
	for function in _methods:
		if not _test.rerun_method:
			cursor += 1
		for hook in ["pre", "execute", "post"]:
			print(hook)
			yield(call_function(hook, cursor), COMPLETED)
	yield(call_function("end"), COMPLETED)
	print("end")
	_test.queue_free()
	return get_results()
	
func call_function(function, cursor = 0):
	var s = _test.call(function) if function != "execute" else execute(cursor)
	call_deferred("emit_signal", COMPLETED)
	yield(s, COMPLETED) if s is GDScriptFunctionState else yield(self, COMPLETED)

func execute(cursor: int):
	print("executing ", _methods[cursor])
	var _current_method: String = _methods[cursor]
	_case.add_method(_current_method)
	return _test.call(_current_method)

func get_results() -> Dictionary:
	_case.calculate()
	var results: Dictionary = _case.to_dictionary()
	_case.free()
	return results
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE and is_instance_valid(_case):
		_case.free()
