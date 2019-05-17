extends Reference

const TEMP: String = "user://WATemp/"
const BLANK: Script = preload("res://addons/WAT/double/blank.gd")

static func load_script(gdscript) -> Script:
	assert(gdscript is Script or (gdscript is String and gdscript.ends_with(".gd")))
	return gdscript if gdscript is Script else load(gdscript)
	
static func save_script(title: String, rewrite: String) -> String:
	_create_directory_if_it_does_not_exist()
	var save_path: String = "%s%s_%s.gd" % [TEMP, _count(), title]
	BLANK.source_code = rewrite
	ResourceSaver.save(save_path, BLANK)
	return save_path
	
static func load_doubled_script(save_path: String) -> Script:
	return load(save_path).new()
#	return load("user://WATemp/%s.gd" % title).new()
	
static func load_scene_instance(tscn) -> Node:
	assert(tscn is PackedScene or (tscn is String and tscn.ends_with(".tscn")))
	return tscn.instance() if tscn is PackedScene else load(tscn).instance()
	
static func save_scene(scene: Node, name: String) -> String:
	var double = PackedScene.new()
	double.pack(scene)
	var save_path: String = "%s%s_%s.tscn" % [TEMP, _count(), name]
	ResourceSaver.save(save_path, double)
	return save_path
	
static func load_doubled_scene(path: String, name: String) -> Node:
	return load("%s%s.tscn" % [path, name]).instance()
	
static func _create_directory_if_it_does_not_exist(path = TEMP) -> void:
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)
		
static func _count() -> String:
	var path: String = TEMP
	var d = Directory.new()
	var result = d.open(path)
	var count: int = 0
	d.list_dir_begin(true)
	var file = d.get_next()
	while file != "":
		count += 1
		file = d.get_next()
	return str(count)

static func clear_all_temp_directories():
	var path: String = "user://WATemp/"
	var d = Directory.new()
	if not d.dir_exists(path):
		print("dir: %s does not exist" % path)
	var result = d.open(path)
	if result != OK:
		print("Error %s when trying to open dir: %s" % [str(result), path])
		return
		
	d.list_dir_begin(true)
	var file = d.get_next()
	while file != "":
		var res = d.remove(file)
		if res != OK:
			print("Error %s when trying to remove file: %s" % [str(res), file])
		d.remove(path + file)
		file = d.get_next()