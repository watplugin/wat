extends Node
class_name WATTest

const COMPLETED: String = "completed"
const TEST: bool = true
const YIELD: String = "finished"
signal described
signal cancelled
signal completed

var rerun_method: bool
var yielder: Timer
var p: Dictionary
var _last_assertion_passed: bool = false
signal method_begun

var recorder: Script = preload("res://addons/WAT/test/recorder.gd")
var any: Script = preload("res://addons/WAT/test/any.gd")
var asserts = preload("res://addons/WAT/assertions/assertions.gd").new()
var direct = preload("res://addons/WAT/double/factory.gd").new()
var _parameters = preload("res://addons/WAT/test/parameters.gd").new()
var _watcher = preload("res://addons/WAT/test/watcher.gd").new()
var _registry = preload("res://addons/WAT/double/registry.gd").new()
var _methods = []

func run(methods):
	_methods = methods()
	var cursor = -1
	yield(call_function("start"), COMPLETED)
	for function in _methods:
		if not rerun_method:
			cursor += 1
		for hook in ["pre", "execute", "post"]:
			print(hook)
			yield(call_function(hook, cursor), COMPLETED)
	yield(call_function("end"), COMPLETED)
	
func call_function(function, cursor = 0):
	var s = call(function) if function != "execute" else execute(cursor)
	call_deferred("emit_signal", COMPLETED)
	yield(s, COMPLETED) if s is GDScriptFunctionState else yield(self, COMPLETED)

func execute(cursor: int):
	print("executing ", _methods[cursor])
	var _current_method: String = _methods[cursor]
	emit_signal("method_begun", _current_method)
	return call(_current_method)

func _on_last_assertion(assertion: Dictionary) -> void:
	_last_assertion_passed = assertion["success"]

func previous_assertion_failed() -> bool:
	return not _last_assertion_passed

func _ready() -> void:
	p = _parameters.parameters
	direct.registry = _registry
	add_child(direct)

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
	return yielder.until_signal(time_limit, emitter, event)

func until_timeout(time_limit: float) -> Node:
	return yielder.until_timeout(time_limit)
	
func methods() -> PoolStringArray:
	# In future, this may be done in a container else where
	var output: PoolStringArray = []
	for method in get_method_list():
		if method.name.begins_with("test"):
			output.append(method.name)
	return output

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_registry.clear()
		_registry.free()
		_watcher.clear()
