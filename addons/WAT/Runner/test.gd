extends Node
class_name WATTest

const IS_WAT_TEST: bool = true
const YIELD: String = "finished"
const CRASH_IF_TEST_FAILS: bool = true
const EXPECTATIONS = preload("res://addons/WAT/expectations/0_index.gd")
const WATCHER = preload("res://addons/WAT/runner/watcher.gd")
const CONTAINER = preload("res://addons/WAT/double/container.gd")
const DOUBLE = preload("res://addons/WAT/double/factory.gd")
const PARAMETERS = preload("res://addons/WAT/runner/parameters.gd")
var expect: EXPECTATIONS
var watcher: WATCHER
var container: CONTAINER
var double: DOUBLE
var parameters: PARAMETERS
var Yield: Timer # Set by parent adapter for time being
var p: Dictionary
var rerun_method: bool = false
signal described
signal clear

func _init() -> void:
	self.expect = EXPECTATIONS.new()
	self.watcher = WATCHER.new()
	self.container = CONTAINER.new()
	self.double = DOUBLE.new()
	self.parameters = PARAMETERS.new()
	self.p = self.parameters.parameters

func any():
	return load("res://addons/WAT/Runner/any.gd").new()

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
	return self.get_script().get_path().replace("res://", "").replace("_", "?").capitalize().replace("?", "_").replace(" ", "")

func title() -> String:
	return "placeholder title"

func watch(emitter, event: String) -> void:
	watcher.watch(emitter, event)

func clear_temp():
	emit_signal("clear")

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
	return Yield.until_signal(time_limit, emitter, event)

func until_timeout(time_limit: float) -> Node:
	return Yield.until_timeout(time_limit)

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		# This is apparently necessary?
		double.clear()