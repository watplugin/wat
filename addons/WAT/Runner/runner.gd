extends Node
tool

const CONFIG = preload("res://addons/WAT/Settings/Config.tres")
const TEST = preload("res://addons/WAT/test/test.gd")
const IO = preload("res://addons/WAT/utils/input_output.gd")
const COLLECT = preload("res://addons/WAT/runner/collect.gd")
var cases = load("res://addons/WAT/Runner/cases.gd").new()
onready var Yield = $Yielder
signal display_results
signal output
signal clear
var tests: Array = []
var methods: Array = []
var test: TEST

func _cancel_test_on_crash(data) -> void:
	cases.crash_current(data)
	output("CRASHED: %s (%s, Result: %s)" % [cases.current.title, data.expected, data.result])
	_end()

func output(msg: String) -> void:
	emit_signal("output", msg)

func _run(new_tests: Array = COLLECT.tests()) -> void:
	if CONFIG.test_method_prefix.empty() or CONFIG.test_method_prefix == "":
		OS.alert("You must have a test method prefix set")
		return
	if new_tests.empty():
		OS.alert("No Scripts To Test!")
		return
	clear()
	output("Starting Test Runner")
	self.tests = new_tests
	_start()

func _start() -> void:
	if tests.empty():
		output("Ending Test Runner")
		return
	test = tests.pop_front().new()
	test.connect("OUTPUT", self, "output")
	test.expect.connect("CRASHED", self, "_cancel_test_on_crash")
	cases.create(test)
	add_child(test)
	methods = COLLECT.methods(test)
	output("Executing: %s" % test.title())
	test.start()
	if cases.current.crashed:
		return
	_pre()

func _pre():
	if methods.empty():
		_end() # In case we load an empty script
	while not methods.empty():
		var method: String = methods.pop_front()
		var clean = method.substr(method.find("_"), method.length()).replace("_", " ").dedent()
		output("Executing Method: %s" % clean)
		cases.current.add_method(method)
		test.pre()
		_execute_test_method(method)

func _execute_test_method(method: String):
	test.call(method)
	if yielding():
		return
	_post()

func _post():
	test.post()
	for detail in cases.method_details_to_string():
		output(detail)
	_end() if methods.empty() else _pre()

func _end():
	test.end()
	output(cases.script_details_to_string())
	remove_child(test)
	test.queue_free()
	IO.clear_all_temp_directories()
	# Using call deferred on _start so we can start the next test on a fresh script
	call_deferred("_start")

func _finish() -> void:
	# This gets called from output because we want to make sure our output log is finished before
	# displaying results
	emit_signal("display_results", cases.list)

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
