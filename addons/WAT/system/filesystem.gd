extends Reference

const DO_NOT_SEARCH_PARENT_DIRECTORIES: bool = true

static func test_folder():
	return ProjectSettings.get_setting("WAT/Test_Directory")

static func scripts(path: String = test_folder()) -> PoolStringArray:
	if path.ends_with(".gd"):
		var list: PoolStringArray = [path]
		return list
	else:
		var list = _list_dir(path)
		var output: PoolStringArray = []
		var directory: Directory = Directory.new()
		for path in list:
			if directory.file_exists(path):
				if path.ends_with(".gd"):
					output.append(path)
		return output
	
static func directories(path: String = test_folder()) -> PoolStringArray:
	var list = _list_dir(path)
	var output: PoolStringArray = []
	var directory: Directory = Directory.new()
	for path in list:
		if directory.dir_exists(path):
			output.append(path)
	return output
	
static func _list_dir(path: String) -> PoolStringArray:
	var list: PoolStringArray = []
	var subdirectories: PoolStringArray = []
	
	var directory: Directory = Directory.new()
	directory.open(path)
	directory.list_dir_begin(DO_NOT_SEARCH_PARENT_DIRECTORIES)
	var name: String = directory.get_next()
	while name != "":
		
		var absolute_path: String = "%s/%s" % [path, name]
		if directory.dir_exists(absolute_path):
			subdirectories.append(absolute_path)
		list.append(absolute_path)
		name = directory.get_next()
	directory.list_dir_end()
	
	for subdirectory in subdirectories:
		list += _list_dir(subdirectory)
		
	return list
