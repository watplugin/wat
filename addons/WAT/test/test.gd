extends Node
class_name WATTest


# We can't namespace stuff in a single script unfortunately
# Have to keep this here for auto-completion
const EXPECTATIONS = preload("res://addons/WAT/expectations/0_index.gd")
const DOUBLE = preload("res://addons/WAT/double/scripts/doubler.gd")
const WATCHER = preload("res://addons/WAT/test/watcher.gd")
const YIELD: String = "finished"
const CRASH_IF_TEST_FAILS: bool = true
var expect: EXPECTATIONS
var watcher: WATCHER
var _p_keys: Array = []
var _p_values: Array = []
var p: Dictionary = {}
var rerun_method: bool = false
#var test_methods: Array = []
#var current_method: String

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

func _init():
	self.expect = EXPECTATIONS.new()
	self.watcher = WATCHER.new()
#	self.test_methods = test_methods
#
#func run(resuming: bool = false):
#	start()
#	execute()
#	end()
#
#func execute() -> void:
#	var next_method: String = test_methods.pop_front() if not rerun_method else current_method
#	pre()
#	call(next_method)
#	post() # Hmm?


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