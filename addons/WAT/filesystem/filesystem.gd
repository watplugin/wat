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
var built: bool = false setget ,_get_filesystem_built # CSharpScript
var build_function: FuncRef
var index = {} # Path / Object

# Initialize/Save meta
func _init(_build_function = null) -> void:
	build_function = _build_function
	tagged = TaggedTests.new(Settings)
	failed = FailedTests.new()

func _set_filesystem_changed(has_changed: bool) -> void:
	changed = has_changed
	if has_changed or ClassDB.class_exists("CSharpScript"):
		built = false

func _get_filesystem_built() -> bool:
	# If not Mono, return true because it is irrelevant to GDScript.
	return built or not Engine.is_editor_hint() or not ClassDB.class_exists("CSharpScript")

func _recursive_update(testdir: TestDirectory) -> void:
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
			if test_script:
				testdir.tests.append(test_script)
				test_script.dir = testdir.path
				index[test_script.path] = test_script

		relative = dir.get_next()
		
	dir.list_dir_end()

	testdir.relative_subdirs += subdirs
	testdir.nested_subdirs += subdirs
	for subdir in subdirs:
		_recursive_update(subdir)
		testdir.nested_subdirs += subdir.nested_subdirs

func update(testdir: TestDirectory = _get_root()) -> void:
	_recursive_update(testdir)
	# Set "changed" to false after the update, otherwise it is redundant.
	changed = false
		
func _get_root() -> TestDirectory:
	index = {}
	root = TestDirectory.new()
	root.path = Settings.test_directory()
	root.is_root = true
	return root
		
func _get_test_script(p: String) -> TestScript:
	var script = load(p)
	if not script:
		# If script is null, then it means it wasn't loaded, so exclude it.
		return null
	var test_script: TestScript = TestScript.new()
	# reload() needed because load() still loads broken script, but the error..
	# .. is not in our control, so reload() will help us identify parse errors.
	test_script.parse = script.reload(true)
	test_script.path = p
	if test_script.parse == OK:
		if script.has_method("new"):
			var test: Node = script.new()
			if script.get("IS_WAT_TEST") or test.get("IS_WAT_TEST"):
				test_script.names = test.get_test_methods()
				for m in test_script.names:
					var test_method: TestMethod = TestMethod.new()
					test_method.path = p
					test_method.name = m
					test_script.methods.append(test_method)
					index[test_script.path+m] = test_method
				if p.ends_with(".gd") or p.ends_with(".gdc"):
					test_script.time = YieldCalculator.calculate_yield_time(
							script, test_script.names.size())
			else:
				# If the script has no load errors, yet it doesn't have the..
				# ..IS_WAT_TEST attribute, then it should be excluded.
				test_script = null
			test.free()
		else:
			# The script has no load errors, yet it doesn't have the "new()"..
			# ..method, so it is an invalid object that should be excluded.
			test_script = null
	# Loaded scripts with errors are still included.
	return test_script

func clear() -> void:
	index.clear()
