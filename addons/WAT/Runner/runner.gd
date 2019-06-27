extends Node
tool

var initialized: bool = false
var Yield: Node
var settings: Resource
var filesystem: Reference
var validate: Reference
var cases: Reference
var current_method: String
var tests: Array = []
var methods: Array = []
var test: WATTest
signal display_results
signal output
signal clear
signal end_time

func _init(validate: Reference, filesystem: Reference, settings: Resource, Yield: Node, cases: Reference) -> void:
	self.validate = validate
	self.filesystem = filesystem
	self.settings = settings
	self.Yield = Yield
	self.cases = cases
	add_child(Yield)
	self.initialized = true

func _run(directory: String = "res://tests") -> void:
	if not initialized:
		OS.alert("Please Set Dependecies")
		return
	clear()
	output("Starting Test Runner")
	if not validate.test_method_prefix_is_set():
		return
	self.tests = validate.tests(filesystem.file_list(directory))
	if self.tests.empty():
		OS.alert("No Scripts to Tests")
		return
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
	methods = validate.methods(test.get_method_list())
	output("Executing: %s" % test.title())
	test.start()
	if cases.current.crashed:
		return
	_pre()

func _pre():
	if not methods.empty() or test.rerun_method:
		self.current_method = self.current_method if test.rerun_method else methods.pop_front()
		output("Executing Method: %s" % _get_current_method_as_alphanumeric_string())
		cases.current.add_method(current_method)
		test.pre()
		_execute_test_method(current_method)
	else:
		_end()

func _execute_test_method(method: String):
	test.call(method)
	if yielding():
		return
	_post()

func _post():
	test.post()
	_pre()

func _end():
	test.end()
	remove_child(test)
	test.queue_free()
	filesystem.clear_temporary_files()
	# Using call deferred on _start so we can start the next test on a fresh script
	call_deferred("_start")

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
	return Yield.queue.size()
	
func _cancel_test_on_crash(data) -> void:
	cases.crash_current(data)
	output("CRASHED: %s (%s, Result: %s)" % [cases.current.title, data.expected, data.result])
	_end()

func output(msg: String) -> void:
	emit_signal("output", msg)
	
func _get_current_method_as_alphanumeric_string() -> String:
	return current_method.dedent().trim_prefix(settings.test_method_prefix).replace("_", "")