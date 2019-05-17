extends Node
tool

const TEST_DIRECTORY: String = "res://tests/" # Use buttons and tool menu items to affect this?
const TEST = preload("res://addons/WAT/test/test.gd")
const YIELDER = preload("res://addons/WAT/test/yielder.gd")
const IO = preload("res://addons/WAT/input_output.gd")

signal display_results
signal output

var yields: Array = []
var tests: Array = []
var cases: Array = []
var methods: Array = []
var cursor: Dictionary = {TEST = -1, METHOD = -1}
var paused: bool = false
var current_test: TEST

func output(msg):
	emit_signal("output", msg)

func _start():
	cursor.TEST = -1
	cursor.METHOD = -1
	cases = []
	tests = []
	output("Starting TestRunner")
	tests = _get_tests()
	output("%s Test Scripts Collected" % tests.size())
	_loop()
	
func _loop():
	while cursor.TEST < tests.size() - 1:
		cursor.TEST += 1
		prepare_test() # preparing next test
		output("Running TestScript: %s" % current_test.title())
		_execute_test_methods()
		if paused:
			return
		current_test.end()
		output("Finished Running %s" % current_test.title())
#		IO.clear_all_temp_directories()
		cases.append(current_test.case)
	display()
		
func prepare_test():
	current_test = tests[cursor.TEST].new()
	add_child(current_test)
	cursor.METHOD = -1
	methods = _set_test_methods()
	current_test.start()

func display():
	emit_signal("display_results", cases)

func _execute_test_methods():
	while cursor.METHOD < methods.size() - 1:
		cursor.METHOD += 1
		var method: String = methods[cursor.METHOD]
		output("Executing Method: %s" % method.replace("_", " ").lstrip("test"))
		current_test.case.add_method(method)
		current_test.pre()
		current_test.call(method)
		if paused and yields.size() > 0:
			return
		current_test.post()

### BEGIN YIELDING ###
func until_signal(emitter: Object, event: String, time_limit: float):
	output("Yielding for signal: %s from emitter: %s with timeout of %s" % [event, emitter, time_limit])
	var yieldobj = YIELDER.new(time_limit, emitter, event)
	yields.append(yieldobj)
	paused = true
	add_child(yieldobj)
	yieldobj.timer.start()
	return yieldobj
	
func until_timeout(time_limit: float):
	output("Yielding for %s" % time_limit)
	var yieldobj = YIELDER.new(time_limit, self, "", true)
	yields.append(yieldobj)
	paused = true
	add_child(yieldobj)
	yieldobj.timer.start()
	return yieldobj

func resume(yieldobj) -> void:
	remove_child(yieldobj)
	yields.erase(yieldobj)
	if yields.size() > 0:
		return # not resuming just yet
	output("Resuming TestScript %s" % current_test.title())
	paused = false
	current_test.post()
	_execute_test_methods()
	output("Finished Running %s" % current_test.title())
	output("Clearing all files in user/WATemp")
	cases.append(current_test.case)
	_loop()
### END YIELDING

func _set_test_methods() -> Array:
	var results: Array = []
	for method in current_test.get_method_list():
		if method.name.begins_with("test_"):
			results.append(method.name)
	return results

func _get_tests() -> Array:
	var ONLY_SEARCH_CHILDREN: bool = true
	var tests = []
	var dirs = _get_subdirs()
	dirs.push_front("")
	for d in dirs:
		var dir: Directory = Directory.new()
		dir.open("%s%s" % [TEST_DIRECTORY, d])
		dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
		var title = dir.get_next()
		while title != "":
			if title.begins_with("test_") and title.ends_with(".gd"):
				tests.append(load(TEST_DIRECTORY + d + "/" + title))
			title = dir.get_next()
	return tests

func _get_subdirs() -> Array:
	var results: Array = []
	var ONLY_SEARCH_CHILDREN: bool = true
	var dir: Directory = Directory.new()
	dir.open(TEST_DIRECTORY)
	dir.list_dir_begin(ONLY_SEARCH_CHILDREN)
	var title = dir.get_next()
	while title != "":
		if dir.current_is_dir():
			results.append(title)
		title = dir.get_next()
	return results