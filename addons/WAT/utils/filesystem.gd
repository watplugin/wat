extends Reference

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
			if name.ends_with(".gd") or name.ends_with(".tres"):
				results.append({path = absolute_path, "name": name})
			elif directory.current_is_dir() and include_subdirectories:
				results += _list(absolute_path, searching_for, include_subdirectories)

		elif searching_for == DIRECTORY and directory.current_is_dir():
			results.append(absolute_path)
			results += _list(absolute_path, searching_for, include_subdirectories)

		name = directory.get_next()
	directory.list_dir_end()
	return results

static func clear_temporary_files(main_directory: String = "user://WATemp", delete_subdirectories: bool = true) -> void:
	return
	var directory: Directory = Directory.new()
	for file in file_list(main_directory):
		directory.remove(file.path)
	for folder in directory_list(main_directory):
		directory.remove(folder)

static func _directory_exists(path: String) -> bool:
	return Directory.new().dir_exists(path)