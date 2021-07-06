extends Node

const XML: GDScript = preload("res://addons/WAT/editor/junit_xml.gd")
const FileSystem: GDScript = preload("res://addons/WAT/filesystem/filesystem.gd")
const TestRunner: GDScript = preload("res://addons/WAT/runner/TestRunner.gd")
const RUN_ALL: String = "-run_all"
const RUN_DIRECTORY: String = "-run_dir"
const RUN_SCRIPT: String = "-run_script"
const RUN_TAG: String = "-run_tag"
const RUN_METHOD: String = "-run_method"
const RUN_FAILURES: String = "-rerun_failed"
const LIST_ALL: String = "-list_all"
const LIST_DIR: String = "-list_dir"


func _ready() -> void:
	var arguments: Array = Array(OS.get_cmdline_args()).pop_back().split("=") as Array
	var command: String = arguments.pop_front()
	var filesystem = FileSystem.new()
	match command:
		RUN_ALL:
			var repeat = arguments.pop_front()
			var threads = arguments.pop_front()
			repeat = 0 if repeat == null else int(repeat) 
			threads = 1 if threads == null else int(threads)
			var tests: Array = filesystem.get_tests()
			if tests.empty():
				push_warning("No Tests Found")
				OS.set_exit_code(1)
				get_tree().quit()
				return
			_run(tests, repeat, threads)
		RUN_DIRECTORY:
			var dir: String = arguments.pop_front()
			var repeat = arguments.pop_front()
			var threads = arguments.pop_front()
			repeat = 0 if repeat == null else int(repeat) 
			threads = 1 if threads == null else int(threads)
			if not filesystem.indexed.has(dir) or filesystem.indexed[dir].empty():
				push_warning("No Tests Found")
				OS.set_exit_code(1)
				get_tree().quit()
				return
			_run(filesystem.indexed[dir]["tests"], repeat, threads)
		RUN_SCRIPT:
			var script: String = arguments.pop_front()
			var repeat = arguments.pop_front()
			var threads = arguments.pop_front()
			repeat = 0 if repeat == null else int(repeat) 
			threads = 1 if threads == null else int(threads)
			if not filesystem.indexed.has(script):
				push_warning("No Tests Found")
				OS.set_exit_code(1)
				get_tree().quit()
				return
			_run(filesystem.indexed[script].get_tests(), repeat, threads)
		RUN_METHOD:
			var script: String = arguments.pop_front()
			var method: String = arguments.pop_front()
			var repeat = arguments.pop_front()
			var threads = arguments.pop_front()
			repeat = 0 if repeat == null else int(repeat) 
			threads = 1 if threads == null else int(threads)
			if not filesystem.indexed.has(script + method):
				push_warning("No Tests Found")
				OS.set_exit_code(1)
				get_tree().quit()
				return
			_run(filesystem.indexed[script + method]["tests"], repeat, threads)
		RUN_TAG:
			push_warning("Run Tag Not Implemented")
			get_tree().quit()
		RUN_FAILURES:
			push_warning("Run Failures Not Implemented")
			get_tree().quit()
		LIST_ALL:
			var list = []
			for test in filesystem.get_tests():
				print(test["path"])
		LIST_DIR:
			var dir: String = arguments.pop_front()
			var list = []
			for test in filesystem.indexed[dir]["tests"]:
				print(test["path"].replace(dir + "/", ""))
			get_tree().quit()

func _run(tests: Array, repeat: int, threads: int) -> void:
	var runner = TestRunner.new()
	add_child(runner)
	var results = yield(runner.run(tests, repeat, threads), "completed")
	runner.queue_free()
	
	# Calculate Failures
	# This is likely best suited to be in a seperate object
	var cases = {passed = 0, total = 0, crashed = 0}
	for case in results:
		cases.total += 1
		if case.success:
			cases.passed += 1
		else:
			_display_failures(cases)
			
	_display(cases)
#	filesystem.set_failed(results)
	OS.exit_code = not int(cases.total > 0 and cases.total == cases.passed)
	get_tree().quit()
	
func _display(cases: Dictionary) -> void:
	cases.seconds = OS.get_ticks_msec() / 1000
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
