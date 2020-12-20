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

func initialize() -> void:
	# Only to be Run on Plugin Load
	scripts = {}
	directories = []
	script_paths = []
	Directory.new().remove("res://addons/WAT/cache/.nested")
	_suite_count = 0
	var root = ProjectSettings.get_setting("WAT/Test_Directory")
	_search(root)
	
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
				scripts[title] = {"path": title, "script": script}
			elif script.get("IS_WAT_SUITE"):
				_load_suite(script)
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
			var path = "%s.%s" % [suite.get_path(), constant]
			scripts[path] = {"path": path, "script": loadedCopy}
			script_paths.append(path)
	return tests
	
func _on_files_moved(old: String, new: String) -> void:
	print("moved file %s to %s" % [old, new])
	
func _on_file_removed(removed: String):
	scripts.erase(removed)
	script_paths.remove(removed)
	# Should be on_file_removed
	print("removed file ", removed)
	
func _on_folder_moved(old: String, new: String) -> void:
	# Counts for renaming
	print("moved folder %s to %s" % [old, new])
	
func _on_folder_removed(removed: String) -> void:
	# Doesn't inform us about which files were in that folder
	# We'll likely be able to do a remove all that begins with path
	print("removed folder ", removed)
