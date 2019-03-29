extends Reference

const TEMP_DIR_PATH: String = "user://WATemp/"
const SCENE_DIR_PATH: String = "%s/"
const SCRIPT_PATH: String = "%s%s.gd"
const SCENE_PATH: String = "%s.tscn"
const NO_SUB_DIR: String = ""
const BLANK: Script = preload("blank.gd")

static func load_script(gdscript) -> Script:
	assert(gdscript is Script or (gdscript is String and gdscript.ends_with(".gd")))
	return gdscript if gdscript is Script else load(gdscript)
	
static func save_script(title: String, rewrite: String, path: String = TEMP_DIR_PATH + NO_SUB_DIR) -> void:
	_create_directory_if_it_does_not_exist(path)
	# Blank is probably not the best term
	BLANK.source_code = rewrite
	ResourceSaver.save(SCRIPT_PATH % [path, title], BLANK)
	
static func load_doubled_script(title: String, path: String = TEMP_DIR_PATH + NO_SUB_DIR) -> Script:
	return load(SCRIPT_PATH % [path, title]).new()
	
static func load_scene_instance(tscn) -> Node:
	assert(tscn is PackedScene or (tscn is String and tscn.ends_with(".tscn")))
	return tscn.instance() if tscn is PackedScene else load(tscn).instance()
	
static func save_scene(scene: Node, path: String, name: String) -> void:
	var doubled_scene = PackedScene.new()
	doubled_scene.pack(scene)
	ResourceSaver.save("%s%s.tscn" % [path, name], doubled_scene)
	
static func load_doubled_scene(path: String, name: String) -> Node:
	return load("%s%s.tscn" % [path, name]).instance()
	
static func _create_directory_if_it_does_not_exist(path: String) -> void:
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)
