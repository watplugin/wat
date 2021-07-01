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
	var filesystem = FileSystem.new()
	var runner = TestRunner.new()
	add_child(runner)
	var results = yield(runner.run(filesystem.get_tests(), 1), "completed")
	runner.queue_free()
	
	var cases = {passed = 0, total = 0, crashed = 0}
	for case in results:
		cases.total += 1
		if case.success:
			cases.passed += 1
		else:
			_display_failures(cases)
	_display(cases)
	filesystem.set_failed(results)
	OS.exit_code = int(cases.total > 0 and cases.total == cases.passed)
	get_tree().quit()
	
func _run() -> void:
	pass
	
func _display(cases: Dictionary) -> void:
	cases.seconds = OS.get_ticks_msec() / 1000
	print("""
	-------RESULTS-------
	Took {seconds} seconds
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
