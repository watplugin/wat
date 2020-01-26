extends Node

const COMPLETED: String = "completed"
var primary: bool = true
var _test_loader: WAT.TestLoader = WAT.TestLoader.new()
var _test_results: Resource
var _exit: Node
var _tests: Array = []
var _cases: Array = []
var configured: bool = false
var config: Resource
var running: bool = false
signal ended

func _ready() -> void:
	if not configured:
		configure(WAT.DefaultConfig)
		var filesystem = load("res://addons/WAT/filesystem.gd")
		_test_loader.deposit(filesystem.scripts(ProjectSettings.get("WAT/ActiveRunPath")))
	if primary:
		print("Starting WAT Test Runner")
	_tests = _test_loader.withdraw()
	if _tests.empty():
		push_warning("No Scripts To Test")

func configure(config: Resource) -> void:
	configured = true
#	_test_loader = config.test_loader
	_test_results = config.test_results
	_exit = config.exit.new()

func _process(delta: float) -> void:
	if running:
		return
	elif _tests.empty():
		end()
	else:
		run(_tests.pop_front().new())

func run(test: WAT.Test) -> void:
	running = true
	var testcase = WAT.TestCase.new(test.title(), test.path())
	test.setup(WAT.Asserts.new(), WAT.Yielder.new(), testcase, \
		WAT.TestDoubleFactory.new(), WAT.SignalWatcher.new(), WAT.Parameters.new())
	add_child(test)
	yield(test, COMPLETED)
	testcase.calculate()
	_cases.append(testcase.to_dictionary())
	remove_child(test)
	running = false
	
func end() -> void:
	if primary: print("Ending WAT Test Runner")
	_test_results.deposit(_cases)
	emit_signal("ended")
	add_child(_exit)
	WAT.clear()
	_exit.execute()
