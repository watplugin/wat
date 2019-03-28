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

static func scene(tscn) -> SCENE_DATA:
	var scene = _load_scene_instance(tscn)
	var scene_path: String = TEMP_DIR_PATH + SCENE_DIR_PATH % scene.name
	var outline: Array = _get_tree_outline(scene_path, scene)
	var doubled: Node = _create_scene_double(outline, scene.name)
	_save_scene(doubled, scene_path, scene.name)
	return SCENE_DATA.new(outline, doubled)

static func _get_tree_outline(scene_path: String, scene: Node) -> Array:
	# SEPERATE METHOD
	var paths: Array = []
	var frontier: Array = [scene]
	while not frontier.empty():
		var node = frontier.pop_front()
		frontier += node.get_children()
		var path = scene.get_path_to(node)
		var data = {"nodepath": path, "scriptpath": null, "methods": null}
		
		# We need to create a NEW TREE, rather than anything else. Duplicating will not work.
		if _has_custom_script(node):
			var script: Script = node.script
			var tokens = TOKENIZER.start(script)
			var rewrite: String = REWRITER.start(tokens)
			_save_script(tokens.title, rewrite, scene_path)
			data.scriptpath = SCRIPT_PATH % [scene_path, tokens.title]
			data.methods = tokens.methods
		paths.append(data)
	return paths

static func _create_scene_double(paths: Array, name) -> Node:
	var root = Node # May cause issues later
	for i in paths:
		var node = Node.new()
		if i.scriptpath != null: # Need to figure out for defaults
			node = load(i["scriptpath"]).new() # Loading Custom Script
		var hieracy = str(i["nodepath"]).split("/")
		if hieracy[0] == "." and hieracy.size() == 1:
			root = node
			root.name = name
			continue # Unnecessary?
		elif hieracy.size() == 1:
			# We're an immediate hcild
			node.name = hieracy[0]
			root.add_child(node)
		else:
			# Adding Subchildren
			var nodepath_list = Array(hieracy)
			var main_node = nodepath_list.pop_back()
			var parent_node = nodepath_list.pop_back()
			node.name = main_node
			root.get_node(parent_node).add_child(node)
		# Setting all owners to root for saving
		node.owner = root
	return root

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
		
static func _save_scene(scene: Node, path: String, name: String) -> void:
	var doubled_scene = PackedScene.new()
	doubled_scene.pack(scene)
	ResourceSaver.save("%s%s.tscn" % [path, name], doubled_scene)
	
static func _load_doubled_scene(path: String, name: String) -> Node:
	return load("%s%s.tscn" % [path, name]).instance()
	
static func _create_directory_if_it_does_not_exist(path: String) -> void:
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)
