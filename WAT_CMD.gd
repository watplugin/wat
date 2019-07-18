extends SceneTree

# Only Show Failures (default, we'll update with new WinTerminal)
# RunAll
# RunDirectory
# RunScript
# SetMainDir
# SetTestScriptPrefixes Add/Remove/List
# SetTestMethodPrefix

const RUNNER = preload("res://addons/WAT/Runner/runner.gd")
const SETTINGS: Resource = preload("res://addons/WAT/Settings/Config.tres")
const FILESYSTEM: Script = preload("res://addons/WAT/utils/filesystem.gd")
const VALIDATE: Script = preload("res://addons/WAT/runner/validator.gd")


func _init():
	print("Hello from WAT")
	execute(command())
	quit()

func clear():
	# Placeholder for a signal that won't shut up from runner
	pass

func command():
	return Array(OS.get_cmdline_args()).pop_back().replace("-", "")

func execute(command: String) -> void:
	# Commands default to lower case, don't affect casing (conflicts arg and filepaths)
	var dir = command.replace("run=","")
	print(dir)
	if command == "run":
		print("running all")
		_run()
	elif command.begins_with("run") and command.ends_with(".gd"):
		print("running script")
		_run(command.replace("run=", ""))
	elif command.begins_with("run") and Directory.new().dir_exists(command.replace("run=", "")):
		print("running directory") # Insist lowercase?
		_run(command.replace("run=", ""))
	elif command.begins_with("list"):
		var files = FILESYSTEM.file_list()
		print(files)
	elif command.begins_with("SET"):
		print("Setting Value")
	else:
		print("No Command Given")

func _run(directory = "res://tests"):
	var Runner = RUNNER.new(VALIDATE.new(), FILESYSTEM, SETTINGS, self)
	root.add_child(Runner)
	print(Runner.Results == self)
	Runner._run(directory)


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



