extends Node
class_name WATTest

const Assertions: GDScript = preload("res://addons/WAT/assertions/assertions.gd")
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
var asserts: Assertions
var direct
var _parameters
var _watcher
var _registry
var _yielder: Timer
var _case
var _methods = []

signal test_method_started
signal asserted
signal test_method_finished
signal test_script_finished
signal results_received
		
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
			# Post-yield so this should be correct
			# What about repeated methods?
			if hook == "execute":
				emit_signal("test_method_finished")
	yield(call_function("end"), COMPLETED)
	emit_signal("test_script_finished", get_results())
	
func call_function(function, cursor = 0):
	var s = call(function) if function != "execute" else execute(cursor)
	call_deferred("emit_signal", COMPLETED)
	yield(s, COMPLETED) if s is GDScriptFunctionState else yield(self, COMPLETED)

func execute(cursor: int):
	var _current_method: String = _methods[cursor]
	emit_signal("test_method_started", _current_method)
	_case.add_method(_current_method)
	return call(_current_method)

func _on_assertion(assertion: Dictionary) -> void:
	_last_assertion_passed = assertion["success"]
	emit_signal("asserted", assertion)

func previous_assertion_failed() -> bool:
	return not _last_assertion_passed

func _ready() -> void:
	asserts = preload("res://addons/WAT/assertions/assertions.gd").new()
	direct = preload("res://addons/WAT/double/factory.gd").new()
	_parameters = preload("res://addons/WAT/test/parameters.gd").new()
	_watcher = preload("res://addons/WAT/test/watcher.gd").new()
	_registry = preload("res://addons/WAT/double/registry.gd").new()
	_yielder = preload("res://addons/WAT/test/yielder.gd").new()

	p = _parameters.parameters
	direct.registry = _registry
	# May be better just as a property on asserts itself
	asserts.connect("asserted", self, "_on_assertion")
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
	#get_parent().on_method_described(message)
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
