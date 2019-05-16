extends Reference

const TEMP_DIR_PATH: String = "user://WATemp/"
const SCENE_DIR_PATH: String = "%s/"
const SCRIPT_PATH: String = "%s%s_%s.gd"
const SCENE_PATH: String = "%s.tscn"
const NO_SUB_DIR: String = ""
const BLANK: Script = preload("res://addons/WAT/double/blank.gd")

static func load_script(gdscript) -> Script:
	assert(gdscript is Script or (gdscript is String and gdscript.ends_with(".gd")))
	return gdscript if gdscript is Script else load(gdscript)
	
static func save_script(title: String, rewrite: String, path: String = TEMP_DIR_PATH + NO_SUB_DIR) -> void:
	_create_directory_if_it_does_not_exist(path)
	# Blank is probably not the best term
	BLANK.source_code = rewrite
	ResourceSaver.save(SCRIPT_PATH % ["user://WATemp/", str(_count()), title], BLANK)
	
static func load_doubled_script(title: String, path: String = TEMP_DIR_PATH + NO_SUB_DIR) -> Script:
	return load(SCRIPT_PATH % [path, title]).new()
	
static func load_scene_instance(tscn) -> Node:
	assert(tscn is PackedScene or (tscn is String and tscn.ends_with(".tscn")))
	return tscn.instance() if tscn is PackedScene else load(tscn).instance()
	
static func save_scene(scene: Node, path: String, name: String) -> void:
	var doubled_scene = PackedScene.new()
	var result = doubled_scene.pack(scene)
	if result != OK:
		print("ERROR %s when trying to pack scene" % str(result))
	ResourceSaver.save("user://WATemp/%s%s.tscn" % [str(_count()), name], doubled_scene)
	
static func load_doubled_scene(path: String, name: String) -> Node:
	return load("%s%s.tscn" % [path, name]).instance()
	
static func _create_directory_if_it_does_not_exist(path: String) -> void:
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)
		
static func _count() -> int:
	var path: String = "user://WATemp/"
	var d = Directory.new()
	if not d.dir_exists(path):
		print("dir: %s does not exist" % path)
	var result = d.open(path)
	if result != OK:
		print("Error %s when trying to open dir: %s" % [str(result), path])
	var count: int = 0
	d.list_dir_begin(true)
	var file = d.get_next()
	while file != "":
		count += 1
		file = d.get_next()
	return count

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
		if d.current_is_dir():
			_clear_dir(path + file)
		d.remove(path + file)
		file = d.get_next()
	# Don't delete WATemp itself. Just keep it empty
	
static func _clear_dir(path: String):
	var d = Directory.new()
	if not d.dir_exists(path):
		print("dir: %s does not exist" % path)
		return
	var result = d.open(path)
	if result != OK:
		print("Error %s when trying to opening dir: %s" % [str(result), path])
		return
	d.list_dir_begin(true)
	var file = d.get_next()
	while file != "":
		var res = d.remove(file)
		if res != OK:
			print("Error %s when trying to remove file: %s" % [str(res), file])
		file = d.get_next()