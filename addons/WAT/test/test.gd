extends Node
class_name WATTest

var watcher
var expect: WATExpectations
var case: WATCase
var title: String
const WATCHER = preload("watcher.gd")

func watch(emitter, event: String) -> void:
	watcher.watch(emitter, event)

func _init():
	watcher = WATCHER.new()
	expect = WATExpectations.new()
	expect.set_meta("watcher", self.watcher)
	case = WATCase.new(self._title())
	expect.connect("OUTPUT", case, "_add_expectation")

func run() -> void:
	_start()
	for test in _test_methods():
		case.add_method(test)
		_pre()
		call(test)
		_post()
	_end()
#	_delete_doubles()

func _start():
	pass

func _pre():
	pass

func _post():
	pass

func _end():
	pass

func _test_methods() -> Array:
	var results: Array = []
	for method in get_method_list():
		if method.name.begins_with("test_"):
			results.append(method.name)
	return results

func _title() -> String:
	return self.get_script().get_path()

func _delete_doubles():
	var BLANK: String = ""
	var WATemp: String = "user://WATemp/"
	var ONLY_SEARCH_CHILDREN: bool = true
	var dir: Directory = Directory.new()
	dir.open(WATemp)
	dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
	var file = dir.get_next()
	while file != BLANK:
		if file.begins_with("Doubled") and file.ends_with(".gd"):
			dir.remove("%s%s" % [WATemp, file])
		file = dir.get_next()
	dir.remove(WATemp)

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