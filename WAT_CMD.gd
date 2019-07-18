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

const RUN_ALL = "-run_all"
const RUN_DIRECTORY = "-run_dir"
const RUN_SCRIPT = "-run_script"
const LIST_ALL = "-list_all"
const LIST_DIR = "-list_dir"

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
	var Runner = RUNNER.new(VALIDATE.new(), FILESYSTEM, SETTINGS, self)
	root.add_child(Runner)
	Runner._run(directory) # Need to make API consistent but a signal is a bit OTT considering?

func _list(directory: String = "res://tests") -> void:
	print()
	print(FILESYSTEM.file_list(directory))

func clear():
	# Placeholder for a signal that won't shut up from runner
	pass

func display(caselist: Array) -> void:
	var output = []
	var cases = {passed = 0, total = 0}
	var methods = {passed = 0, total = 0}
	root.get_child(0).queue_free()
	print("\n-------RESULTS-------")
	for case in caselist:
		cases.total += 1
		case.calculate()
		if case.success:
			cases.passed += 1
		if not case.success:
			print("%s" % case.title)
			for method in case.methods:
				if not method.success:
					print("\n  %s" % method.context)
					for expectation in method.expectations:
						if not expectation.success:
							print("\t%s" % expectation.context, "\n\t  (EXPECTED: %s) | (RESULT: %s)" % [expectation.expected, expectation.result])
	print("\n%s / %s Tests Passed" % [cases.passed, cases.total])
	print("-------RESULTS-------")
	if cases.total > 0 and cases.total == cases.passed:
		print(0) # Return Exit 0 -> 0 Problems
	else:
		print(1) # Return Exit 1 -> Some Problems



