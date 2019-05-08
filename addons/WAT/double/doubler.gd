extends Reference

# Controllers
const TOKENIZER = preload("res://addons/WAT/double/tokenizer.gd")
const REWRITER = preload("res://addons/WAT/double/rewriter.gd")
const IO = preload("res://addons/WAT/input_output.gd")

# Data Structures
const BLANK: Script = preload("res://addons/WAT/double/blank.gd")
const SCRIPT_DATA = preload("res://addons/WAT/double/script_data.gd")
const SCENE_DATA = preload("res://addons/WAT/double/scene_data.gd")



static func script(gdscript) -> SCRIPT_DATA:
	var script: Script = IO.load_script(gdscript)
	var tokens = TOKENIZER.start(script)
	var rewrite: String = REWRITER.start(tokens)
	IO.save_script(tokens.title, rewrite)
	var s = IO.load_doubled_script(tokens.title)
	return SCRIPT_DATA.new(tokens.methods, IO.load_doubled_script(tokens.title))

static func scene(tscn) -> SCENE_DATA:
	var scene = IO.load_scene_instance(tscn)
	var path: String = IO.TEMP_DIR_PATH + IO.SCENE_DIR_PATH % scene.name
	var outline: Array = _get_tree_outline(path, scene)
	var doubled: Node = _create_scene_double(outline, scene.name)
	IO.save_scene(doubled, path, scene.name)
	var nodes = scene_node_data(doubled, outline)
	return SCENE_DATA.new(nodes, doubled)
	
#	self.instance = scene
static func scene_node_data(instance, outline: Array) -> Dictionary:
	var nodes: Dictionary
	for data in outline:
		if data.scriptpath != null:
			var path: String = str(data.nodepath)
			var node = instance.get_node(path)
			var methods = data.methods
			nodes[path] = SCRIPT_DATA.new(methods, node)
	return nodes

static func _get_tree_outline(scene_path: String, scene: Node) -> Array:
	# SEPERATE METHOD
	var outline: Array = []
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
			IO.save_script(tokens.title, rewrite, scene_path)
			data.scriptpath = IO.SCRIPT_PATH % [scene_path, tokens.title]
			data.methods = tokens.methods
		outline.append(data)
	return outline

static func _create_scene_double(paths: Array, name) -> Node:
	var root = Node.new() # We require to give root a proper node
	for i in paths:
		var node: Node = _create_node(i)
		var split_node_path: Array = split_nodepath(i.nodepath)
		if _is_scene_root(split_node_path):
			_add_root(name, node, root)
			continue # Root doesn't like to own itself
		elif _is_child_of_root(split_node_path):
			_add_child(split_node_path, node, root)
		elif _is_grandchild(split_node_path):
			_add_grandchild(split_node_path, node, root)
		# Setting all owners to root for saving
		node.owner = root
	return root

static func _has_custom_script(node: Node) -> bool:
	return node.script != null
	
static func _create_node(data: Dictionary) -> Node:
	return load(data.scriptpath).new() if data.scriptpath != null else Node.new()
	
static func split_nodepath(nodepath: String) -> Array:
	return Array(nodepath.split("/"))
	
static func _is_scene_root(node: Array) -> bool:
	return node[0] == "." and node.size() == 1
	
static func _is_child_of_root(nodepath: Array) -> bool:
	return nodepath.size() == 1

static func _is_grandchild(nodepath: Array) -> bool:
	return nodepath.size() > 1

static func _add_root(name: String, node: Node, root: Node) -> void:
		root = node
		root.name = name
		
static func _add_child(split_node_path: Array, node: Node, root: Node) -> void:
	node.name = split_node_path.front()
	root.add_child(node)
		
static func _add_grandchild(split_node_path: Array, node: Node, root: Node) -> void:
	var grandchild_name = split_node_path.pop_back()
	var child_name = split_node_path.pop_back()
	node.name = grandchild_name
	root.get_node(child_name).add_child(node)
