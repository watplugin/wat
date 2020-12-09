tool
extends Resource

const CREATE_NEW_COPY: bool = true
const NO_TYPE_HINT: String = ""
const DO_NOT_SEARCH_PARENT_DIRECTORIES: bool = true
export(Dictionary) var scripts = {}
export(Array, String) var directories = []
export(Array, String) var script_paths = []
var _suite_count: int = 0

func scripts(path: String) -> Array:
	var tests: Array = []
	for test in scripts:
		if test.begins_with(path):
			tests.append(scripts[test])
	return tests
	
func paths(dir: String) -> Array:
	var paths: Array = []
	for path in script_paths:
		if path.begins_with(dir):
			paths.append(path)
	return paths

func directory(path: String) -> Array:
	var tests: Array = []
	for test in scripts:
		if test.begins_with(path):
			tests.append(scripts[test])
	return tests

func refresh() -> void:
	ResourceSaver.save(resource_path, self)
	ResourceLoader.load(resource_path, NO_TYPE_HINT, CREATE_NEW_COPY)

func initialize() -> void:
	# Only to be Run on Plugin Load
	scripts = {}
	directories = []
	script_paths = []
	Directory.new().remove("res://addons/WAT/cache/.nested")
	_suite_count = 0
	var root = ProjectSettings.get_setting("WAT/Test_Directory")
	_search(root)
	ResourceSaver.save(resource_path, self)
	
func _search(root: String):
	var subdirs = []
	var d = Directory.new()
	d.open(root)
	d.list_dir_begin(DO_NOT_SEARCH_PARENT_DIRECTORIES) # do not search parent directories
	var name = d.get_next()
	while name != "":
		var title = root + "/" + name
		
		# load script
		if name.ends_with(".gd"):
			var script = load(title)
			if script.get("TEST") != null:
				script_paths.append(title)
				scripts[title] = script
			elif script.get("IS_WAT_SUITE"):
				_load_suite(script)
#				for test in _load_suite(script):
#					scripts[test.get_meta("path")] = test
#					script_paths.append(test.get_meta("path"))
				
		# add dir
		if d.dir_exists(name):
			subdirs.append(name)
		name = d.get_next()
	d.list_dir_end()
	for dir in subdirs:
		directories.append(root + "/" + dir)
		_search(root + "/" + dir)

func _load_suite(suite: Script):
	var tests: Array = []
	for constant in suite.get_script_constant_map():
		var expr: Expression = Expression.new()
		expr.parse(constant)
		var test = expr.execute([], suite)
		if test.get("TEST") != null:
			var tempCopy = GDScript.new()
			tempCopy.source_code = 'extends "%s".%s' % [suite.get_path(), constant]
			tempCopy.source_code += "\nvar custom_path = '%s.%s'" % [suite.get_path(), constant]
			tempCopy.reload()
			ResourceSaver.save("res://addons/WAT/cache/.nested/%s.gd" % _suite_count as String, tempCopy)
			var loadedCopy = load("res://addons/WAT/cache/.nested/%s.gd" % _suite_count)
			_suite_count += 1
			tests.append(loadedCopy)
			scripts['%s.%s' % [suite.get_path(), constant]] = loadedCopy
			script_paths.append('%s.%s' % [suite.get_path(), constant])
	return tests
