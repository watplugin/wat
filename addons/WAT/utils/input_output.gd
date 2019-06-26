extends Reference

const OLD = preload("old_input_output.gd")
const BLANK: Script = preload("res://addons/WAT/double/objects/blank.gd")

static func file_list(main_directory: String = "res://tests/", include_files_in_subdirectories: bool = true) -> Array:
	if not _directory_exists(main_directory):
		OS.alert("Directory: %s does not exist" % main_directory)
		return []
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

static func _create_directory_if_it_does_not_exist(path: String) -> void:
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)

static func _count() -> String:
	return OLD._count()