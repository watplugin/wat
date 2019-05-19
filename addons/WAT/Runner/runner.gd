extends Node
tool

const TEST = preload("res://addons/WAT/test/test.gd")
const IO = preload("res://addons/WAT/utils/input_output.gd")
onready var Yield = $Yielder
onready var CaseManager = $CaseManager
onready var Collect = $Collect
signal display_results
signal output
var tests: Array = []
var methods: Array = []
var test: TEST

func output(msg: String) -> void:
	emit_signal("output", msg)

func _start() -> void:
	output("Starting TestRunner")
	clear()
	tests = Collect.tests()
	_loop()
	
func _loop() -> void:
	while not tests.empty():
		start()
		execute()
		if yielding():
			return
		end()
	finish()
	
func start() -> void:
	test = tests.pop_front().new()
	test.case = CaseManager.create(test.title())
	test.expect.connect("OUTPUT", test.case, "_add_expectation")
	add_child(test)
	methods = Collect.methods(test)
	test.start()
	output("Running TestScript: %s" % test.title())
	
func execute() -> void:
	while not methods.empty():
		var method: String = methods.pop_front()
		var clean = method.substr(method.find("_"), method.length()).replace("_", " ").dedent()
		output("Executing Method: %s" % clean)
		test.case.add_method(method)
		test.pre()
		test.call(method)
		if yielding():
			return
		test.post()
		
func end() -> void:
	test.end()
	remove_child(test)
	output("Finished Running %s" % test.title())
	for double in test.doubles:
		double.instance.free()
	test.queue_free()
	IO.clear_all_temp_directories()
	
func finish() -> void:
	emit_signal("display_results", CaseManager.list)
	clear()
	
func clear() -> void:
	tests.clear()
	methods.clear()
	CaseManager.list.clear()
	
func resume() -> void:
	output("Resuming TestScript %s" % test.title())
	test.post()
	execute()
	_loop()
	
func until_signal(emitter: Object, event: String, time_limit: float) -> Timer:
	return Yield.until_signal(time_limit, emitter, event)
	
func until_timeout(time_limit: float) -> Timer:
	return Yield.until_timeout(time_limit)

func yielding() -> bool:
	return Yield.queue.size() > 0
