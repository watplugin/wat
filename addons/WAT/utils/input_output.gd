extends Reference

const BLANK: Script = preload("res://addons/WAT/double/objects/blank.gd")

static func file_list(main_directory: String = "res://tests/", include_files_in_subdirectories: bool = true) -> Array:
	if not _directory_exists(main_directory):
		OS.alert("Directory: %s does not exist" % main_directory)
		return []
		
	elif main_directory.ends_with(".gd"):
		var filename: String = Array(main_directory.split("/")).back()
		return [{path = main_directory, file = filename}]
		
	var filenames: Array = []
	var directory: Directory = Directory.new()
	directory.open(main_directory)
	directory.list_dir_begin(true)
	var name: String = directory.get_next()
	while name != "":
		if name.ends_with(".gd"):
			filenames.append({path = "%s/%s" %[main_directory, name], "name": name})
		elif directory.current_is_dir() and include_files_in_subdirectories:
			filenames += file_list("%s/%s" % [main_directory, name])
		name = directory.get_next()
	directory.list_dir_end()
	return filenames

static func clear_temporary_files(main_directory: String = "user://WATemp/", delete_subdirectories: bool = true) -> void:
	if not _directory_exists(main_directory):
		return
	var directory: Directory = Directory.new()
	directory.open(main_directory)
	directory.list_dir_begin(true)
	var name: String = directory.get_next()
	while name != "":
		if directory.current_is_dir():
			clear_temporary_files("%s/%s" % [main_directory, name])
		else:
			directory.remove(name)
		name = directory.get_next()
	directory.list_dir_end()

static func _directory_exists(path: String) -> bool:
	return Directory.new().dir_exists(path)

static func load_script(gdscript) -> Script:
	assert(gdscript is Script or (gdscript is String and gdscript.ends_with(".gd")))
	return gdscript if gdscript is Script else load(gdscript)

static func load_scene_instance(tscn) -> Node:
	assert(tscn is PackedScene or (tscn is String and tscn.ends_with(".tscn")))
	return tscn.instance() if tscn is PackedScene else load(tscn).instance()

static func save_script(title: String, rewrite: String) -> String:
	var save_path: String = _save_path(title)
	BLANK.source_code = rewrite
	ResourceSaver.save(save_path, BLANK)
	return save_path

static func save_scene(title: String, scene: Node) -> String:
	var save_path: String = _save_path(title)
	var double = PackedScene.new()
	double.pack(scene)
	ResourceSaver.save(save_path, double)
	return save_path

static func _save_path(title: String) -> String:
	_create_directory_if_it_does_not_exist("user://WATemp")
	return "user://WATemp/%s_%s.gd" % [title, file_list("user://WATemp").size()]

static func _create_directory_if_it_does_not_exist(path: String) -> void:
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)