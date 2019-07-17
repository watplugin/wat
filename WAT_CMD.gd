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

func command():
	return Array(OS.get_cmdline_args()).pop_back().replace("-", "")

func execute(command: String) -> void:
	# Commands default to lower case, don't affect casing (conflicts arg and filepaths)
	var dir = command.replace("RUN=","")
	print(dir)
	if command == "RUN=ALL":
		print("running all")
		_run()
	elif command.begins_with("RUN") and command.ends_with(".gd"):
		print("running script")
	elif command.begins_with("RUN") and Directory.new().dir_exists(command.replace("RUN=", "")):
		print("running directory") # Insist lowercase?
		_run(command.replace("RUN=", ""))
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
	root.get_child(0).queue_free()
	print("\n-------RESULTS-------")
	for case in caselist:
		case.calculate()
		if not case.success:
			print("%s" % case.title)
			for method in case.methods:
				if not method.success:
					print("\n  %s" % method.context)
					for expectation in method.expectations:
						if not expectation.success:
							print("\t%s" % expectation.context, "\n\t  (EXPECTED: %s) | (RESULT: %s)" % [expectation.expected, expectation.result])
	print("\n-------RESULTS-------")



