extends SceneTree

# Run (All, Directory, Script, Type*, Prefix) # Multi-Combo?
# Set (
# List (All, Directory, Methods?, Type, Prefix)
# Window = min, max, opacity
# Output (All, Fail Only)

# *When implemented
const RUNNER = preload("res://addons/WAT/Runner/runner.gd")
const SETTINGS: Resource = preload("res://addons/WAT/Settings/Config.tres")
const FILESYSTEM: Script = preload("res://addons/WAT/utils/filesystem.gd")
const VALIDATE: Script = preload("res://addons/WAT/runner/validator.gd")


	# Connect Nodes
#	RunAll.connect("pressed", TotalTimer, "_start")
#	RunAll.connect("pressed", Runner, "_run")
#	Runner.connect("ended", TotalTimer, "_stop")
#	Runner.connect("errored", TotalTimer, "_stop")
#	Expand.connect("pressed", Results, "_collapse_all", [Expand])
#	Options.connect("START_TIME", TotalTimer, "_start")
#	Options.connect("RUN", Runner, "_run")


func _init():
	print("Hello from WAT")
	execute(command())
	quit()
	
func command():
	return Array(OS.get_cmdline_args()).back()
	
func execute(command: String) -> void:
	print(command)
	match command:
		"-RUN":
			print("running tests")
			_run()
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
#			print("\n-------RESULTS-------")
#			print("\nCalculator") # Script
#			print("  Adds") # Function
#			print("    2 and 2") # ???? # Describe has two parts naming & input (what if no input?)
#			print("      Returns 4") # Expectation
#			print("    5 and 5")
#			print("      Returns 10")
#			print(" Divides")
#			print("    8 by 2")
#			print("      Returns 4")
#			print("    20 by 10")
#			print("      Returns 2")
#			print("\nWebsite")
#			print("  Registers User")
#			print("    That already exists")
#			print("      Returns Error")
#			print("  Logins User")
#			print("    That has valid credentials")
#			print("      Returns true")
#			print("\nObject")
#			print("  gets class")
#			print("     ")
#			print("    	Returns 'Object'")
#			print("\n-------RESULTS-------")

func _run():
	var Runner = RUNNER.new(VALIDATE.new(), FILESYSTEM, SETTINGS, self)
	root.add_child(Runner)
	print(Runner.Results == self)
	Runner._run()
	
func fake_fail(caselist):
	print("creating fake failures")
	for case in caselist:
		case.calculate()
		case.success = false
		for method in case.methods:
			method.success = false
			for expectation in method.expectations:
				expectation.success = false
	return caselist
	
func display(caselist: Array) -> void:
	root.queue_free()
	caselist = fake_fail(caselist)
	print("displaying caselist")
	for case in caselist:
		if not case.success:
			print("\n\nF: %s" % case.title)
			for method in case.methods:
				if not method.success:
					print("\n  f: %s" % (method.title if method.context == "" else method.context))
					for expectation in method.expectations:
						if not expectation.success:
							if expectation.context != "":
								print("\t%s" % expectation.context)
							print("\t(Expected: %s)\n\t(Result: %s)" % [expectation.expected, expectation.result])
	print("\nWAT Ended\n\n")
			
			
			
		