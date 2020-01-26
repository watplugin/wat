extends Node

const RUN_ALL: String = "-run_all"
const RUN_DIRECTORY: String = "-run_dir"
const RUN_SCRIPT: String = "-run_script"
const LIST_ALL: String = "-list_all"
const LIST_DIR: String = "-list_dir"
const PASSED: int = 0
const FAILED: int = 1
const TestRunner: PackedScene = preload("res://addons/WAT/runner/TestRunner.tscn")
const FileSystem: Reference = preload("res://addons/WAT/filesystem.gd")
var _runner: Node
var _start_time: float

func _ready() -> void:
	parse(arguments())
	
func arguments() -> Array:
	return Array(OS.get_cmdline_args()).pop_back().split("=") as Array
	
func parse(arguments) -> void:
	var command: String = arguments.pop_front()
	match command:
		RUN_ALL:
			_run(WAT.Settings.test_directory())
		RUN_DIRECTORY:
			_run(arguments.pop_front())
		RUN_SCRIPT:
			_run(arguments.pop_front())
		LIST_ALL:
			_list()
			get_tree().quit()
		LIST_DIR:
			_list(arguments.pop_front())
			get_tree().quit()
		_:
			push_error("Invalid Argument")
			get_tree().quit()

func _list(path: String = WAT.Settings.test_directory()):
	print()
	print(FileSystem.scripts(path))

func _run(path) -> void:
	_runner = TestRunner.instance()
	WAT.Settings.enable_autoquit()
	WAT.Settings.set_run_path(path)
	_runner.connect("ended", self, "_on_testrunner_ended", [])
	_start_time = OS.get_ticks_msec()
	add_child(_runner)

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
	var output: String = ""
	output += "\n-------RESULTS-------"
	output += "\nTook {seconds} seconds"
	output += "\n{crashed} Tests Crashed"
	output += "\n{passed} / {total} Tests Passed"
	output += "\n-------RESULTS-------"
	output = output.format(cases)
	print(output)
	
func set_exit_code(cases: Dictionary) -> void:
	OS.exit_code = PASSED if cases.total > 0 and cases.total == cases.passed and cases.crashed == 0 else FAILED
