extends Node
class_name WATTest


# We can't namespace stuff in a single script unfortunately
const EXPECTATIONS = preload("res://addons/WAT/expectations/0_index.gd")
const DOUBLE = preload("res://addons/WAT/double/scripts/doubler.gd")
const WATCHER = preload("res://addons/WAT/test/watcher.gd")
const YIELD: String = "finished"
const CRASH_IF_TEST_FAILS: bool = true
signal OUTPUT
var expect: EXPECTATIONS
var watcher: WATCHER
var _p_keys: Array = []
var _p_values: Array = []
var p: Dictionary = {}
var rerun_method: bool = false

#parameters([["a", "b", "expected"], [2, 2, 4], [5, 5, 10], [7, 7, 14]])
func parameters(list: Array) -> void:
	if _p_keys.empty():
		# Keys aren't empty, so we'll be updating this implicilty every time a call is made instead
		self._p_keys = list.pop_front()
		self._p_values = list
	update_parameters()

func update_parameters():
	print("updating")
	p.clear()
	var values = _p_values.pop_front()
	for i in _p_keys.size():
		print("index %s" % i)
		p[_p_keys[i]] = values[i]
	if not _p_values.empty():
		rerun_method = true
	else:
		rerun_method = false
		print(rerun_method, ", rerun method?")
	print("keys: %s / values: %s" % [p.keys(), p.values()])


func output(msg: String):
	emit_signal("OUTPUT", "USER: %s" % msg)

func _init():
	_set_properties()

func _set_properties():
	expect = EXPECTATIONS.new()
	watcher = WATCHER.new()


func start():
	pass

func pre():
	pass

func post():
	pass

func end():
	pass

func title() -> String:
	return self.get_script().get_path()

func watch(emitter, event: String) -> void:
	watcher.watch(emitter, event)

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
	return get_parent().until_signal(emitter, event, time_limit)

func until_timeout(time_limit: float) -> Node:
	return get_parent().until_timeout(time_limit)