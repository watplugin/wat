extends Reference

const OLD = preload("old_input_output.gd")
const TEMP: String = "user://WATemp/"
const BLANK: Script = preload("res://addons/WAT/double/objects/blank.gd")

static func file_list(main_directory: String = "res://tests/", include_files_in_subdirectories: bool = true) -> PoolStringArray:
	var filenames: PoolStringArray = []
	var directory: Directory = Directory.new()
	directory.open(main_directory)
	directory.list_dir_begin(true)
	var name: String = directory.get_next()
	while name != "":
		if name.ends_with(".gd"):
			filenames.append(name)
		elif directory.current_is_dir() and include_files_in_subdirectories:
			print("%s/%s" % [main_directory, name])
			filenames += file_list("%s/%s" % [main_directory, name])
		name = directory.get_next()
	directory.list_dir_end()
	return filenames

static func load_script(gdscript) -> Script:
	return OLD.load_script(gdscript)

static func save_script(title: String, rewrite: String) -> String:
	return OLD.save_script(title, rewrite)

static func load_doubled_script(save_path: String) -> Script: # ???????
	return load(save_path).new()

static func load_scene_instance(tscn) -> Node:
	return OLD.load_scene_instance(tscn)

static func save_scene(scene: Node, name: String) -> String:
	return OLD.save_scene(scene, name)

static func load_doubled_scene(path: String, name: String) -> Node:
	return load("%s%s.tscn" % [path, name]).instance()

static func _create_directory_if_it_does_not_exist(path = TEMP) -> void:
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)

static func _count() -> String:
	return OLD._count()

static func clear_all_temp_directories():
	OLD.clear_all_temp_directories()
