extends Reference
tool

const Settings: Script = preload("settings.gd")

static func cache():
	_create_cache()
	return load(_cache_path())
	
static func metadata():
	_create_metadata()
	return load(_metadata_path())
	
static func results():
	_create_results()
	return load(_result_path())
	
static func save_cache(cache: Resource) -> void:
	_create_cache()
	ResourceSaver.save(_cache_path(), cache())
	
static func save_metadata(metadata: Resource) -> void:
	_create_metadata()
	ResourceSaver.save(_metadata_path(), metadata())
	
static func save_results(results: Resource) -> void:
	_create_results()
	ResourceSaver.save(_result_path(), results)
	
static func save_junit_xml(xml) -> void:
	_set_datapath()
	var XML = File.new()
	XML.open(_xml_path(), File.WRITE)
	XML.store_string(xml)
	XML.close()
	
static func _create_metadata():
	var savepath: String = _metadata_path()
	if ResourceLoader.exists(savepath):
		return
	_set_datapath()
	var res: Resource = load("res://addons/WAT/resources/metadata.gd").new()
	ResourceSaver.save(savepath, res)
	
static func _create_cache():
	var savepath: String = _cache_path()
	if ResourceLoader.exists(savepath):
		return
	_set_datapath()
	var res: Resource = load("res://addons/WAT/resources/testcache.gd").new()
	var err = ResourceSaver.save(savepath, res)
	if err != OK:
		push_warning(err as String)
	
static func _create_results():
	var savepath: String = _result_path()
	if ResourceLoader.exists(savepath):
		return
	_set_datapath()
	var res: Resource = load("res://addons/WAT/resources/results.gd").new()
	var err = ResourceSaver.save(savepath, res)
	if err != OK:
		push_warning(err as String)
	
static func _metadata_path():
	return Settings.test_directory() + "/.test" + "/metadata.tres"
	
static func _cache_path():
	return Settings.test_directory() + "/.test" + "/cache.tres"
	
static func _result_path():
	return Settings.test_directory() + "/.test" + "/results.tres"
	
static func _xml_path():
	return Settings.test_directory() + "/.test" + "/results.xml"

static func _set_datapath():
	Directory.new().make_dir(Settings.test_directory())
	Directory.new().make_dir(Settings.test_directory() + "/.test")
