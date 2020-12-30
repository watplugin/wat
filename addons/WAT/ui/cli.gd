extends Node

const RUN_ALL: String = "-run_all"
const RUN_DIRECTORY: String = "-run_dir"
const RUN_SCRIPT: String = "-run_script"
const RUN_TAG: String = "-run_tag"
const RUN_METHOD: String = "-run_method"
const RUN_FAILURES: String = "-rerun_failed"
const LIST_ALL: String = "-list_all"
const LIST_DIR: String = "-list_dir"
const PASSED: int = 0
const FAILED: int = 1

const TestRunner: PackedScene = preload("res://addons/WAT/test_runner/TestRunner.tscn")
var filecache = preload("res://addons/WAT/cache/test_cache.gd").new()
var _runner: Node
var _start_time: float

func _ready() -> void:
	filecache.scripts = {}
	filecache.directories = []
	filecache.script_paths = []
	filecache.initialize()
	parse(arguments())
	
func arguments() -> Array:
	return Array(OS.get_cmdline_args()).pop_back().split("=") as Array
	
func repeat(args) -> int:
	if not args.empty() and args.back().is_valid_integer():
		return args.back() as int
	else:
		return 0
		
func parse(arguments: Array) -> void:
	var tests: Array = []
	var command: String = arguments.pop_front()
	match command:
		RUN_ALL:
			tests = filecache.scripts(WAT.Settings.test_directory())
		RUN_DIRECTORY:
			tests = filecache.scripts(arguments.front())
		RUN_SCRIPT:
			tests = filecache.scripts(arguments.front())
		RUN_TAG:
			tests = filecache.tagged(arguments.front())
		RUN_METHOD:
			tests = filecache.scripts(arguments[0])
			tests[0].test.set_meta("method", arguments[1])
		RUN_FAILURES:
			tests = WAT.Settings.results.failed()
		LIST_ALL:
			_list()
			get_tree().quit()
		LIST_DIR:
			_list(arguments.pop_front())
			get_tree().quit()
		_:
			push_error("Invalid Argument")
			get_tree().quit()
	if tests.empty():
		push_warning("No Tests To Run")
		OS.exit_code = FAILED
		get_tree().quit()
	var repeat = repeat(arguments)
	tests = duplicate_tests(tests, repeat)
	_run(tests)
			
func test_directory() -> String:
	return ProjectSettings.get_setting("WAT/Test_Directory")

func _list(path: String = test_directory()):
	print()
	for script in filecache.script_paths:
		if script.begins_with(path):
			print(script)
	
func duplicate_tests(tests: Array, repeat: int) -> Array:
	var duplicates = []
	for test in tests:
		for i in repeat:
			duplicates.append(test.duplicate())
	tests += duplicates
	return tests

func _run(tests) -> void:
	_runner = TestRunner.instance()
	_runner.tests = tests
	_runner.is_editor = false
	_runner.connect("finished", self, "_on_testrunner_ended")
	_start_time = OS.get_ticks_msec()
	add_child(_runner)
	
func _on_testrunner_ended() -> void:
	_runner.queue_free()
	var caselist: Array = WAT.Settings.results().retrieve()
	var cases = {passed = 0, total = 0, crashed = 0}
	for case in caselist:
		cases.total += 1
		if case.success:
			cases.passed += 1
		else:
			display_failures(case)
	display_summary(cases)
	set_exit_code(cases)
	get_tree().quit()

func display_failures(case) -> void:
	print("%s (%s)" % [case.context, case.path])
	for method in case.methods:
		if not method.success:
			print("\n  %s" % method.context)
			for assertion in method.assertions:
				if not assertion.success:
					print("\t%s" % assertion.context, "\n\t  (EXPECTED: %s) | (RESULTED: %s)" % [assertion.expected, assertion.actual])


func display_summary(cases: Dictionary) -> void:
	cases.seconds = (OS.get_ticks_msec() - _start_time) / 1000
	print("""
	-------RESULTS-------
	Took {seconds} seconds
	{crashed} Tests Crashed
	{passed} / {total} Tests Passed
	-------RESULTS-------
	""".format(cases).dedent())
	
func set_exit_code(cases: Dictionary) -> void:
	OS.exit_code = PASSED if cases.total > 0 and cases.total == cases.passed and cases.crashed == 0 else FAILED
