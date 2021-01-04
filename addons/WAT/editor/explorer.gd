extends Node
tool

const BLANK = ""
const DO_NOT_SEARCH_PARENT_DIRECTORIES: bool = true
var _cache
var _metadata

var tests: Dictionary = {}

func _ready() -> void:
	_load_cache()
	var time = OS.get_ticks_msec()
	tests = {directories = [], suitepool = []}
	_define_tags()
	var path: String = ProjectSettings.get_setting("WAT/Test_Directory")
	_search(path)
	tests.directories.erase(path)
	tests = tests
	print("Time Taken: ", OS.get_ticks_msec() - time)
	
func _load_cache() -> void:
	var testdir = WAT.Settings.test_directory()
	var cachedir = testdir + "/.test"
	var cachepath = cachedir + "/cache.tres"
	var metadatapath = cachedir + "/metadata.tres"
	
	if not ResourceLoader.exists(cachepath):
		push_warning("Creating Test Cache at %s" % cachedir)
		var err = Directory.new().make_dir(cachedir)
		if err != OK:
			push_warning(err as String)
		var cacheres = preload("res://addons/WAT/resources/testcache.gd").new()
		ResourceSaver.save(cachepath, cacheres)
	if not ResourceLoader.exists(metadatapath):
		push_warning("Creating Metadata cache at %s" % metadatapath)
		var metadatares = preload("res://addons/WAT/resources/metadata.gd").new()
		ResourceSaver.save(metadatapath, metadatares)
	
	_metadata = load(metadatapath)
	_cache = load(cachepath)
	if _cache == null:
		push_warning("Error loading test cache. Recreating")
		var err = Directory.new().make_dir(cachedir)
		if err != OK:
			push_warning(err as String)
		var newcache = preload("res://addons/WAT/resources/testcache.gd").new()
		ResourceSaver.save(cachepath, newcache)
		_cache = load(cachepath)
	
func _notification(what) -> void:
	if what != NOTIFICATION_WM_QUIT_REQUEST:
		return
	if OS.has_feature("standalone"):
		push_warning("Metadata is not saved in release builds")
		return
	else:
		_save()
		
func _save() -> void:
		_serialize_metadata()
		var testdir = WAT.Settings.test_directory()
		var cachedir = testdir + "/.test"
		var cachepath = cachedir + "/cache.tres"
		var metadatapath = cachedir + "/metadata.tres"
		ResourceSaver.save(cachepath, _cache)
		ResourceSaver.save(metadatapath, _metadata)
		
func _serialize_metadata():
	var metadata = {}
	for test in tests:
		if test.ends_with(".gd"):
			var c = tests[test]
			metadata[test] = {"path": test, "tags": c.tags}
	_metadata.metadata = metadata
	
func _define_tags() -> void:
	for tag in WAT.Settings.tags():
		tests[tag] = []
	
func _search(dirpath: String) -> Array:
	var scripts: Array = []
	var subdirs: Array = []
	var dir = Directory.new()
	var err = dir.open(dirpath)
	if err != OK:
		push_error("%s : %s " % [dirpath, err as String])
	dir.list_dir_begin(DO_NOT_SEARCH_PARENT_DIRECTORIES)
	var current_name = dir.get_next()
	while current_name != BLANK:
		var name = dirpath + "/" + current_name
		
		if _is_test(name):
			scripts.append(_add_test(name))
		elif _is_suite(name):
			scripts += _add_suite(name)
		# Use relative paths, absolute res:// paths are broken in export builds
		elif dir.dir_exists(current_name):
			subdirs.append(name)
		
		current_name = dir.get_next()
	dir.list_dir_end()
	for subdir in subdirs:
		scripts += _search(subdir)
	
	for test in scripts:
		# Used for reverse lookup on removal/move
		test.containers.append(dirpath)
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
	if _metadata.metadata.has(name):
		container.tags = _metadata.metadata[name].tags
	if not _cache.scripts.has(container.test):
		_cache.scripts.append(container.test)
	for tag in container.tags:
		tests[tag].append(container)
	tests[name] = container
	return container
	
func _add_suite(name: String) -> Array:
	var scripts = []
	var suite: Script = load(name)
	tests.suitepool.append(suite)
	if not _cache.scripts.has(suite):
		_cache.scripts.append(suite)
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
			if _metadata.metadata.has(name):
				container.tags = _metadata.metadata[name].tags
				tests[name] = container
			scripts.append(container)
			for tag in container.tags:
				tests[tag].append(container)
			tests[container.path] = container
	return scripts

# Editor Only Functions
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
