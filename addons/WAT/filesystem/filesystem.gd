extends Reference

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
			
		elif dir.file_exists(absolute) and Validator.is_valid_test(absolute):
			var test_script: TestScript = _get_test_script(absolute)
			testdir.tests.append(test_script)
			test_script.dir = testdir.path
			
		relative = dir.get_next()
		
	dir.list_dir_end()

	testdir.relative_subdirs += subdirs
	testdir.nested_subdirs += subdirs
	for subdir in subdirs:
		update(subdir)
		testdir.nested_subdirs += subdir.nested_subdirs
		
func _get_root() -> TestDirectory:
	root = TestDirectory.new()
	root.path = Settings.test_directory()
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
	var path: String setget ,_get_path
	var relative_subdirs: Array
	var nested_subdirs: Array
	var tests: Array = []
	
	func _get_sanitized_name() -> String:
		# Required for interface compability
		return path
		
	func _get_path() -> String:
		# res:/// should be res://f
		return path.replace("///", "//") # 
	
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
		# res:/// should be res://
		return path.replace("///", "//") # 
	
	func get_tests() -> Array:
		return [{"dir": dir, "name": self.name, "path": self.path, "methods": names, "time": time}]
		
class TestMethod:
	var path: String
	var dir: String setget ,_get_path
	var name: String setget ,_get_sanitized_name
	
	# Method Name != test name
	func get_tests() -> Array:
		return [{"dir": dir, "name": name, "path": self.path, "methods": [name], "time": 0.0}]
		
	func _get_sanitized_name() -> String:
		var n: String = name.replace("test_", "").replace("_", " ")
		return n
		
	func _get_path() -> String:
		# res:/// should be res://
		return path.replace("///", "//") # 
		
class FailedTests:
	var paths: Array = []
	var _tests: Array = []
	
	func update(results: Array) -> void:
		paths.clear()
		for result in results:
			if not result["success"]:
				paths.append(result["path"])
				
	func set_tests(root: TestDirectory) -> void:
		_tests.clear()
		for test in root.get_tests():
			if paths.has(test["path"]):
				_tests.append(test)
		
	func get_tests() -> Array:
		return _tests
		
class TaggedTests:
	# Tag / Resource Path
	var tagged: Dictionary = {}
	var _settings: GDScript
	var _tests: Array = []
	
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
				
	func set_tests(tag: String, root: TestDirectory) -> void:
		_tests.clear()
		for test in root.get_tests():
			if tagged[tag].has(test["path"]):
				_tests.append(test)
		
	func get_tests() -> Array:
		return _tests


