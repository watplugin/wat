extends Reference
class_name WATDouble

# Controllers
const TOKENIZER = preload("res://addons/WAT/double/tokenizer.gd")
const REWRITER = preload("res://addons/WAT/double/rewriter.gd")

# Data Structures
const BLANK: Script = preload("res://addons/WAT/double/blank.gd")
const SCRIPT_DATA = preload("res://addons/WAT/double/script_data.gd")
const SCENE_DATA = preload("res://addons/WAT/double/scene_data.gd")
const TEMP_DIR_PATH: String = "user://WATemp/"
const SCENE_DIR_PATH: String = "%s/"
const SCRIPT_PATH: String = "%s%s.gd"
const SCENE_PATH: String = "%s.tscn"
const NO_SUB_DIR: String = ""

static func scene(tscn):
	var scene = _load_scene_instance(tscn)
	var scene_path: String = TEMP_DIR_PATH + SCENE_DIR_PATH % scene.name
	var node_data: Dictionary = {}
	
	# SEPERATE METHOD
	var frontier: Array = [scene]
	while not frontier.empty():
		var node = frontier.pop_front()
		frontier += node.get_children()
		
		if _has_custom_script(node):
			var script_data: SCRIPT_DATA = script(node.script, scene_path)
			var node_path: String = _get_node_path(scene, node)
			node.set_script(script_data.instance.get_script()) # Create a new sce
			node_data[node_path] = script_data
	# SEPERATE METHOD
	
	# SEPERATE METHOD?
	var rewrite = PackedScene.new()
	rewrite.pack(scene)
	_save_scene(rewrite, scene_path, scene.name)
	return SCENE_DATA.new(node_data, _load_doubled_scene(scene_path, scene.name))


static func script(gdscript, path: String = TEMP_DIR_PATH + NO_SUB_DIR) -> SCRIPT_DATA:
	var script: Script = _load_script(gdscript)
	var tokens = TOKENIZER.start(script)
	var rewrite: String = REWRITER.start(tokens)
	_save_script(tokens.title, rewrite, path) 
	return SCRIPT_DATA.new(tokens.methods, _load_doubled_script(tokens.title, path))

static func _load_script(gdscript) -> Script:
	assert(gdscript is Script or (gdscript is String and gdscript.ends_with(".gd")))
	return gdscript if gdscript is Script else load(gdscript)
	
static func _save_script(title: String, rewrite: String, path: String) -> void:
	_create_directory_if_it_does_not_exist(path)
	# Blank is probably not the best term
	BLANK.source_code = rewrite
	ResourceSaver.save(SCRIPT_PATH % [path, title], BLANK)
	
static func _load_doubled_script(title: String, path: String = TEMP_DIR_PATH + NO_SUB_DIR) -> Script:
	return load(SCRIPT_PATH % [path, title]).new()
	
static func _load_scene_instance(tscn) -> Node:
	assert(tscn is PackedScene or (tscn is String and tscn.ends_with(".tscn")))
	return tscn.instance() if tscn is PackedScene else load(tscn).instance()
	
static func _has_custom_script(node: Node) -> bool:
	return node.script != null
	
static func _get_node_path(root: Node, node: Node) -> String:
	return str(root.get_path_to(node))
		
static func _save_scene(rewrite: PackedScene, path: String, name: String) -> void:
	ResourceSaver.save("%s%s.tscn" % [path, name], rewrite)
	
static func _load_doubled_scene(path: String, name: String) -> Node:
	return load("%s%s.tscn" % [path, name]).instance()
	
static func _create_directory_if_it_does_not_exist(path: String) -> void:
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)
