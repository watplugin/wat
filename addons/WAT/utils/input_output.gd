extends Reference

const BLANK: Script = preload("res://addons/WAT/double/objects/blank.gd")

enum { DIRECTORY, FILE }

static func file_list(path: String = "res://tests", searching_for: int = FILE, include_subdirectories: bool = true) -> Array:
	if path.ends_with(".gd"):
		return [{"path": path, "name": Array(path.split("/")).back()}]
	return _list(path, searching_for, include_subdirectories)
	
static func directory_list(path: String = "res://tests", searching_for: int = DIRECTORY, include_subdirectories: bool = true) -> Array:
	if not _directory_exists(path):
		OS.alert("Directory: %s does not exist" % path)
	return _list(path, searching_for, include_subdirectories)

static func _list(path: String, searching_for: int, include_subdirectories: bool) -> Array:
	var results: Array = []
	
	var directory: Directory = Directory.new()
	directory.open(path)
	directory.list_dir_begin(true)
	var name: String = directory.get_next()
	while name != "":
		var absolute_path: String = "%s/%s" % [path, name]
		
		if searching_for == FILE:
			if name.ends_with(".gd"):
				results.append({path = absolute_path, "name": name})
			elif directory.current_is_dir() and include_subdirectories:
				results += _list(absolute_path, searching_for, include_subdirectories)
				
		elif searching_for == DIRECTORY and directory.current_is_dir():
			results.append(absolute_path)
			results += _list(absolute_path, searching_for, include_subdirectories)
			
		name = directory.get_next()
	directory.list_dir_end()
	return results

static func clear_temporary_files(main_directory: String = "user://WATemp/", delete_subdirectories: bool = true) -> void:
	var directory: Directory = Directory.new()
	for file in file_list("user://WATemp/"):
		directory.remove(file.path)
	for folder in directory_list("user://WATemp/"):
		directory.remove(folder)

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