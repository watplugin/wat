extends Node

const JUnitXML: GDScript = preload("res://addons/WAT/io/junit_xml.gd")
const Metadata: GDScript = preload("res://addons/WAT/io/metadata.gd")
const FileSystem: GDScript = preload("res://addons/WAT/filesystem/filesystem.gd")
const TestRunner: GDScript = preload("res://addons/WAT/runner/TestRunner.gd")
var _filesystem: FileSystem
var _run: Dictionary = {}
var _time_taken: float = 0.0
var _runner

func _ready() -> void:
	_load_tests()
	_run = {}
	var arguments: Array = Array(OS.get_cmdline_args())
	arguments = arguments.slice(1, arguments.size())
	var run: Dictionary = {}
	for arg in arguments:
		var split = arg.split("=")
		_run[split[0]] = split[1]
	_parse()
	
func _load_tests() -> void:
	_filesystem = FileSystem.new()
	Metadata.load_metadata(_filesystem)
	_filesystem.update()
	
enum RUN_ALL {
	NOT_RUN_ALL
	NORMAL_RUN_ALL
	DEBUG_RUN_ALL
}

func _parse() -> void:
	OS.set_environment("WAT_RUN_ALL_MODE", RUN_ALL.NOT_RUN_ALL as String)
	var split: Array = _run["run"].split("+")
	match split[0]:
		"all":
			# run=all
			# Stacks are empty in non-debug builds
			var run_mode = RUN_ALL.NORMAL_RUN_ALL if get_stack().empty() else RUN_ALL.DEBUG_RUN_ALL
			OS.set_environment("WAT_RUN_ALL_MODE", run_mode as String)
			run(_filesystem.root)
		"dir":
			# run=dir+dirpath
			run(_filesystem.index[split[1]])
		"script":
			# run=script+scriptpath
			run(_filesystem.index[split[1]])
		"method":
			# run=method+scriptpath+methodname
			run(_filesystem.index[split[1] + split[2]])
		"failed":
			# run=failed
			run(_filesystem.failed)
		"tag":
			# run=tag+tagname
			_filesystem.tagged.set_tests(split[1], _filesystem.root)
			run(_filesystem.tagged)
		_:
			_quit()
	
func run(data: Reference) -> void:
	var repeats: int = _repeats()
	var threads: int = _threads()
	
	var tests: Array = data.get_tests()
	if tests.empty():
		push_warning("WAT: No tests found")
		OS.exit_code = 1
		_quit()
	
	_runner = TestRunner.new()
	add_child(_runner)
	var x = load("res://addons/WAT/ui/results/tab_container.gd").new()
	var results: Array = yield(_runner.run(tests, _repeats(), _threads()), "completed")
	_runner.queue_free()
	
	var cases = {passed = 0, total = 0, failed = 0, passed_methods = 0, failed_methods = 0, total_methods = 0}
	var failed = []
	for case in results:
		cases.total += 1
		cases.total_methods += case.methods.size()
		if case.success:
			cases.passed += 1
			cases.passed_methods += case.methods.size() # all methods are passed
		else:
			cases.failed += 1
			for method in case.methods:
				if method.success:
					cases.passed_methods += 1
				else:
					cases.failed_methods += 1
			failed.append(case)
	_display(cases)
	var r_count = 1
	print("Details:")
	for result in failed:
		_display_failures(result, r_count)
		r_count += 1
	print("\n-------RESULTS-------\n")
	_filesystem.failed.update(results)
	OS.exit_code = not int(cases.total > 0 and cases.total == cases.passed)
	
	Metadata.save_metadata(_filesystem)
	JUnitXML.write(results, _filesystem.Settings, _time_taken)
	#cases.clear()
	#results.clear()
	_quit()

func _repeats() -> int:
	# r=X where X is a number
	if _run.has("r"):
		return _run["r"] as int
	# r=X where X is a number
	elif _run.has("repeat"):
		return _run.has("repeat") as int
	else:
		return 0
		
func _threads() -> int:
	var threads: int = 0
	# t=X where X is a number
	if _run.has("t"):
		threads = _run["t"] as int
	# thread=X where X is a number
	elif _run.has("thread"):
		threads = _run.has("thread") as int
	else:
		return 1
	if threads > OS.get_processor_count():
		threads = OS.get_processor_count() - 1
	return threads
	

func _display(cases: Dictionary) -> void:
	cases.seconds = stepify(OS.get_ticks_msec() / 1000.0, 0.001)
	_time_taken = cases.seconds
	print("""
	-------RESULTS-------
	
	Took {seconds} second(s)
	
	Test Scripts:
	
	{passed} / {total} Passed
	{failed} / {total} Failed
	
	Tests:
		
	{passed_methods} / {total_methods} Passed
	{failed_methods} / {total_methods} Failed
		
	""".format(cases).dedent())

func _display_failures(case, count = 0) -> void:
	# We could create this somewhere else?
	#print("%s (%s)" % [case.context, case.path])
	print("\n%s. FAILED TEST SCRIPT: %s" % [count, case.path])
	var m_count = 1
	match case.total:
		-1:
			print("\n  Parse Error (check syntax or broken dependencies)")
		0:
			print("\n  No Test Methods Defined")
		_:
			for method in case.methods:
				if not method.success:
					print("    %s. FAILED TEST: %s" % [m_count, method.context])
					#print("\n  %s" % method.context)
					var assert_count = 1
					for assertion in method.assertions:
						if not assertion.success:
							print("\t%s. FAILED ASSERTION: %s " % [assert_count, assertion.context])
							print("\t\tEXPECT: %s" % assertion.expected)
							print("\t\tRESULT: %s" % assertion.actual)
							if not assertion.stack.empty():
								print("\t\tScript Line: %s" % assertion.stack["line"])
							assert_count += 1
					m_count += 1

func _quit() -> void:
	_filesystem.clear()
	get_tree().quit()
