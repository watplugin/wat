extends Node
class_name WATTest

const Assertions: Script = preload("res://addons/WAT/core/assertions/assertions.gd")
const TEST: bool = true
const YIELD: String = "finished"
signal described
signal cancelled
var asserts: Assertions
var parameters: Reference
var recorder: Script
var any: Script
var watcher
var rerun_method: bool
var direct: Object
var yielder: Timer
var p: Dictionary
var _last_assertion_passed: bool = false

func _on_last_assertion(assertion: Dictionary) -> void:
	_last_assertion_passed = assertion["success"]

func previous_assertion_failed() -> bool:
	return not _last_assertion_passed

func _ready() -> void:
	p = parameters.parameters

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
	watcher.watch(emitter, event)
	
func unwatch(emitter, event: String) -> void:
	watcher.unwatch(emitter, event)
	
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
	rerun_method = parameters.parameters(list)
	
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
