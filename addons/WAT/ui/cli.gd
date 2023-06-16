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
	#arguments = arguments.slice(1, arguments.size())
	print(arguments)
	var threads: int = get_thread_count(arguments)
	var repeat: int = get_repeat_count(arguments)
	get_run(arguments, repeat, threads)

	
func get_run(args: Array, repeat: int = 0, threads: int = 0):
	OS.set_environment("WAT_RUN_ALL_MODE", "-1")
	for idx in args.size() - 1:
		if args[idx] == "run":
			match args[idx + 1]:
				"all":
					var run_mode = RUN_ALL.NORMAL_RUN_ALL if get_stack().empty() else RUN_ALL.DEBUG_RUN_ALL
					OS.set_environment("WAT_RUN_ALL_MODE", run_mode as String)
					run(_filesystem.root, repeat, threads)
				"dir":
					run(_filesystem.index[args[idx + 2]], repeat, threads)
				"script":
					run(_filesystem.index[args[idx + 2]], repeat, threads)
				"method":
					run(_filesystem.index[args[idx + 2] + args[idx + 3]], repeat, threads)
				"tag":
					_filesystem.tagged.set_tests(args[idx + 2], _filesystem.root)
					run(_filesystem.tagged, repeat, threads)
				"failed":
					# Works fine
					run(_filesystem.failed, repeat, threads)
				_:
					_quit()
					

func get_thread_count(args: Array) -> int:
	for idx in args.size() - 1:
		if args[idx] == '-td' or args[idx] == '--thread':
			return int(args[idx + 1])
	return 1
	
func get_repeat_count(args: Array) -> int:
	for idx in args.size() - 1:
		if args[idx] == '-r' or args[idx] == '--repeat':
			return int(args[idx + 1])
	return 0
	
func _load_tests() -> void:
	_filesystem = FileSystem.new()
	Metadata.load_metadata(_filesystem)
	_filesystem.update()
	
enum RUN_ALL {
	NOT_RUN_ALL
	NORMAL_RUN_ALL
	DEBUG_RUN_ALL
}

func run(data: Reference, repeats: int = 0, threads: int = 0) -> void:

	var tests: Array = data.get_tests()
	if tests.empty():
		push_warning("WAT: No tests found")
		OS.exit_code = 1
		_quit()
	
	_runner = TestRunner.new()
	add_child(_runner)
	var results: Array = yield(_runner.run(tests, repeats, threads), "completed")
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
	_quit()


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
