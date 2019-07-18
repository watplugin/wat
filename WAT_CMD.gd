extends SceneTree

# ToAdd
# - Verbose (shows passed tests as well)
# - Set Main Test Directory
# - Set Test Method Prefix?

# DontAdd
# - Set Test Script Prefixes (because we will be removing the prefix system in place of CONST or staticfunc is test())

const RUNNER = preload("res://addons/WAT/Runner/runner.gd")
const SETTINGS: Resource = preload("res://addons/WAT/Settings/Config.tres")
const FILESYSTEM: Script = preload("res://addons/WAT/utils/filesystem.gd")
const VALIDATE: Script = preload("res://addons/WAT/runner/validator.gd")

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

func arguments() -> Array:
	return Array(OS.get_cmdline_args()).pop_back().split("=")

func execute(arguments: Array) -> void:
	var command: String = arguments.pop_front()
	match command:
		RUN_ALL:
			_run()
		RUN_DIRECTORY:
			_run(arguments.pop_front())
		RUN_SCRIPT:
			_run(arguments.pop_front())
		LIST_ALL:
			_list()
		LIST_DIR:
			_list(arguments.pop_front())

func _run(directory: String = "res://tests") -> void:
	start_time = OS.get_ticks_msec()
	var Runner = RUNNER.new(VALIDATE.new(), FILESYSTEM, SETTINGS, self)
	root.add_child(Runner)
	Runner._run(directory) # Need to make API consistent but a signal is a bit OTT considering?
	root.get_child(0).queue_free()
func _list(directory: String = "res://tests") -> void:
	print()
	print(FILESYSTEM.file_list(directory))

func clear(): # Placeholder for a signal that won't shut up from runner
	pass

func display(caselist: Array) -> void:
	var cases = {passed = 0, total = 0}
	print("\n-------RESULTS-------")
	for case in caselist:
		case.calculate()
		cases.total += 1
		if case.success:
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
	print("%s / %s Tests Passed" % [cases.passed, cases.total])
	print("-------RESULTS-------")
	print(PASSED) if cases.total > 0 and cases.total == cases.passed else print(FAILED)

