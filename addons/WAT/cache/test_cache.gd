const BLANK = ""
const DO_NOT_SEARCH_PARENT_DIRECTORIES: bool = true
var _cache = preload("res://addons/WAT/cache/cache.tres")
tool

var tests: Dictionary = {}

func _init() -> void:
	if Engine.is_editor_hint():
		_initialize()
	else:
		tests = _cache.tests

func _initialize() -> void:
	tests = {directories = []}
	var path: String = ProjectSettings.get_setting("WAT/Test_Directory")
	_search(path)
	tests.directories.erase(path)
	_cache.tests = tests
	ResourceSaver.save(_cache.resource_path, _cache)
	
func _search(dirpath: String) -> Array:
	var scripts: Array = []
	var subdirs: Array = []
	var dir = Directory.new()
	dir.open(dirpath)
	dir.list_dir_begin(DO_NOT_SEARCH_PARENT_DIRECTORIES)
	var current_name = dir.get_next()
	while current_name != BLANK:
		var name = dirpath + "/" + current_name
		
		if _is_test(name):
			scripts.append(_add_test(name))
		elif _is_suite(name):
			scripts += _add_suite(name)
		elif dir.dir_exists(name):
			subdirs.append(name)
		
		current_name = dir.get_next()
	dir.list_dir_end()
	
	for subdir in subdirs:
		scripts += _search(subdir)
	
	for test in scripts:
		# Used for reverse lookup on removal/move
		test.containers.append(tests[dirpath])
	tests.directories.append(dirpath)
	tests[dirpath] = scripts
	return scripts

func _is_test(name: String) -> bool:
	if name.ends_with(".gd") or name.ends_with(".gdc"):
		return load(name).get("TEST") != null
	return false
	
func _is_suite(name: String) -> bool:
	if name.ends_with(".gd") or name.ends_with(".gdc"):
		return load(name).get("IS_WAT_SUITE")
	return false
	
func _add_test(name: String) -> Dictionary:
	var container = {path = name, test = load(name), tags = [], method = "", containers = []}
	tests[name] = container
	return container
	
func _add_suite(name: String) -> Array:
	var scripts = []
	var suite: Script = load(name)
	for klass in suite.get_script_constant_map():
		var expr: Expression = Expression.new()
		expr.parse(klass)
		var test = expr.execute([], suite)
		if(test).get("TEST") != null:
			var title = '%s.%s' % [suite.get_path(), klass]
			var copy: GDScript = GDScript.new()
			copy.source_code = 'extends "%s".%s' % [suite.get_path(), klass]
			copy.reload()
			var container = {}
			container.path = "%s.%s" % [suite.get_path(), klass]
			container.test = copy
			container.tags = []
			container.method = ""
			container.containers = []
			scripts.append(container)
			tests[container.path] = container
	return scripts

func _on_files_moved(old: String, new: String) -> void:
	print("moved file %s to %s" % [old, new])
	
func _on_file_removed(removed: String):
	print("removed file ", removed)
	
func _on_folder_moved(old: String, new: String) -> void:
	# Counts for renaming
	print("moved folder %s to %s" % [old, new])
	
func _on_folder_removed(removed: String) -> void:
	# Doesn't inform us about which files were in that folder
	# We'll likely be able to do a remove all that begins with path
	print("removed folder ", removed)
