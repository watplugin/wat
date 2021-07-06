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
var dirs: Array = []
var _all_tests: Array = []
var _tag_metadata: Dictionary = {} # resource path, script,
var tags: Dictionary = {} 
var failed
var indexed: Dictionary = {}

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
		indexed[tag] = TestTag.new(tag)

func update() -> void:
	dirs.clear()
	_all_tests.clear()
	indexed.clear()
	_initialize_tags()
	var absolute_path = Settings.test_directory()
	var primary = TestDirectory.new(absolute_path)
	indexed["all"] = self
	indexed[absolute_path] = primary
	dirs.append(primary)
	_update(primary)
	has_been_changed = true

func _update(testdir: TestDirectory) -> void:
	var dir: Directory = Directory.new()
	if dir.open(testdir["path"]) != OK:
		push_warning("WAT: Could not update filesystem")
		return
	
	# Should this be a different function?
	var subdirs: Array = []
	dir.list_dir_begin(DO_NOT_SEARCH_PARENT_DIRECTORIES)
	var relative_path: String = dir.get_next()
	while relative_path != "":
		var absolute_path: String = "%s/%s" % [testdir.path, relative_path]
		if dir.dir_exists(absolute_path):
			var directory = TestDirectory.new(absolute_path)
			subdirs.append(directory)
			indexed[absolute_path] = directory
		
		elif _is_valid_test(absolute_path):
			var test: TestScript = _get_test_script(testdir.path, absolute_path)
			indexed[absolute_path] = test
			for tag in test.tags:
				if tag in Settings.tags():
					indexed[tag].tests.append(test)
				else:
					# Push an add check here to auto-add it?
					push_warning("Tag %s does not exist in WAT Settings")

			for method in test.methods:
				indexed[absolute_path+method.name] = method
			if not test.methods.empty():
				testdir.tests.append(test)
				_all_tests += test.get_tests()
			
			# We load our saved tags
			# We check if our saved tags exist
			# If they don't, we don't add them
			# If they do, we do add them
			# However we do not delete old tags, we just hide them..
			# ..so that when a tag is re-added, the old tests pop up again

		relative_path = dir.get_next()
	dir.list_dir_end()
	
	dirs += subdirs
	for subdir in subdirs:
		_update(subdir)
			
func _is_valid_test(p: String) -> bool:
	if not (p.ends_with(".gd") or p.ends_with(".cs") or p.ends_with(".gdc")):
		return false
	if (p == "res://addons/WAT/test/test.gd" or p == "res://addons/WAT/test/test.gdc" or p == "res://addons/WAT/mono/Test.cs"):
		return false
	if not (load(p).get("IS_WAT_TEST") or load(p).new().get("IS_WAT_TEST")):
		return false 
	return true
		
func _get_test_script(dir: String, path: String) -> TestScript:
	var gdscript: Script = load(path)
	var test: TestScript = TestScript.new(dir, path, load(path))
	if _tag_metadata.has(test.gdscript.resource_path):
		test.tags = _tag_metadata[test.gdscript.resource_path]
	var methods = test.gdscript.new().get_test_methods()
	for m in methods:
		test.method_names.append(m)
		test.methods.append(TestMethod.new(dir, test.path, test.gdscript, m))
		test.yield_time = YieldCalculator.calculate_yield_time(test.gdscript, test.method_names.size())
	return test
	
func add_test_to_tag(test, tag: String) -> void:
	indexed[tag].tests.append(test)
	
func remove_test_from_tag(test, tag: String) -> void:
	indexed[tag].tests.erase(test)
	
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
