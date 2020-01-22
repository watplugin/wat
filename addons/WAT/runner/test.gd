extends Node
class_name WATTest

const TEST: String = "Test"
const IS_WAT_TEST: bool = true
const YIELD: String = "finished"
const CRASH_IF_TEST_FAILS: bool = true
const EXPECTATIONS = preload("res://addons/WAT/expectations/0_index.gd")
const WATCHER = preload("res://addons/WAT/runner/watcher.gd")
const DOUBLE = preload("res://addons/WAT/double/factory.gd")
const PARAMETERS = preload("res://addons/WAT/runner/parameters.gd")
var asserts: EXPECTATIONS
var watcher: WATCHER
var direct: DOUBLE
var parameters: PARAMETERS
var Yield: Timer # Set by parent adapter for time being
var p: Dictionary
var rerun_method: bool = false
signal described
signal clear
var _yielder

func methods() -> PoolStringArray:
	var output: PoolStringArray = []
	for method in get_method_list():
		if method.name.begins_with("test"):
			output.append(method.name)
	return output
	
func set_name(title: String) -> void:
	name = "Test"

func initialize(assertions, yielder) -> void:
	self.asserts = assertions
	_yielder = yielder
	self.watcher = WATCHER.new()
	self.direct = DOUBLE.new()
	self.parameters = PARAMETERS.new()
	self.p = self.parameters.parameters

func any():
	return load("res://addons/WAT/runner/any.gd").new()

func describe(message: String) -> void:
	emit_signal("described", message)

func parameters(list: Array) -> void:
	rerun_method = parameters.parameters(list)

func start():
	pass

func pre():
	pass

func post():
	pass

func end():
	pass

func path() -> String:
	var path = get_script().get_path()
	return path if path != "" else get_script().get_meta("path")
	
func title() -> String:
	return "placeholder title"

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
	return _yielder.until_signal(time_limit, emitter, event)

func until_timeout(time_limit: float) -> Node:
	return _yielder.until_timeout(time_limit)

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		direct.clear()
