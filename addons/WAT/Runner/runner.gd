extends Node
tool

const TEST = preload("res://addons/WAT/test/test.gd")
const IO = preload("res://addons/WAT/utils/input_output.gd")
const COLLECT = preload("res://addons/WAT/runner/collect.gd")
onready var Yield = $Yielder
var cases = load("res://addons/WAT/Runner/cases.gd").new()
signal display_results
signal output
var tests: Array = []
var methods: Array = []
var test: TEST

signal NEXT

func _ready():
	self.connect("NEXT", self, "execute")

func output(msg: String) -> void:
	emit_signal("output", msg)

func _run_single(Selector):
	clear()
	var selected: int = Selector.selected
	var path: String = Selector.get_item_text(selected)
	# make sure it exists
	if not ResourceLoader.exists(path):
		OS.alert("Script does not exist. Please reselect and run again")
		return
	tests = [load(path)]
	execute()

func _run_all() -> void:
	# Rename to _run
	# Merge with run_single at some point
	output("Starting Test Runner")
	clear()
	tests = COLLECT.tests()
	if tests.empty():
		OS.alert("No Scripts To Test!")
		return
	execute()
	
func execute(new_test: bool = true) -> void:
	if tests.empty():
		output("Ending Test Runner")
		return
		
	if new_test:
		test = tests.pop_front().new()
		cases.create(test)
		add_child(test)
		methods = COLLECT.methods(test)
		test.start()
		output("Executing: %s" % test.title())
		
	while not methods.empty():
		var method: String = methods.pop_front()
		var clean = method.substr(method.find("_"), method.length()).replace("_", " ").dedent()
		output("Executing Method: %s" % clean)
		cases.current.add_method(method)
		test.pre()
		test.call(method)
		if yielding():
			return
		test.post()
		log_method()
		
	test.end()
	log_test()
	remove_child(test)
	test.queue_free()
	IO.clear_all_temp_directories()
	emit_signal("NEXT")
		
func log_method():
	for detail in cases.method_details_to_string():
		output(detail)

func log_test():
	output(cases.script_details_to_string())
	
func _finish() -> void:
	emit_signal("display_results", cases.list)
	
func clear() -> void:
	tests.clear()
	methods.clear()
	cases.list.clear()
	
func resume() -> void:
	test.post()
	log_method()
	execute(false)
	
func until_signal(emitter: Object, event: String, time_limit: float) -> Timer:
	return Yield.until_signal(time_limit, emitter, event)
	
func until_timeout(time_limit: float) -> Timer:
	return Yield.until_timeout(time_limit)

func yielding() -> bool:
	return Yield.queue.size() > 0
