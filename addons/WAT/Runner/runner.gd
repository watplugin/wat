extends Node
tool

const CONFIG = preload("res://addons/WAT/Settings/Config.tres")
const TEST = preload("res://addons/WAT/test/test.gd")
const IO = preload("res://addons/WAT/utils/input_output.gd")
#const COLLECT = preload("res://addons/WAT/runner/collect_gd")
var cases = load("res://addons/WAT/Runner/cases.gd").new()
onready var Yield = $Yielder
signal display_results
signal output
signal clear
var current_method: String
var tests: Array = []
var methods: Array = []
var test: TEST

func _cancel_test_on_crash(data) -> void:
	cases.crash_current(data)
	output("CRASHED: %s (%s, Result: %s)" % [cases.current.title, data.expected, data.result])
	_end()

func output(msg: String) -> void:
	emit_signal("output", msg)

func error(new_tests) -> bool:
	if CONFIG.test_method_prefix.empty() or CONFIG.test_method_prefix == "":
		OS.alert("You must have a test method prefix set")
		return true
	if new_tests.empty():
		OS.alert("No Scripts To Test!")
		return true
	return false

func collect_tests() -> Array:
	print("collecting tests")
	var tests: Array = []
	var files: Array = IO.file_list()
	for file in files:
		if _has_valid_name(file.name) and _is_valid_test(file.path):
			tests.append(file.path)
	return tests

func collect_methods(test) -> Array:
	var results: Array = []
	for method in test.get_method_list():
		if is_valid_method(method.name):
			results.append(method.name)
	return results

func is_valid_method(method: String) -> bool:
	return method.begins_with(CONFIG.test_method_prefix)

func _has_valid_name(scriptname: String) -> bool:
	if CONFIG.test_script_prefixes.empty():
		return true
	for prefix in CONFIG.test_script_prefixes:
		if scriptname.begins_with(prefix):
			return true
	return false

func _is_valid_test(path: String) -> bool:
	var x = load(path).new()
	x.queue_free()
	return x is WATTest

func _run(new_tests: Array = collect_tests()) -> void:
	if error(new_tests):
		return
	clear()
	output("Starting Test Runner")
	self.tests = new_tests
	_start()

func _start() -> void:
	if tests.empty():
		output("Ending Test Runner")
		return
	test = load(tests.pop_front()).new()
	test.connect("OUTPUT", self, "output")
	test.expect.connect("CRASHED", self, "_cancel_test_on_crash")
	cases.create(test)
	add_child(test)
	methods = collect_methods(test)
	output("Executing: %s" % test.title())
	test.start()
	if cases.current.crashed:
		return
	_pre()

func _pre():
	var clean: String
	if test.rerun_method:
		clean = current_method.substr(current_method.find("_"), current_method.length()).replace("_", " ").dedent()
		output("Executing Method: %s" % clean)
		cases.current.add_method(current_method)
		test.pre()
		_execute_test_method(current_method)
	elif not methods.empty():
		current_method = methods.pop_front()
		clean = current_method.substr(current_method.find("_"), current_method.length()).replace("_", " ").dedent()
		output("Executing Method: %s" % clean)
		cases.current.add_method(current_method)
		test.pre()
		_execute_test_method(current_method)
	elif methods.empty():
		_end()


func _execute_test_method(method: String):
	test.call(method)
	if yielding():
		return
	_post()

func _post():
	test.post()
	for detail in cases.method_details_to_string():
		output(detail)
	_pre()

func _end():
	test.end()
	output(cases.script_details_to_string())
	remove_child(test)
	test.queue_free()
	IO.clear_all_temp_directories()
	# Using call deferred on _start so we can start the next test on a fresh script
	call_deferred("_start")

signal end_time

func _finish() -> void:
	# This gets called from output because we want to make sure our output log is finished before
	# displaying results
	emit_signal("display_results", cases.list)
	emit_signal("end_time")

func clear() -> void:
	emit_signal("clear")
	tests.clear()
	methods.clear()
	cases.list.clear()

func until_signal(emitter: Object, event: String, time_limit: float) -> Timer:
	return Yield.until_signal(time_limit, emitter, event)

func until_timeout(time_limit: float) -> Timer:
	return Yield.until_timeout(time_limit)

func yielding() -> bool:
	return Yield.queue.size() > 0
