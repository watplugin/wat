extends Reference

enum {
	FULL
	PARTIAL
}

# Controllers
const CONFIG = preload("res://addons/WAT/Settings/Config.tres")
const TOKENIZER = preload("res://addons/WAT/double/scripts/tokenizer.gd")
const REWRITER = preload("res://addons/WAT/double/scripts/rewriter.gd")
#const IO = preload("res://addons/WAT/utils/loader.gd")
const BLANK: Script = preload("res://addons/WAT/double/objects/blank.gd")
const FILESYSTEM = preload("res://addons/WAT/utils/filesystem.gd")

# Data Structures
const SCRIPT_DATA = preload("res://addons/WAT/double/objects/script_data.gd")
const SCENE_DATA = preload("res://addons/WAT/double/objects/scene_data.gd")

class NodeData extends Reference:
	var title: String
	var path = null
	var parent = null
	var script = null
	var methods = null

	func _init(title: String, path = null, parent = null, script = null, methods = null):
		self.title = title
		self.path = path
		self.parent = parent
		self.script = script
		self.methods = methods

static func script(gdscript, strategy = _default_strategy()) -> SCRIPT_DATA:
	var script: Script = load_script(gdscript)
	var tokens = TOKENIZER.start(script)
	var rewrite: String = REWRITER.start(tokens)
	var save_path = save_script(tokens.title, rewrite)
	return SCRIPT_DATA.new(tokens.methods, load_script(save_path).new(), strategy)

static func scene(tscn, strategy = _default_strategy()) -> SCENE_DATA:
	var copy: Node = load_scene_instance(tscn)
	var outline: Array = double(copy)
	copy.free()
	var tree: Node = double_tree(outline.duplicate())
	save_scene(tree.name, tree)
	var nodes: Dictionary = create_scene_data(tree, outline, strategy)
	return SCENE_DATA.new(nodes, tree)
	
static func save_scene(title: String, scene: Node) -> String:
	var save_path: String = _save_path(title)
	var double = PackedScene.new()
	double.pack(scene)
	ResourceSaver.save(save_path, double)
	return save_path
	
static func load_script(gdscript) -> Script:
	assert(gdscript is Script or (gdscript is String and gdscript.ends_with(".gd")))
	return gdscript if gdscript is Script else load(gdscript)

static func load_scene_instance(tscn) -> Node:
	assert(tscn is PackedScene or (tscn is String and tscn.ends_with(".tscn")))
	return tscn.instance() if tscn is PackedScene else load(tscn).instance()

static func save_script(title: String, rewrite: String) -> String:
	var save_path: String = _save_path(title)
	BLANK.source_code = rewrite
	ResourceSaver.save(save_path, BLANK)
	return save_path	
	
static func _save_path(title: String) -> String:
	_create_directory_if_it_does_not_exist("user://WATemp")
	return "user://WATemp/%s_%s.gd" % [title, FILESYSTEM.file_list("user://WATemp").size()]

static func _create_directory_if_it_does_not_exist(path: String) -> void:
	var dir = Directory.new()
	if not dir.dir_exists(path):
		dir.make_dir(path)

static func create_scene_data(instance: Node, outline: Array, strategy: int) -> Dictionary:
	var nodes: Dictionary = {}
	for data in outline:
		if data.script != null:
			var path: String = str(data.path)
			var node = instance.get_node(path)
			var methods = data.methods
			nodes[path] = SCRIPT_DATA.new(methods, node, strategy)
	return nodes

static func double(root: Node):
	var count: int = 0
	var tree: Array = []
	var frontier: Array = []

	# Handle root as a special case
	frontier += root.get_children()
	if root.script != null:
		var tokens = TOKENIZER.start(root.script)
		var rewrite = REWRITER.start(tokens)
		var script_path = save_script(tokens.title , rewrite)
		var path: String = str(root.get_path_to(root))
		tree.append(NodeData.new(root.name, path, null, script_path, tokens.methods))
	else:
		var path: String = str(root.get_path_to(root))
		tree.append(NodeData.new(root.name, path, null))

	# Handling other cases
	while not frontier.empty():
		var node = frontier.pop_front()
		frontier += node.get_children()
		var path: String = str(root.get_path_to(node))
		var parent: String = str(root.get_path_to(node.get_parent()))
		if node.script != null:
			var tokens = TOKENIZER.start(node.script)
			var rewrite = REWRITER.start(tokens)
			var script_path = save_script(tokens.title , rewrite)
			tree.append(NodeData.new(node.name, path, parent, script_path, tokens.methods))
		else:
			tree.append(NodeData.new(node.name, path, parent))
	return tree


static func double_tree(outline: Array) -> Node:

	# Handling root as a special case
	var first = outline.pop_front()
	var root: Node = load(first.script).new() if first.script != null else Node.new()
	root.name = first.title

	# Handling other cases
	for i in outline:
		var n: Node = load(i.script).new() if i.script != null else Node.new()
		root.add_child(n) if i.parent == "." else root.get_node(i.parent).add_child(n)
		n.name = i.title
		n.owner = root

	return root

static func _default_strategy() -> int:
	return PARTIAL if CONFIG.double_strategy_is_partial else FULL