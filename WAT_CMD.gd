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
	return Array(OS.get_cmdline_args()).back().to_upper()

func execute(command: String) -> void:
	print(command)
	match command:
		"-RUN=DIR(whatever/dir/this/is)":
			print("running directory")
		"-F":
			print("\n-------RESULTS-------")
			print("\nCalculator") # Script
			print("  Adds 2 and 2") # ???? # Describe has two parts naming & input (what if no input?)
			print("    Returns 4") # Expectation
			print("  Adds 5 and 5")
			print("    Returns 10")
			print(" Divides 8 by 2")
			print("    Returns 4")
			print(" Divides 20 by 10")
			print("    Returns 2")
			print("\nWebsite")
			print("  Registers User That already exists")
			print("    Returns Error")
			print("  Logins User That has valid credentials")
			print("    Returns true")
			print("\nObject gets class")
			print("    Returns 'Object'")
			print("\n-------RESULTS-------")
		_: # RunAll is Implicit
			print("running tests")
			_run()

func _run():
	var Runner = RUNNER.new(VALIDATE.new(), FILESYSTEM, SETTINGS, self)
	root.add_child(Runner)
	print(Runner.Results == self)
	Runner._run()

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



