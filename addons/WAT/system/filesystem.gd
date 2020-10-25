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
			if directory.call("file_exists", path):
				if path.ends_with(".gd"):
					output.append(path)
		return output
	
static func directories(path: String = test_folder()) -> PoolStringArray:
	var list = _list_dir(path)
	var output: PoolStringArray = []
	var directory: Directory = Directory.new()
	for path in list:
		if directory.call("dir_exists", path):
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

static func templates():
	var template_directory: String = ProjectSettings.get_setting("editor/script_templates_search_path")
	var dir: Directory = Directory.new()
	if not dir.dir_exists(template_directory):
		dir.make_dir_recursive(template_directory)
	var test_template: String = "wat.test.gd"
	var scripts: Array = scripts(template_directory)
	var template_exist = false
	for script in scripts:
		var title = script.substr(script.find_last("/") + 1, -1)
		if title == test_template:
			template_exist = true
			break
	return {savepath = template_directory, exists = template_exist}
