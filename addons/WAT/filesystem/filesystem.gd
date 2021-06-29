extends Reference

const DO_NOT_SEARCH_PARENT_DIRECTORIES: bool = true
const Settings: Script = preload("res://addons/WAT/settings.gd")
const YieldCalculator: GDScript = preload("res://addons/WAT/filesystem/yield_calculator.gd")
const FileObjects: GDScript = preload("res://addons/WAT/filesystem/objects.gd")
const TestDirectory: GDScript = FileObjects.TestDirectory
const TestScript: GDScript = FileObjects.TestScript
const TestMethod: GDScript = FileObjects.TestMethod
const TestTag: GDScript = FileObjects.TestTag
const TestFailures: GDScript = FileObjects.TestFailures
var has_been_changed: bool = false
var primary: TestDirectory
var dirs: Array = []
var _all_tests: Array = []
var _tag_metadata: Dictionary = {} # resource path, script,
var tags: Dictionary = {} 
var failed

func get_tests() -> Array:
	return _all_tests
	
func set_failed(results: Array) -> void:
	# TODO: Cache for better performance
	failed.tests = []
	for result in results:
		if not result.success:
			for test in _all_tests:
				if test.path == result.path:
					failed.tests.append(test)
			

func _init() -> void:
	failed = TestFailures.new()
	update()

	
func _initialize_tags() -> void:
	for tag in Settings.tags():
		tags[tag] = TestTag.new(tag)

func update() -> void:
	tags.clear()
	dirs.clear()
	_all_tests.clear()
	
	_initialize_tags()
	primary = TestDirectory.new(Settings.test_directory())
	dirs.append(primary)
	_update(primary)
	has_been_changed = true

func _update(testdir: TestDirectory) -> void:
	var dir: Directory = Directory.new()
	if dir.open(testdir.path) != OK:
		push_warning("WAT: Could not update filesystem")
		return
	
	# Should this be a different function?
	var subdirs: Array = []
	dir.list_dir_begin(DO_NOT_SEARCH_PARENT_DIRECTORIES)
	var relative_path: String = dir.get_next()
	while relative_path != "":
		var absolute_path: String = "%s/%s" % [testdir.path, relative_path]
		if dir.dir_exists(absolute_path):
			subdirs.append(TestDirectory.new(absolute_path))
		
		elif callv("_is_valid_test", [absolute_path, "res://addons/WAT/test/test.gd", ".gd"]) or callv("_is_valid_test", [absolute_path, "res://addons/WAT/mono/Test.cs", ".cs"]):
			var test: TestScript = _get_test_script(testdir.path, absolute_path)
			
			for tag in test.tags:
				if tag in Settings.tags():
					tags[tag].tests.append(test)
				else:
					push_warning("Tag %s does not exist in WAT Settings")
					# Push an add check here to auto-add it?
					
			if not test.methods.empty():
				testdir.tests.append(test)
				_all_tests += test.get_tests()

		relative_path = dir.get_next()
	dir.list_dir_end()
	
	dirs.append_array(subdirs)
	for subdir in subdirs:
		_update(subdir)
			
func _is_valid_test(p: String, base: String, extension: String) -> bool:
	return p.ends_with(extension) and p != base and load(p).call("_is_wat_test")
	
func _get_test_script(dir: String, path: String) -> TestScript:
	var gdscript: Script = load(path)
	var test: TestScript = TestScript.new(dir, path)
	if _tag_metadata.has(gdscript.resource_path):
		test.tags = _tag_metadata[gdscript.resource_path]
		
	for method in gdscript.new().get_test_methods():
		test.method_names.append(method)
		test.methods.append(TestMethod.new(dir, test.path, method))
		test.yield_time = YieldCalculator.calculate_yield_time(gdscript, test.method_names.size())
	return test
	
func add_test_to_tag(test: TestScript, tag: String) -> void:
	tags[tag].tests.append(test)
	
func remove_test_from_tag(test: TestScript, tag: String) -> void:
	tags[tag].tests.erase(test)
	
func _on_file_moved(source: String, destination: String) -> void:
	var key: String = source.rstrip("/")
	var tags: Array = _tag_metadata[key]
	var dest: Resource = load(destination)
	if _is_in_test_directory(source) or _is_in_test_directory(destination):
		# Swapping Tags
		_tag_metadata[dest.resource_path] = tags
		_tag_metadata.erase(key)
		has_been_changed = true
	
func _on_resource_saved(resource: Resource) -> void:
	if _is_in_test_directory(resource.resource_path):
		has_been_changed = true
		
func _is_in_test_directory(path: String) -> bool:
	return path.begins_with(Settings.test_directory())
	
func _on_filesystem_changed(source: String, destination: String = "") -> void:
	for path in [source, destination]:
		if _is_in_test_directory(path):
			has_been_changed = true
	
# get_failures()
# get_metadata()
