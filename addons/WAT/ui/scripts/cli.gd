extends Node


const RUN_ALL: String = "-run_all"
const RUN_DIRECTORY: String = "-run_dir"
const RUN_SCRIPT: String = "-run_script"
const RUN_TAG: String = "-run_tag"
const RUN_METHOD: String = "-run_method"
const RUN_FAILURES: String = "-rerun_failed"
const LIST_ALL: String = "-list_all"
const LIST_DIR: String = "-list_dir"
const PASSED: int = 0
const FAILED: int = 1
var test
const TestRunner: GDScript = preload("res://addons/WAT/core/test_runner/test_runner.gd")

var _runner: Node
var _start_time: float

func _ready() -> void:
	parse(arguments())
	
func arguments() -> Array:
	return Array(OS.get_cmdline_args()).pop_back().split("=") as Array

func parse(arguments: Array) -> void:
	test = load("res://addons/WAT/editor/test_gatherer.gd").new().discover()
	var command: String = arguments.pop_front()
	match command:
		RUN_ALL:
			var repeat = arguments.pop_front()
			var threads = arguments.pop_front()
			repeat = 0 if repeat == null else int(repeat) 
			threads = 1 if threads == null else int(threads)
			if test.all.empty():
				push_warning("No Tests Found")
				OS.set_exit_code(1)
				get_tree().quit()
				return
			_run(test.all, repeat, threads)
		RUN_DIRECTORY:
			var dir: String = arguments.pop_front()
			var repeat = arguments.pop_front()
			var threads = arguments.pop_front()
			repeat = 0 if repeat == null else int(repeat) 
			threads = 1 if threads == null else int(threads)
			if test[dir].empty():
				push_warning("No Tests Found")
				OS.set_exit_code(1)
				get_tree().quit()
				return
			_run(test[dir], repeat, threads)
		RUN_SCRIPT:
			var script: String = arguments.pop_front()
			var repeat = arguments.pop_front()
			var threads = arguments.pop_front()
			repeat = 0 if repeat == null else int(repeat) 
			threads = 1 if threads == null else int(threads)
			if not test.script.has(script):
				push_warning("No Tests Found")
				OS.set_exit_code(1)
				get_tree().quit()
				return
			_run([test.scripts[script]], repeat, threads)
		RUN_TAG:
			var tag: String = arguments.pop_front()
			var repeat = arguments.pop_front()
			var threads = arguments.pop_front()
			repeat = 0 if repeat == null else int(repeat) 
			threads = 1 if threads == null else int(threads)
			var t = []
			for container in test.all:
				if container["tags"].has(tag):
					t.append(container)
			if t.empty():
				push_warning("No Tests Found")
				OS.set_exit_code(1)
				get_tree().quit()
				return
			_run(t, repeat, threads)
		RUN_METHOD:
			var script: String = arguments.pop_front()
			var method: String = arguments.pop_front()
			var repeat = arguments.pop_front()
			var threads = arguments.pop_front()
			repeat = 0 if repeat == null else int(repeat) 
			threads = 1 if threads == null else int(threads)
			if not test.scripts.has(script):
				push_warning("No Tests Found")
				OS.set_exit_code(1)
				get_tree().quit()
				return
			var container = test.scripts[script].duplicate()
			container["method"] = method
			_run([container], repeat, threads)
		RUN_FAILURES:
			var toRun = []
			for container in test.all:
				print(container)
				if container.has("passing") and not container["passing"]:
					toRun.append(container)
			if toRun.empty():
				push_warning("No Tests Found")
				OS.set_exit_code(1)
				get_tree().quit()
				return
			var repeat = arguments.pop_front()
			var threads = arguments.pop_front()
			repeat = 0 if repeat == null else int(repeat) 
			threads = 1 if threads == null else int(threads)
			_run(toRun, repeat, threads)
		LIST_ALL:
			print(test.scripts.keys())
			get_tree().quit()
		LIST_DIR:
			var dirlist: Array = []
			for container in test[arguments.pop_front()]:
				dirlist.append(container.path)
			print(dirlist)
			get_tree().quit()
		_:
			push_error("Invalid Argument")
			get_tree().quit()
			
func test_directory() -> String:
	return ProjectSettings.get_setting("WAT/Test_Directory")
	
func set_last_run_success(results) -> void:
	for result in results:
		test.scripts[result["path"]]["passing"] = result.success
	load("res://addons/WAT/editor/test_gatherer.gd").new().save(test)

func _run(tests: Array, repeats: int = 0, threads: int = 0) -> void:
	var toRun = repeat(tests, repeats)
	_runner = TestRunner.new(toRun, threads)
	_runner.connect("run_completed", self, "_on_run_completed")
	_start_time = OS.get_ticks_msec()
	add_child(_runner)
	
func repeat(tests: Array, repeat: int) -> Array:
	var duplicates: Array = []
	for idx in repeat:
		for test in tests:
			duplicates.append(test)
	duplicates += tests
	return duplicates

func _on_run_completed(caselist: Array) -> void:
	_runner.queue_free()
	var cases = {passed = 0, total = 0, crashed = 0}
	for case in caselist:
		cases.total += 1
		if case.success:
			cases.passed += 1
		else:
			display_failures(case)
	display_summary(cases)
	load("res://addons/WAT/editor/junit_xml.gd").write(caselist, cases.seconds)
	set_last_run_success(caselist)
	set_exit_code(cases)
	get_tree().quit()

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
	print("""
	-------RESULTS-------
	Took {seconds} seconds
	{crashed} Tests Crashed
	{passed} / {total} Tests Passed
	-------RESULTS-------
	""".format(cases).dedent())
	
func set_exit_code(cases: Dictionary) -> void:
	OS.exit_code = PASSED if cases.total > 0 and cases.total == cases.passed and cases.crashed == 0 else FAILED
