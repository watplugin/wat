extends SceneTree

# You can only call this from root. On Windows, write
# godot -s addons/WAT/CLI.gd -run_all
# to run all of the scripts
const RUNNER = preload("res://addons/WAT/Runner/runner.gd")
const FILESYSTEM: Script = preload("res://addons/WAT/filesystem.gd")
const RUN_ALL: String = "-run_all"
const RUN_DIRECTORY: String = "-run_dir"
const RUN_SCRIPT: String = "-run_script"
const LIST_ALL: String = "-list_all"
const LIST_DIR: String = "-list_dir"
const PASSED: int = 0
const FAILED: int = 1
var start_time: float

func _init():
	execute(arguments())
	quit()

func _default_directory() -> String:
	return ProjectSettings.get("WAT/Test_Directory")

func arguments() -> Array:
	return Array(OS.get_cmdline_args()).pop_back().split("=")

func execute(arguments: Array) -> void:
	var command: String = arguments.pop_front()
	match command:
		RUN_ALL:
			_run(_default_directory())
		RUN_DIRECTORY:
			_run(arguments.pop_front())
		RUN_SCRIPT:
			_run(arguments.pop_front())
		LIST_ALL:
			_list()
		LIST_DIR:
			_list(arguments.pop_front())

func _run(directory: String) -> void:
	start_time = OS.get_ticks_msec()
	var Runner = RUNNER.new(FILESYSTEM)
	Runner.connect("ended", self, "display")
	root.add_child(Runner)
	Runner.name = Runner.MAIN
	Runner.run(directory)

func _list(directory: String = "res://tests") -> void:
	print()
	print(FILESYSTEM.file_list(directory))

func display(caselist: Array) -> void:
	var cases = {passed = 0, total = 0, crashed = 0}
	print("\n-------RESULTS-------")
	for case in caselist:
		cases.total += 1
		if case.crashed:
			display_crash(case)
			cases.crashed += 1
		elif case.success:
			cases.passed += 1
		else:
			display_failures(case)
	display_summary(cases)

func display_failures(case) -> void:
	# Need to format paths to be accurate
	print("%s (%s)" % [case.title, case.path])
	for method in case.methods:
		if not method.success:
			print("\n  %s" % method.context)
			for expectation in method.expectations:
				if not expectation.success:
					print("\t%s" % expectation.context, "\n\t  (EXPECTED: %s) | (RESULT: %s)" % [expectation.expected, expectation.result])

func display_summary(cases: Dictionary) -> void:
	print("\nTook %s ms" % str(OS.get_ticks_msec() - start_time))
	print("%s Tests Crashed" % cases.crashed)
	print("%s / %s Tests Passed" % [cases.passed, cases.total])
	print("-------RESULTS-------")
	print(PASSED) if cases.total > 0 and cases.total == cases.passed and cases.crashed == 0 else print(FAILED)
	
func display_crash(case):
	print("CRASHED: %s (%s)" % [case.title, case.path])
	print("\n  (EXPECTED: %s) | (RESULT: %s)" % [case.crashdata.expected, case.crashdata.result])

