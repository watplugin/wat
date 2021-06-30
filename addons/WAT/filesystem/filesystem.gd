extends Reference

const DO_NOT_SEARCH_PARENT_DIRECTORIES: bool = true
const Settings: Script = preload("res://addons/WAT/settings.gd")
const YieldCalculator: GDScript = preload("res://addons/WAT/filesystem/yield_calculator.gd")
const FileObjects: GDScript = preload("res://addons/WAT/filesystem/objects.gd")
const TestTag: GDScript = FileObjects.TestTag
const TestFailures: GDScript = FileObjects.TestFailures
var has_been_changed: bool = false
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
	var absolute_path = Settings.test_directory()
	var primary = {"name": absolute_path, "path": absolute_path, "tests": []}
	dirs.append(primary)
	_update(primary)
	has_been_changed = true

func _update(testdir: Dictionary) -> void:
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
			var directory: Dictionary = {}
			directory["path"] = absolute_path
			directory["name"] = absolute_path
			directory["tests"] = []
			subdirs.append(directory)
		
		elif _is_valid_test(absolute_path):
			var instance: Script = load(absolute_path)
			var script: Dictionary = {}
			script["directory"] = testdir["path"]
			script["path"] = absolute_path
			script["name"] = absolute_path
			script["method_names"] = instance.new().get_test_methods()
			script["methods"] = [] # We'll add a new loop for this
			script["tags"] = _tag_metadata.get(instance.resource_path, [])
			script["yield_time"] = YieldCalculator.calculate_yield_time(instance, script["method_names"].size())
			script["tests"] = [script]
			
			# We load our saved tags
			# We check if our saved tags exist
			# If they don't, we don't add them
			# If they do, we do add them
			# However we do not delete old tags, we just hide them..
			# ..so that when a tag is re-added, the old tests pop up again
			
			#for tag in test.tags:
#				if tag in Settings.tags(): # Seems this may be unnecessary if we just initialize them first
#					tags[tag].tests.append(test)
#				else:
#					push_warning("Tag %s does not exist in WAT Settings")
#					# Push an add check here to auto-add it?
			
			for name in script["method_names"]:
				var method: Dictionary = {}
				method["directory"] = testdir["path"]
				method["path"] = absolute_path
				method["name"] = name
				method["method_names"] = [name]
				method["yield_time"] = 0
				method["tests"] = [method]
				script["methods"].append(method)
				
			if not script["method_names"].empty():
				testdir["tests"].append(script)
				_all_tests.append(script)

		relative_path = dir.get_next()
	dir.list_dir_end()
	
	dirs.append_array(subdirs)
	for subdir in subdirs:
		_update(subdir)
			
func _is_valid_test(p: String) -> bool:
	return (( p.ends_with(".gd") and p != "res://addons/WAT/test/test.gd" or
		  p.ends_with(".cs") and p != "res://addons/WAT/mono/Test.cs" or
		  p.ends_with(".gdc") and p != "res://addons/WAT/test/test.gdc") and
		  load(p).call("_is_wat_test"))
	
func add_test_to_tag(test, tag: String) -> void:
	tags[tag].tests.append(test)
	
func remove_test_from_tag(test, tag: String) -> void:
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
