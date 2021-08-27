extends Reference

const TestDirectory: GDScript = preload("directory.gd")
const TestScript: GDScript = preload("script.gd")
const TestMethod: GDScript = preload("method.gd")
const FailedTests: GDScript = preload("failed.gd")
const TaggedTests: GDScript = preload("tagged.gd")
const Settings: GDScript = preload("res://addons/WAT/settings.gd")
const YieldCalculator: GDScript = preload("yield_calculator.gd")
const Validator: GDScript = preload("validator.gd")
const DO_NOT_SEARCH_PARENT_DIRECTORIES: bool = true
var root: TestDirectory
var tagged: TaggedTests
var failed: FailedTests
var changed: bool = false setget _set_filesystem_changed
var built: bool = false # CSharpScript
var build_function: FuncRef
var index = {} # Path / Object

# Initialize/Save meta

func _init(_build_function = null) -> void:
	build_function = _build_function
	tagged = TaggedTests.new(Settings)
	failed = FailedTests.new()

func _set_filesystem_changed(has_changed: bool) -> void:
	if has_changed:
		changed = true
		built = false

func update(testdir: TestDirectory = _get_root()) -> void:
	var dir: Directory = Directory.new()
	var err: int = dir.open(testdir.path)
	if err != OK:
		push_warning("WAT: Could not update filesystem")
		return
	
	var subdirs: Array = []
	dir.list_dir_begin(DO_NOT_SEARCH_PARENT_DIRECTORIES)
	var absolute: String = ""
	var relative: String = dir.get_next()
	while relative != "":
		absolute = "%s/%s" % [testdir.path, relative]

		# /. deals with most things like .git, .import, .mono etc
		if dir.current_is_dir() and not "/." in absolute and not "/addons" in absolute:
			var sub_testdir: TestDirectory = TestDirectory.new()
			sub_testdir.path = absolute
			subdirs.append(sub_testdir)
			index[sub_testdir.path] = sub_testdir
			pass

		elif dir.file_exists(absolute) and Validator.is_valid_test(absolute):
			var test_script: TestScript = _get_test_script(absolute)
			testdir.tests.append(test_script)
			test_script.dir = testdir.path
			index[test_script.path] = test_script
#
		relative = dir.get_next()
		
	dir.list_dir_end()

	testdir.relative_subdirs += subdirs
	testdir.nested_subdirs += subdirs
	for subdir in subdirs:
		update(subdir)
		testdir.nested_subdirs += subdir.nested_subdirs
		
func _get_root() -> TestDirectory:
	index = {}
	root = TestDirectory.new()
	root.path = Settings.test_directory()
	root.is_root = true
	return root
		
func _get_test_script(p: String) -> TestScript:
	var test: Node = load(p).new()
	var test_script: TestScript = TestScript.new()
	test_script.path = p
	test_script.names = test.get_test_methods()
	for m in test_script.names:
		var test_method: TestMethod = TestMethod.new()
		test_method.path = p
		test_method.name = m
		test_script.methods.append(test_method)
		index[test_script.path+m] = test_method
	if p.ends_with(".gd") or p.ends_with(".gdc"):
		test_script.time = YieldCalculator.calculate_yield_time(load(p), test_script.names.size())
	test.free()
	return test_script
	
func clear() -> void:
	index.clear()
