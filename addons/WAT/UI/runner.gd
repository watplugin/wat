extends Node
tool

const TEST_DIRECTORY: String = "res://tests/" # Use buttons and tool menu items to affect this?
const TEST = preload("res://addons/WAT/test/test.gd")
signal display_results
signal output
var tests: Array = []
var cases: Array = []
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
		output("Running TestScript: %s" % current_test.title)
		_execute_test_methods()
		if paused:
			return
		current_test.end()
		output("Finished Running %s" % current_test.title)
		cases.append(current_test.case)
	display()
		
func prepare_test():
	current_test = tests[cursor.TEST].new()
	add_child(current_test)
	cursor.METHOD = -1
	current_test._set_test_methods() # move this method up
	current_test.start()

func display():
	emit_signal("display_results", cases)

func _execute_test_methods():
	while cursor.METHOD < current_test.methods.size() - 1:
		cursor.METHOD += 1
		var method: String = current_test.methods[cursor.METHOD]
		var clean_method = method.replace("_", " ").lstrip("test")
		output("Executing Method: %s" % clean_method)
		current_test.case.add_method(method)
		current_test.pre()
		current_test.call(method)
		if paused and yields.size() > 0:
			return
		current_test.post()

# Move this into its own thing?
var yields = []

func resume(yieldobj):
	remove_child(yieldobj)
	yields.erase(yieldobj)
	if yields.size() > 0:
		return # not resuming just yet
	output("Resuming TestScript %s" % current_test.title)
	paused = false
	current_test.post()
	_execute_test_methods()
	output("Finished Running %s" % current_test.title)
	output("Clearing all files in user/WATemp")
	cases.append(current_test.case)
	_loop()

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