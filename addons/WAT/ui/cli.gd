extends Node

# run_all
# run_dir
# run_method
# run_tag
# run_failed
# repeats
# threads

const JUnitXML: GDScript = preload("res://addons/WAT/io/junit_xml.gd")
const Metadata: GDScript = preload("res://addons/WAT/io/metadata.gd")
const FileSystem: GDScript = preload("res://addons/WAT/filesystem/filesystem.gd")
const TestRunner: GDScript = preload("res://addons/WAT/runner/TestRunner.gd")
var _filesystem: FileSystem
var _run: Dictionary = {}
var _time_taken: float = 0.0

func _ready() -> void:
	_load_tests()
	_run = {}
	var arguments: Array = Array(OS.get_cmdline_args())
	print(arguments)
	arguments = arguments.slice(1, arguments.size())
	var run: Dictionary = {}
	for arg in arguments:
		var split = arg.split("=")
		_run[split[0]] = split[1]
	print(_run)
	_parse()
	
func _load_tests() -> void:
	_filesystem = FileSystem.new()
	Metadata.load_metadata(_filesystem)
	_filesystem.update()
	
func _parse() -> void:
	var split: Array = _run["run"].split("+")
	match split[0]:
		"all":
			run(_filesystem.root)
		"dir":
			run(_filesystem.index[split[1]])
		"script":
			run(_filesystem.index[split[1]])
		"method":
			run(_filesystem.index[split[1] + split[2]])
		"failed":
			run(_filesystem.failed)
		"tag":
			_filesystem.tagged.set_tests(split[1], _filesystem.root)
			run(_filesystem.tagged)
			print("tagged")
		_:
			get_tree().quit()
	
func run(data: Reference) -> void:
	var repeats: int = _repeats()
	var threads: int = _threads()
	
	var tests: Array = data.get_tests()
	if tests.empty():
		push_warning("WAT: No tests found")
		OS.exit_code = 1
		get_tree().quit()
	
	var runner = TestRunner.new()
	add_child(runner)
	var x = load("res://addons/WAT/ui/results/tab_container.gd").new()
	var results: Array = yield(runner.run(tests, _repeats(), _threads()), "completed")
	runner.queue_free()
	
	var cases = {passed = 0, total = 0, crashed = 0}
	for case in results:
		cases.total += 1
		if case.success:
			cases.passed += 1
		else:
			_display_failures(case)

	_display(cases)
	_filesystem.failed.update(results)
	OS.exit_code = not int(cases.total > 0 and cases.total == cases.passed)
	
	Metadata.save_metadata(_filesystem)
	JUnitXML.write(results, _filesystem.Settings, _time_taken)
	
	get_tree().quit()
	
func _get_directory():
	pass
	
func _get_script():
	pass
	
func _get_method():
	pass
	
	
func _repeats() -> int:
	if _run.has("r"):
		return _run["r"] as int
	elif _run.has("repeat"):
		return _run.has("repeat") as int
	else:
		return 0
		
func _threads() -> int:
	var threads: int = 0
	if _run.has("t"):
		threads = _run["t"] as int
	elif _run.has("thread"):
		threads = _run.has("thread") as int
	else:
		return 1
	if threads > OS.get_processor_count():
		threads = OS.get_processor_count() - 1
	return threads
	
#const XML: GDScript = preload("res://addons/WAT/io/junit_xml.gd")
#const TestRunner: GDScript = preload("res://addons/WAT/runner/TestRunner.gd")
#const FileSystem = preload("res://addons/WAT/filesystem/filesystem.gd")
#const Settings = preload("res://addons/WAT/settings.gd")
#var filesystem = FileSystem.new()
#
#func _get_tests(filepath) -> Array:
#	if filepath == "failed":
#		return filesystem.failed.get_tests()
#	if not filesystem.indexed.has(filepath):
#		return []
#	return filesystem.indexed[filepath].get_tests()

	
#func _ready() -> void:
#	var arguments: Array = Array(OS.get_cmdline_args()).pop_back().split("=") as Array
#	var command: String = arguments.pop_front()
#	match command:
#		"-run_all":
#			print("Running All Tests")
#			_run("all", arguments) # ???????????? Index primary I guess?
#		"-run_dir", "-run_script", "-run_tag":
#			# Saved Tag data isn't implemented yet but it should work here when it is
#			var dir: String = arguments.pop_front()
#			print("Running Tests of %s" % dir)
#			_run(dir, arguments)
#		"-run_method":
#			# Change documentation to have script and method be added together via a + rather than an = so they don't split in parsing
#			var script: String = arguments.pop_front()
#			var method: String = arguments.pop_front()
#			print("Running %s from %s" % [method, script])
#			_run(script + method, arguments)
#		"-rerun_failed":
#			print("Rerunning Failed Tests")
#			_run("failed", arguments)
#		"-list":
#			var path = "all" if arguments.empty() else arguments.pop_front()
#			print("\nAll Tests in %s\n" % (path if path != "all" else Settings.test_directory()))
#			for test in _get_tests(path):
#				print("", test.path.substr(test.path.find_last("/") + 1).replace("res://", ""))
#			print("\nEnd of test list\n")
#			get_tree().quit()
#
#func _run(path: String, arguments) -> void:
#	var tests = _get_tests(path)
#	if tests.empty():
#		push_warning("No Tests Found")
#		OS.set_exit_code(1)
#		get_tree().quit()
#		return
#	var repeat = arguments.pop_front()
#	var threads = arguments.pop_front()
#	repeat = 0 if repeat == null else int(repeat) 
#	threads = 1 if threads == null else int(threads)
#
#	var runner = TestRunner.new()
#	add_child(runner)
#	var results = yield(runner.run(tests, repeat, threads), "completed")
#	runner.queue_free()
#
#	# Calculate Failures
#	# This is likely best suited to be in a seperate object
#	var cases = {passed = 0, total = 0, crashed = 0}
#	for case in results:
#		cases.total += 1
#		if case.success:
#			cases.passed += 1
#		else:
#			_display_failures(case)
#
#	_display(cases)
#	filesystem.set_failed(results)
#	OS.exit_code = not int(cases.total > 0 and cases.total == cases.passed)
#	get_tree().quit()
#
func _display(cases: Dictionary) -> void:
	cases.seconds = OS.get_ticks_msec() / 1000
	_time_taken = cases.seconds
	print("""
	-------RESULTS-------
	Took {seconds} second(s)
	{crashed} Tests Crashed
	{passed} / {total} Tests Passed
	-------RESULTS-------
	""".format(cases).dedent())

func _display_failures(case) -> void:
	# We could create this somewhere else?
	print("%s (%s)" % [case.context, case.path])
	for method in case.methods:
		if not method.success:
			print("\n  %s" % method.context)
			for assertion in method.assertions:
				if not assertion.success:
					print("\t%s" % assertion.context, "\n\t  (EXPECTED: %s) | (RESULTED: %s)" % [assertion.expected, assertion.actual])
