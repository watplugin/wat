extends Node
tool

const TEST_DIRECTORY: String = "res://tests/" # Use buttons and tool menu items to affect this?
const TEST = preload("res://addons/WAT/test/test.gd")
const IO = preload("res://addons/WAT/input_output.gd")

onready var Yield = $Yielder
onready var CaseManager = $CaseManager

signal display_results
signal output
var tests: Array = []
var methods: Array = []
var cursor: Dictionary = {TEST = -1, METHOD = -1}
var test: TEST

func output(msg):
	emit_signal("output", msg)

func _start():
	cursor.TEST = -1
	cursor.METHOD = -1
	CaseManager.list = []
	tests = []
	output("Starting TestRunner")
	tests = _get_tests()
	output("%s Test Scripts Collected" % tests.size())
	_loop()
	
func yielding() -> bool:
	return Yield.queue.size() > 0
	
func _loop():
	while cursor.TEST < tests.size() - 1:
		cursor.TEST += 1
		prepare_test() # preparing next test
		output("Running TestScript: %s" % test.title())
		_execute_test_methods()
		if yielding():
			return
		test.end()
		output("Finished Running %s" % test.title())
		IO.clear_all_temp_directories()
	display()
		
func prepare_test():
	test = tests[cursor.TEST].new()
	test.case = CaseManager.create(test.title())
	test.expect.connect("OUTPUT", test.case, "_add_expectation")
	add_child(test)
	cursor.METHOD = -1
	methods = _set_test_methods()
	test.start()

func display():
	emit_signal("display_results", CaseManager.list)

func _execute_test_methods():
	while cursor.METHOD < methods.size() - 1:
		cursor.METHOD += 1
		var method: String = methods[cursor.METHOD]
		var clean = method.substr(method.find("_"), method.length()).replace("_", " ").dedent()
		output("Executing Method: %s" % clean)
		test.case.add_method(method)
		test.pre()
		test.call(method)
		if yielding():
			return
		test.post()

### BEGIN YIELDING ###
func until_signal(emitter: Object, event: String, time_limit: float):
	output("Yielding for signal: %s from emitter: %s with timeout of %s" % [event, emitter, time_limit])
	return Yield.until_signal(time_limit, emitter, event)
	
func until_timeout(time_limit: float):
	output("Yielding for %s" % time_limit)
	return Yield.until_timeout(time_limit)

func resume() -> void:
	output("Resuming TestScript %s" % test.title())
	test.post()
	_execute_test_methods()
	output("Finished Running %s" % test.title())
	output("Clearing all files in user/WATemp")
	_loop()
### END YIELDING

func _set_test_methods() -> Array:
	var results: Array = []
	for method in test.get_method_list():
		for prefix in Array(WATConfig.method_prefixes().split(",")):
			if method.name.begins_with(prefix.dedent() + "_"):
				results.append(method.name)
				break
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
			if title.ends_with(".gd"):
				for prefix in Array(WATConfig.script_prefixes().split(",")):
					if title.begins_with(prefix.dedent() + "_"):
						tests.append(load(TEST_DIRECTORY + d + "/" + title))
						break
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