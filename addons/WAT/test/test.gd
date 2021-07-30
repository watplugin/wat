extends Node
class_name WATTest

const COMPLETED: String = "completed"
const IS_WAT_TEST: bool = true
const YIELD: String = "finished"
const Executed: String = "executed"
signal described
signal completed

var rerun_method: bool
var p: Dictionary
var _last_assertion_passed: bool = false

var recorder: Script = preload("res://addons/WAT/test/recorder.gd")
var any: Script = preload("res://addons/WAT/test/any.gd")
var asserts := preload("res://addons/WAT/assertions/assertions.gd").new()
var direct = preload("res://addons/WAT/double/factory.gd").new()
var _parameters = preload("res://addons/WAT/test/parameters.gd").new()
var _watcher = preload("res://addons/WAT/test/watcher.gd").new()
var _registry = preload("res://addons/WAT/double/registry.gd").new()
var _yielder: Timer = preload("res://addons/WAT/test/yielder.gd").new()
var _case
var _methods = []
		
func setup(directory = "", filepath = "", methods = []):
	_methods = methods
	_case = preload("res://addons/WAT/test/case.gd").new(directory, filepath, title(), self)
	return self

func run():
	var cursor = -1
	yield(call_function("start"), COMPLETED)
	for function in _methods:
		if not rerun_method:
			cursor += 1
		for hook in ["pre", "execute", "post"]:
			yield(call_function(hook, cursor), COMPLETED)
	yield(call_function("end"), COMPLETED)
	get_parent().get_results(get_results())
	
func call_function(function, cursor = 0):
	var s = call(function) if function != "execute" else execute(cursor)
	call_deferred("emit_signal", COMPLETED)
	yield(s, COMPLETED) if s is GDScriptFunctionState else yield(self, COMPLETED)

func execute(cursor: int):
	var _current_method: String = _methods[cursor]
	_case.add_method(_current_method)
	return call(_current_method)

func _on_last_assertion(assertion: Dictionary) -> void:
	_last_assertion_passed = assertion["success"]

func previous_assertion_failed() -> bool:
	return not _last_assertion_passed

func _ready() -> void:
	p = _parameters.parameters
	direct.registry = _registry
	# May be better just as a property on asserts itself
	asserts.connect("asserted", self, "_on_last_assertion")
	add_child(direct)
	add_child(_yielder)
	connect("described", _case, "_on_test_method_described")
	asserts.connect("asserted", _case, "_on_asserted")
	run()

func start():
	pass
	
func pre():
	pass
	
func post():
	pass
	
func end():
	pass
	
func any():
	return any.new()
	
func watch(emitter, event: String) -> void:
	_watcher.watch(emitter, event)
	
func unwatch(emitter, event: String) -> void:
	_watcher.unwatch(emitter, event)
	
func record(who: Object, properties: Array) -> Node:
	var record = recorder.new()
	record.record(who, properties)
	add_child(record)
	return record
	
## Thanks to bitwes @ https://github.com/bitwes/Gut/
func simulate(obj, times, delta):
	for i in range(times):
		if(obj.has_method("_process")):
			obj._process(delta)
		if(obj.has_method("_physics_process")):
			obj._physics_process(delta)

		for kid in obj.get_children():
			simulate(kid, 1, delta)
	
func describe(message: String) -> void:
	emit_signal("described", message)
	
func title() -> String:
	var path: String = get_script().get_path()
	var substr: String = path.substr(path.find_last("/") + 1, 
	path.find(".gd")).replace(".gd", "").replace("test", "").replace(".", " ").capitalize()
	return substr
	
func path() -> String:
	# Expand for suites
	return get_script().get_path()
	
func parameters(list: Array) -> void:
	rerun_method = _parameters.parameters(list)
	
func until_signal(emitter: Object, event: String, time_limit: float) -> Node:
	watch(emitter, event)
	return _yielder.until_signal(time_limit, emitter, event)

func until_timeout(time_limit: float) -> Node:
	return _yielder.until_timeout(time_limit)
		
func get_results() -> Dictionary:
	_case.calculate()
	var results: Dictionary = _case.to_dictionary()
	_case.free()
	return results
	
func get_test_methods() -> Array:
	var methods: Array = []
	for method in get_script().get_script_method_list():
		if method.name.begins_with("test"):
			methods.append(method.name)
	return methods

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_registry.clear()
		_registry.free()
		_watcher.clear()
