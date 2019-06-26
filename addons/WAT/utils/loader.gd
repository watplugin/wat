extends Reference

const BLANK: Script = preload("res://addons/WAT/double/objects/blank.gd")
const FILESYSTEM = preload("res://addons/WAT/utils/filesystem.gd")

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
	return "user://WATemp/%s_%s.gd" % [title, FILESYSTEM.file_list("user://WATemp").size()]

static func _create_directory_if_it_does_not_exist(path: String) -> void:
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)