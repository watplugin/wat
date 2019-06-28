extends Node
tool

const CASE = preload("res://addons/WAT/runner/case.gd")
var Results: TabContainer
var Yield: Node
var settings: Resource
var filesystem: Reference
var validate: Reference
var cases: Reference
var current_method: String
var tests: Array = []
var methods: Array = []
var caselist: Array = []
var current: CASE
var test: WATTest
signal ended

func _init(validate: Reference, filesystem: Reference, settings: Resource, Yield: Node, Results) -> void:
	self.validate = validate
	self.filesystem = filesystem
	self.settings = settings
	self.Yield = Yield
	self.Results = Results
	add_child(Yield)

func create(test) -> void:
	self.current = CASE.new(test)
	caselist.append(self.current)

func _run(directory: String = "res://tests") -> void:
	clear()
	print("WAT: Starting Test Runner")
	if not validate.test_method_prefix_is_set(settings.test_method_prefix):
		return
	self.tests = validate.tests(filesystem.file_list(directory), settings.test_script_prefixes)
	if self.tests.empty():
		OS.alert("No Scripts to Tests")
		return
	_start()

func _start() -> void:
	if tests.empty():
		print("WAT: Ending Test Runner")
		emit_signal("ended")
		Results.display(caselist)
		return
	test = load(tests.pop_front()).new()
	test.expect.connect("CRASHED", self, "_cancel_test_on_crash")
	create(test)
	add_child(test)
	methods = validate.methods(test.get_method_list(), settings.test_method_prefix)
	test.start()
	if current.crashed:
		return
	_pre()

func _pre():
	if not methods.empty() or test.rerun_method:
		self.current_method = self.current_method if test.rerun_method else methods.pop_front()
		current.add_method(current_method)
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
	# Using call deferred on _start so we can start the next test on a fresh call stack
	call_deferred("_start")

func clear() -> void:
	tests.clear()
	methods.clear()
	caselist.clear()
	Results.clear()

func until_signal(emitter: Object, event: String, time_limit: float) -> Timer:
	return Yield.until_signal(time_limit, emitter, event)

func until_timeout(time_limit: float) -> Timer:
	return Yield.until_timeout(time_limit)

func yielding() -> bool:
	return Yield.queue.size()

func _cancel_test_on_crash(data) -> void:
	current.crash(data)
	print("CRASHED: %s (%s, Result: %s)" % [current.title, data.expected, data.result])
	_end()