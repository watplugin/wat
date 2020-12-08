tool
extends Resource

const CREATE_NEW_COPY: bool = true
const NO_TYPE_HINT: String = ""
const DO_NOT_SEARCH_PARENT_DIRECTORIES: bool = true
export(Dictionary) var scripts = {}
export(Array, String) var directories = []
export(Array, String) var script_paths = []

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
				for test in _load_suite(script):
					scripts[test.get_meta("path")] = test
				pass
				
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
			test.set_meta("path", "%s.%s" % [suite.get_path(), constant])
			tests.append(test)
	return tests
