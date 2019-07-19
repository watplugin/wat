extends Node
class_name WATTest

const IS_WAT_TEST: bool = true
const YIELD: String = "finished"
const CRASH_IF_TEST_FAILS: bool = true
const EXPECTATIONS = preload("res://addons/WAT/expectations/0_index.gd")
const WATCHER = preload("res://addons/WAT/test/watcher.gd")
const CONTAINER = preload("res://addons/WAT/double/container.gd")
const FACTORY = preload("res://addons/WAT/double/factory.gd")
var expect: EXPECTATIONS
var watcher: WATCHER
var container: CONTAINER
var factory: FACTORY

var _p_keys: Array = []
var _p_values: Array = []
var p: Dictionary = {}
var rerun_method: bool = false
signal described
signal clear

func _init() -> void:
	self.expect = EXPECTATIONS.new()
	self.watcher = WATCHER.new()
	self.container = CONTAINER.new()
	self.factory = FACTORY.new()

func double(path, inner: String = "", dependecies: Array = [], use_container: bool = false) -> Resource:
	return factory.double(path, inner, dependecies, container, use_container)

func double_scene(scenepath: String) -> Resource:
	return factory.double_scene(scenepath)

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		factory.clear()

class ANY extends Reference:

	func get_class() -> String:
		return "Any"

func any():
	return ANY.new()

func describe(message: String) -> void:
	emit_signal("described", message)

#parameters([["a", "b", "expected"], [2, 2, 4], [5, 5, 10], [7, 7, 14]])
func parameters(list: Array) -> void:
	if _p_keys.empty():
		# Keys aren't empty, so we'll be updating this implicilty every time a call is made instead
		self._p_keys = list.pop_front()
		self._p_values = list
	update_parameters()

func update_parameters():
	p.clear()
	var values = _p_values.pop_front()
	for i in _p_keys.size():
		p[_p_keys[i]] = values[i]
	rerun_method = not _p_values.empty()

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
	return get_parent().until_signal(time_limit, emitter, event)

func until_timeout(time_limit: float) -> Node:
	return get_parent().until_timeout(time_limit)