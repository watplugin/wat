extends Node

class strategy:
	# Temp Class
	static func RunScript(script: String, repeat: int = 1) -> void:
		push_warning("Strategy Script Is Empty. Run from GUI; Not CLI")
	
	static func RunTag(tag: String, repeat: int = 1) -> void:
		push_warning("Strategy Script Is Empty. Run from GUI; Not CLI")
		
	static func RunMethod(script: String, method: String, repeat: int = 1) -> void:
		push_warning("Strategy Script Is Empty. Run from GUI; Not CLI")
		
	static func RunFailures(repeat: int = 1) -> void:
		push_warning("Strategy Script Is Empty. Run from GUI; Not CLI")

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
const FileSystem: Reference = preload("res://addons/WAT/system/filesystem.gd")

var _runner: Node
var _start_time: float

func _ready() -> void:
	parse(arguments())
	
func arguments() -> Array:
	return Array(OS.get_cmdline_args()).pop_back().split("=") as Array
	
func repeat(args) -> int:
	if not args.empty() and args.back().is_valid_integer():
		return args.back() as int
	else:
		return 1
		
func parse(arguments: Array) -> void:
	var command: String = arguments.pop_front()
	match command:
		RUN_ALL:
			strategy.RunAll(repeat(arguments))
			_run()
		RUN_DIRECTORY:
			strategy.RunDirectory(arguments.front(), repeat(arguments))
			_run()
		RUN_SCRIPT:
			strategy.RunScript(arguments.front(), repeat(arguments))
			_run()
		RUN_TAG:
			strategy.RunTag(arguments.front(), repeat(arguments))
			_run()
		RUN_METHOD:
			strategy.RunMethod(arguments[0], arguments[1], repeat(arguments))
			_run()
		RUN_FAILURES:
			strategy.RunFailures(repeat(arguments))
			_run()
		LIST_ALL:
			_list()
			get_tree().quit()
		LIST_DIR:
			_list(arguments.pop_front())
			get_tree().quit()
		_:
			push_error("Invalid Argument")
			get_tree().quit()
			
func test_directory() -> String:
	return ProjectSettings.get_setting("WAT/Test_Directory")

func _list(path: String = test_directory()):
	print()
	print(FileSystem.scripts(path))

func _run() -> void:
	_runner = TestRunner.instance()
	_runner.connect("ended", self, "_on_testrunner_ended")
	_start_time = OS.get_ticks_msec()
	add_child(_runner)
	
static func set_run_path(path: String) -> void:
	ProjectSettings.set("WAT/ActiveRunPath", path)

func _on_testrunner_ended() -> void:
	_runner.queue_free()
	var caselist: Array = WAT.Results.withdraw()
	var cases = {passed = 0, total = 0, crashed = 0}
	for case in caselist:
		cases.total += 1
		if case.success:
			cases.passed += 1
		else:
			display_failures(case)
	display_summary(cases)
	set_exit_code(cases)

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
