extends Node
class_name WATTest

var expect: WATExpectations
var case: WATCase
var title: String

#### WATCHER
var watching: Dictionary = {}
#
#
func watch(instance: Object, _signal: String):
	if not expect.has_meta("test"):
		expect.set_meta("test", self)
	instance.connect(_signal, self, "_add_emitted_signal", [instance, _signal])
	watching[_signal] = {emit_count = 0, calls = []}

func _add_emitted_signal(a = null, b = null, c = null, d = null, e = null, f = null, g = null, h = null, i = null, j = null, k = null):
	var arguments: Array = [a, b, c, d, e, f, g, h, i, j, k]
	var parsed: Array = []
	var sig: String
	var obj: Object
	for i in arguments.size():
		parsed.append(arguments[i])
		if arguments[i] == null:
			obj = parsed.pop_back()
			sig = parsed.pop_back()
			break
	watching[sig].emit_count += 1
	watching[sig].calls.append({emitter = obj, args = parsed})

func _init():
	expect = WATExpectations.new()
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
	_delete_doubles()

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

# Untested
func simulate(obj, times, delta):
	for i in range(times):
		if(obj.has_method("_process")):
			obj._physics_process(delta)

		for kid in obj.get_children():
			simulate(kid, 1, delta)

func yield_until(instance, _signal, time_limit: float) -> void:
	instance.connect(_signal, self, "timeout")