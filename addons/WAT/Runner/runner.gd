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

func _run_single(Selector):
	clear()
	var selected: int = Selector.selected
	var path: String = Selector.get_item_text(selected)
	tests = [load(path)]
	_loop()

func _start() -> void:
	output("Starting Test Runner")
	clear()
	tests = Collect.tests()
	_loop()
	
func _loop() -> void:
	while not tests.empty():
		start()
		execute()
		if yielding():
			return
		# When resuming, if our tests are empty, we go straight
		# to finish, skipping the end() call
		# end()
	output("Ending Test Runner")
	# output calls finish after text changes
	
	
func start() -> void:
	test = tests.pop_front().new()
	test.case = CaseManager.create(test.title())
	test.expect.connect("OUTPUT", test.case, "_add_expectation")
	add_child(test)
	methods = Collect.methods(test)
	test.start()
	output("Executing: %s" % test.title())
	
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
		log_method()
	end()
		
func log_method():
	var method = test.case.methods.back()
	for expect in method.expectations:
		var details = expect.expected.lstrip("Expect:").dedent()
		var msg = "%s:  %s" % ["PASSED" if expect.success else "FAILED", details]
		output(msg)
	var msg = "%s:  %s" % ["PASSED" if method.success() else "FAILED", method.title]
	output(msg)
	
func log_test():
	var case = test.case
	var msg = "%s:  %s" % ["PASSED" if case.success() else "FAILED", case.title]
	output(msg)
		
func end() -> void:
	test.end()
	log_test()
	remove_child(test)
	for double in test.doubles:
		double.instance.free()
	test.queue_free()
	IO.clear_all_temp_directories()
	
func _finish() -> void:
	emit_signal("display_results", CaseManager.list)
	
func clear() -> void:
	tests.clear()
	methods.clear()
	CaseManager.list.clear()
	
func resume() -> void:
	test.post()
	log_method()
	execute()
	_loop()
	
func until_signal(emitter: Object, event: String, time_limit: float) -> Timer:
	return Yield.until_signal(time_limit, emitter, event)
	
func until_timeout(time_limit: float) -> Timer:
	return Yield.until_timeout(time_limit)

func yielding() -> bool:
	return Yield.queue.size() > 0
