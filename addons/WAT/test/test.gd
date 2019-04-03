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
#	_clear_all_directories()

func _start():
	start()
	
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

func _test_methods() -> Array:
	var results: Array = []
	for method in get_method_list():
		if method.name.begins_with("test_"):
			results.append(method.name)
	return results

func _title() -> String:
	return self.get_script().get_path()
	
func _clear_all_directories():
	var path: String = "user://WATemp/"
	var d = Directory.new()
	if not d.dir_exists(path):
		print("dir: %s does not exist" % path)
	var result = d.open(path)
	if result != OK:
		print("Error %s when trying to open dir: %s" % [str(result), path])
		return
		
	d.list_dir_begin(true)
	var file = d.get_next()
	while file != "":
		if d.current_is_dir():
			_clear_dir(path + file)
		d.remove(path + file)
		file = d.get_next()
	# Don't delete WATemp itself. Just keep it empty
	
func _clear_dir(path: String):
	var d = Directory.new()
	if not d.dir_exists(path):
		print("dir: %s does not exist" % path)
		return
	var result = d.open(path)
	if result != OK:
		print("Error %s when trying to opening dir: %s" % [str(result), path])
		return
	d.list_dir_begin(true)
	var file = d.get_next()
	while file != "":
		var res = d.remove(file)
		if res != OK:
			print("Error %s when trying to remove file: %s" % [str(res), file])
		file = d.get_next()
			
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