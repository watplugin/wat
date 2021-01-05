extends Reference
tool

const Settings: Script = preload("settings.gd")

static func cache():
	_create_cache()
	return load(_cache_path())
	
static func display():
	var f = File.new()
	f.open(_cache_path(), File.READ)
	var c = f.get_as_text()
	print(c)
	f.close()
	
static func metadata():
	_create_metadata()
	return load(_metadata_path())
	
static func results():
	_create_results()
	return load(_result_path())
	
static func save_cache(cache: Resource) -> void:
	if _is_standalone():
		return
	_create_cache()
	ResourceSaver.save(_cache_path(), cache())
	
static func save_metadata(metadata: Resource) -> void:
	if _is_standalone():
		return
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
#	if OS.has_feature("standalone"):
#		return OS.get_user_data_dir() + "/.test" + "/metadata.tres"
	return Settings.test_directory() + "/.test" + "/metadata.tres"
	
static func _cache_path():
	return Settings.test_directory() + "/.test" + "/cache.tres"
	
static func _result_path():
	if _is_standalone():
		return OS.get_user_data_dir() + "/.test" + "/results.tres"
	else:
		return Settings.test_directory() + "/.test" + "/results.tres"
	
static func _xml_path():
	return Settings.test_directory() + "/.test" + "/results.xml"
	
#static func results() -> Resource:
#	# Lazy Initialization
#	# Add toggle for compiled/exported vs non-compiled/exported
#	# Make seperate ResourceManager scripts?
#	var savepath = _res
#	if not ResourceLoader.exists(path):
#		Directory.new().make_dir(Settings.test_directory() + "/.test")
#		var instance = load("res://addons/WAT/resources/results.gd").new()
#		ResourceSaver.save(path, instance)
#	return ResourceLoader.load(path, "", true)

static func _set_datapath():
	if _is_standalone():
		Directory.new().make_dir(OS.get_user_data_dir() + "/.test")
	else:
		Directory.new().make_dir(Settings.test_directory())
		Directory.new().make_dir(Settings.test_directory() + "/.test")

	
static func _is_standalone() -> bool:
	return OS.has_feature("standalone")
