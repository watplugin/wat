extends Reference

const DO_NOT_SEARCH_PARENT_DIRECTORIES: bool = true
const Settings: Script = preload("res://addons/WAT/settings.gd")
const YieldCalculator: GDScript = preload("res://addons/WAT/filesystem/yield_calculator.gd")
const FileObjects: GDScript = preload("res://addons/WAT/filesystem/objects.gd")
const TestDirectory: GDScript = FileObjects.TestDirectory
const TestScript: GDScript = FileObjects.TestScript
const TestMethod: GDScript = FileObjects.TestMethod
const TestTag: GDScript = FileObjects.TestTag
var has_been_updated: bool = false
var primary: TestDirectory
var dirs: Array = []

func update() -> void:
	dirs.clear()
	primary = TestDirectory.new(Settings.test_directory())
	has_been_updated = true

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
		
		elif _is_valid_test(absolute_path):
			pass
			
		relative_path = dir.get_next()
	dir.list_dir_end()
	
	for subdir in subdirs:
		_update(subdir)
			
func _is_valid_test(p: String) -> bool:
	var base: String = "res://addons/WAT/core/test/test.gd"
	return p.ends_with(".gd") and p != base and load(p).get("TEST")
	
func _get_test_script(path: String) -> TestScript:
	var gdscript: GDScript = load(path)
	var test: TestScript = TestScript.new(path, load(path))
	for method in test.gdscript.get_script_method_list():
		if method.name.begins_with("test"):
			test.method_names.append(method.name)
			test.methods.append(TestMethod.new(test.path, test.gdscript, method.name))
	test.yield_time = YieldCalculator.calculate_yield_time(test.gdscript, test.method_names.size())
	return test
	
# get_failures()
# get_metadata()
