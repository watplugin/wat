extends Node
class_name WATTest

# We can't namespace stuff in a single script unfortunately
const EXPECTATIONS = preload("res://addons/WAT/test/expectations.gd")
const DOUBLE = preload("res://addons/WAT/double/doubler.gd")
const WATCHER = preload("res://addons/WAT/test/watcher.gd")
const CASE = preload("res://addons/WAT/test/case.gd")
const IO = preload("res://addons/WAT/input_output.gd")

var expect: EXPECTATIONS
var watcher: WATCHER
var case: CASE
var title: String


func _init():
	_set_properties()
	_create_connections()
	
func _set_properties():
	expect = EXPECTATIONS.new()
	watcher = WATCHER.new()
	case = CASE.new(_title())

func _create_connections():
	expect.set_meta("watcher", watcher)
	expect.connect("OUTPUT", case, "_add_expectation")
	
var methods: Array = []
var cursor: int = -1
var waiting: bool = false # Likely redundant

func _start():
	self.cursor = -1
	_set_test_methods()
	start()
	
func _is_active() -> bool:
	return not waiting and self.cursor < methods.size() - 1
	
func _get_next() -> String:
	self.cursor += 1
	return self.methods[self.cursor]
	
func start():
	pass

func _pre():
	pre()
	
func pre():
	pass
	
func _post():
	post()
	
func post():
	pass

func _end():
	end()
	
func end():
	pass

func _set_test_methods() -> void:
	var results: Array = []
	for method in get_method_list():
		if method.name.begins_with("test_"):
			results.append(method.name)
	self.methods = results

func _title() -> String:
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