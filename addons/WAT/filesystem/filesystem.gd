extends Reference

const Settings: GDScript = preload("res://addons/WAT/settings.gd")
const YieldCalculator: GDScript = preload("yield_calculator.gd")
const Validator: GDScript = preload("validator.gd")
const DO_NOT_SEARCH_PARENT_DIRECTORIES: bool = true
var root: TestDirectory
var tagged: TaggedTests
var changed: bool = false setget _set_filesystem_changed
var built: bool = false # CSharpScript
var build_function: FuncRef


func _init(_build_function = null) -> void:
	build_function = _build_function
	tagged = TaggedTests.new(Settings)

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
			
		elif dir.file_exists(absolute) and Validator.is_valid_test(absolute):
			var test_script: TestScript = _get_test_script(absolute)
			testdir.tests.append(test_script)
			test_script.dir = testdir.path
			
		relative = dir.get_next()
		
	dir.list_dir_end()
	
	# Range is expensive so we're doing it old-school
	# NOTE - They're all empty?
	
	testdir.relative_subdirs += subdirs
	testdir.nested_subdirs += subdirs
	for subdir in subdirs:
		update(subdir)
		testdir.nested_subdirs += subdir.nested_subdirs
		
func _get_root() -> TestDirectory:
	root = TestDirectory.new()
	root.path = load("res://addons/WAT/settings.gd").test_directory()
	root.is_root = true
	return root
		
func _get_test_script(p: String) -> TestScript:
	var test_script: TestScript = TestScript.new()
	test_script.path = p
	test_script.names = load(p).new().get_test_methods()
	for m in test_script.names:
		var test_method: TestMethod = TestMethod.new()
		test_method.path = p
		test_method.name = m
		test_script.methods.append(test_method)
	if p.ends_with(".gd") or p.ends_with(".gdc"):
		test_script.time = YieldCalculator.calculate_yield_time(load(p), test_script.names.size())
	return test_script
	
# Include sanitized dir names here?
class TestDirectory:
	var is_root: bool = false
	var name: String setget ,_get_sanitized_name
	var path: String
	var relative_subdirs: Array
	var nested_subdirs: Array
	var tests: Array = []
	
	func _get_sanitized_name() -> String:
		# Required for interface compability
		return path
	
	func get_tests() -> Array:
		var requested: Array = []
		if is_root:
			for subdir in nested_subdirs:
				requested += subdir.get_tests()
		else:
			for script in tests:
				requested += script.get_tests()
		return requested
		
	func is_empty() -> bool:
		return tests.empty()
		
class TestScript:
	var name: String setget ,_get_sanitized_name
	var dir: String
	var path: String setget ,_get_path
	var methods: Array # TestMethods
	var names: Array # MethodNames
	var time: float = 0.0 # YieldTime
	
	func _get_sanitized_name() -> String:
		var n: String = path.substr(path.find_last("/") + 1)
		n = n.replace(".gd", "").replace(".gdc", "").replace(".cs", "")
		n = n.replace(".test", "").replace("test", "").replace("_", " ")
		n[0] = n[0].to_upper()
		return n
		
	func _get_path() -> String:
		# Happens when dealing with tests directly in godot
		return path.replace("///", "//") # 
	
	func get_tests() -> Array:
		return [{"dir": dir, "name": self.name, "path": path, "methods": names, "time": time}]
		
class TestMethod:
	var path: String
	var dir: String
	var name: String setget ,_get_sanitized_name
	
	# Method Name != test name
	func get_tests() -> Array:
		return [{"dir": dir, "name": name, "path": path, "methods": [name], "time": 0.0}]
		
	func _get_sanitized_name() -> String:
		var n: String = name.replace("test_", "").replace("_", " ")
		return n
		
class TaggedTests:
	# Tag / Resource Path
	var tagged: Dictionary = {}
	var _settings: GDScript
	
	func _init(settings: GDScript) -> void:
		_settings = settings
		update()
	
	func tag(tag: String, path: String) -> void:
		update()
		if not tagged[tag].has(path):
			tagged[tag].append(path)
		
	func untag(tag: String, path: String) -> void:
		update()
		if tagged[tagged].has(path):
			tagged[tag].erase(path)
			
	func is_tagged(tag: String, path: String) -> bool:
		update()
		return tagged[tag].has(path)
		
	func swap(old: String, new: String) -> void:
		for tag in tagged:
			if tagged[tag].has(old):
				tagged[tag].erase(old)
				tagged[tag].append(new)
		
	func update() -> void:
		for tag in Settings.tags():
			if not tagged.has(tag):
				tagged[tag] = []
		
	func get_tests(tag: String) -> void:
		pass


#const Settings: Script = preload("res://addons/WAT/settings.gd")
#const YieldCalculator: GDScript = preload("res://addons/WAT/filesystem/yield_calculator.gd")
#const FileObjects: GDScript = preload("res://addons/WAT/filesystem/objects.gd")
#const TestDirectory: GDScript = FileObjects.TestDirectory
#const TestScript: GDScript = FileObjects.TestScript
#const TestMethod: GDScript = FileObjects.TestMethod
#const TestTag: GDScript = FileObjects.TestTag
#const TestFailures: GDScript = FileObjects.TestFailures
#var has_been_changed: bool = false
#var resource
#
#var dirs: Array = []
#var _all_tests: Array = []
#var _tag_metadata: Dictionary = {} # resource path, script,
#var tags: Dictionary = {} 
#var failed
#var indexed: Dictionary = {}
#
#func get_tests() -> Array:
#	return _all_tests
#
#func set_failed(results: Array) -> void:
#	# TODO: Cache for better performance
#	failed.tests.clear()
#	for result in results:
#		if not result.success:
#			for test in _all_tests:
#				if test.path == result.path:
#					print(test)
#					failed.tests.append(test)
#					resource.scripts[test.path] = {"failed": true, "tags": test.tags}
#
#func initialize() -> void:
#	resource = load(ProjectSettings.get_setting("WAT/Test_Metadata_Directory") + "/test_metadata.tres")
#	failed = TestFailures.new()
#	indexed["failed"] = failed
#	# add failures from resource script
#	update()
#
#	# Initialize old failures
#	for test in _all_tests:
#		if resource.scripts.has(test.path) and resource.scripts[test.path]["failed"]:
#			failed.tests.append(test)
#
#func _initialize_tags() -> void:
#	for tag in Settings.tags():
#		indexed[tag] = TestTag.new(tag)
#
#func update() -> void:
#	dirs.clear()
#	_all_tests.clear()
#	indexed.clear()
#	_initialize_tags()
#	var absolute_path = Settings.test_directory()
#	var primary = TestDirectory.new(absolute_path)
#	indexed["all"] = self
#	indexed[absolute_path] = primary
#	dirs.append(primary)
#	_update(primary)
#	has_been_changed = true
#
#func _update(testdir: TestDirectory) -> void:
#	var dir: Directory = Directory.new()
#	if dir.open(testdir["path"]) != OK:
#		push_warning("WAT: Could not update filesystem")
#		return
#
#	# Should this be a different function?
#	var subdirs: Array = []
#	dir.list_dir_begin(DO_NOT_SEARCH_PARENT_DIRECTORIES)
#	var relative_path: String = dir.get_next()
#	while relative_path != "":
#		var absolute_path: String = "%s/%s" % [testdir.path, relative_path]
#		if dir.dir_exists(absolute_path):
#			var directory = TestDirectory.new(absolute_path)
#			subdirs.append(directory)
#			indexed[absolute_path] = directory
#
#		elif Validator.is_valid_test(absolute_path):
#			var test: TestScript = _get_test_script(testdir.path, absolute_path)
#			indexed[absolute_path] = test
#			for tag in test.tags:
#				if tag in Settings.tags():
#					indexed[tag].tests.append(test)
#				else:
#					# Push an add check here to auto-add it?
#					push_warning("Tag %s does not exist in WAT Settings")
#
#			for method in test.methods:
#				indexed[absolute_path+method.name] = method
#			if not test.methods.empty():
#				testdir.tests.append(test)
#				_all_tests += test.get_tests()
#
#			# We load our saved tags
#			# We check if our saved tags exist
#			# If they don't, we don't add them
#			# If they do, we do add them
#			# However we do not delete old tags, we just hide them..
#			# ..so that when a tag is re-added, the old tests pop up again
#
#		relative_path = dir.get_next()
#	dir.list_dir_end()
#
#	dirs += subdirs
#	for subdir in subdirs:
#		_update(subdir)
#
#
#func _get_test_script(dir: String, path: String) -> TestScript:
#	var gdscript: Script = load(path)
#	var test: TestScript = TestScript.new(dir, path, load(path))
#	if _tag_metadata.has(test.gdscript.resource_path):
#		test.tags = _tag_metadata[test.gdscript.resource_path]
#
#	# Check if it had failed
#	var failed = false if not resource.scripts.has(path) else resource.scripts[path]["failed"] 
#	# get tags from resource
#	if resource.scripts.has(path):
#		for tag in resource.scripts[path]["tags"]:
#			if not tag in test.tags:
#				test.tags.append(tag)
#		resource.scripts[path] = {"failed": failed, "tags": test.tags}
#	else:
#		resource.scripts[path] = {"failed": false, "tags": test.tags}
#
#	var methods = test.gdscript.new().get_test_methods()
#	for m in methods:
#		test.method_names.append(m)
#		test.methods.append(TestMethod.new(dir, test.path, test.gdscript, m))
#	test.yield_time = YieldCalculator.calculate_yield_time(test.gdscript, test.method_names.size())
#	return test
#
#func add_test_to_tag(test, tag: String) -> void:
#	indexed[tag].tests.append(test)
#
#func remove_test_from_tag(test, tag: String) -> void:
#	indexed[tag].tests.erase(test)
#
#func _on_file_moved(source: String, destination: String) -> void:
#	if(source.ends_with(".sln") or source.ends_with(".csproj") or ".mono" in source or ".import" in source):
#		return
#	if(destination.ends_with(".sln") or destination.ends_with(".csproj") or ".mono" in destination or ".import" in destination):
#		return
#	var key: String = source.rstrip("/")
#	var tags: Array = _tag_metadata.get(key, [])
#	var dest: Resource = load(destination)
#	if _is_in_test_directory(source) or _is_in_test_directory(destination):
#		# Swapping Tags
#		_tag_metadata[dest.resource_path] = tags
#		_tag_metadata.erase(key)
#		has_been_changed = true
#
#func _on_resource_saved(resource: Resource) -> void:
#	if("res://addons/WAT/" in resource.resource_path):
#		return
#	if _is_in_test_directory(resource.resource_path):
#		has_been_changed = true
#
#func _is_in_test_directory(path: String) -> bool:
#	return path.begins_with(Settings.test_directory())
#
#func _on_filesystem_changed(source: String, destination: String = "") -> void:
#	for path in [source, destination]:
#		if _is_in_test_directory(path):
#			has_been_changed = true
