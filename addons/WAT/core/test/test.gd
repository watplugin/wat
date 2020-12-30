extends Node
class_name WATTest

const Assertions: Script = preload("res://addons/WAT/core/assertions/assertions.gd")
const TEST: bool = true
const YIELD: String = "finished"
const CRASH_IF_TEST_FAILS: bool = true
signal described

# Set By A Factory Script
var path: String
var asserts: Assertions
var direct: Reference
var watcher: Reference
var yielder: Timer
var recorder: Script
var parameters: Reference
var p: Dictionary

var rerun_method: bool = false

func start():
	pass
	
func pre():
	pass
	
func post():
	pass
	
func end():
	pass

func _ready() -> void:
	p = parameters.parameters

func methods() -> PoolStringArray:
	if(get_script().has_meta("method")):
		return [get_script().get_meta("method")] as PoolStringArray
	var output: PoolStringArray = []
	for method in get_method_list():
		if method.name.begins_with("test"):
			output.append(method.name)
	return output

func record(who: Object, properties: Array) -> Node:
	var record = recorder.new()
	record.record(who, properties)
	add_child(record)
	return record

func any():
	return preload("any.gd").new()

func describe(message: String) -> void:
	emit_signal("described", message)

func parameters(list: Array) -> void:
	rerun_method = parameters.parameters(list)

func path() -> String:
	return path
#	var meta: String = ""
#	var path = get_script().get_path()
#	if get("custom_path") != null:
#		meta = get("custom_path")
#		print("is meta: ", meta)
#	return path if meta == "" else meta
	
func title() -> String:
	var path: String = get_script().get_path()
	var substr: String = path.substr(path.find_last("/") + 1, 
	path.find(".gd")).replace(".gd", "").replace("test", "").replace(".", " ").capitalize()
	return substr

func watch(emitter, event: String) -> void:
	watcher.watch(emitter, event)
	
func unwatch(emitter, event: String) -> void:
	watcher.unwatch(emitter, event)

## Untested
## Thanks to bitwes @ https://github.com/bitwes/Gut/
func simulate(obj, times, delta):
	for i in range(times):
		if(obj.has_method("_process")):
			obj._process(delta)
		if(obj.has_method("_physics_process")):
			obj._physics_process(delta)

		for kid in obj.get_children():
			simulate(kid, 1, delta)

func until_signal(emitter: Object, event: String, time_limit: float) -> Node:
	watch(emitter, event)
	return yielder.until_signal(time_limit, emitter, event)

func until_timeout(time_limit: float) -> Node:
	return yielder.until_timeout(time_limit)

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		watcher.clear()
