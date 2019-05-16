extends Reference

# Controllers
const TOKENIZER = preload("res://addons/WAT/double/tokenizer.gd")
const REWRITER = preload("res://addons/WAT/double/rewriter.gd")
const IO = preload("res://addons/WAT/input_output.gd")

# Data Structures
const BLANK: Script = preload("res://addons/WAT/double/blank.gd")
const SCRIPT_DATA = preload("res://addons/WAT/double/script_data.gd")
const SCENE_DATA = preload("res://addons/WAT/double/scene_data.gd")

class NodeData:
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


static func script(gdscript) -> SCRIPT_DATA:
	var script: Script = IO.load_script(gdscript)
	var tokens = TOKENIZER.start(script)
	var rewrite: String = REWRITER.start(tokens)
	IO.save_script(tokens.title, rewrite)
	return SCRIPT_DATA.new(tokens.methods, IO.load_doubled_script(tokens.title))

static func scene(tscn) -> SCENE_DATA:
	var copy: Node = IO.load_scene_instance(tscn).duplicate()
	var save_path: String = "user://WATemp/%s.tscn" % copy.name
	var outline: Array = double(copy)
	var double = double_tree(outline)
	var packed_double = PackedScene.new()
	packed_double.pack(double)
	ResourceSaver.save(save_path, packed_double)
	return SCENE_DATA.new({}, Node.new())
	# LOAD SCENE TO COPY
	# CREATE SAVE PATH
	# DUPLICATE TREE
	# MODIFY SCRIPTS HERE?
	# CREATE SCENE DATA
	# TEST IF WE CAN CALL METHODS VIA INSTANCE

#	tatic func _create_node(data: Dictionary) -> Node:
#return load(data.scriptpath).new() if data.scriptpath != null else Node.new()

enum PATH {
	SCRIPT
	SELF
	PARENT
}

static func double(root: Node):
	var count: int = 0
	#### BEGIN BUILDING OUTLINE ####
	var tree: Array = [] # NodePath (as string) : {scriptpath}
	var frontier: Array = []
	# handle root special case
	frontier += root.get_children()

	# var parent = node.get_path_to(node.get_parent())
	if root.script != null:
		var tokens = TOKENIZER.start(root.script)
		var rewrite = REWRITER.start(tokens)
		var script_path: String = "user://WATemp/%s.gd" % tokens.title
		IO.save_script(tokens.title , rewrite)

#		var script: Script = load(script_path)
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
			var script_path: String = "user://WATemp/%s.gd" % tokens.title
			IO.save_script(tokens.title , rewrite)
			tree.append(NodeData.new(node.name, path, parent, script_path, tokens.methods))
		else:
			tree.append(NodeData.new(node.name, path, parent))
	return tree


static func double_tree(outline: Array):
	# Earliest gens are near the frotn
	print(outline.size(), " is size")
	var root: Node
	var first = outline.pop_front()
	root = load(first.script).new() if first.script != null else Node.new()
	root.name = first.title

	### More
	for i in outline:
		var n: Node = load(i.script).new() if i.script != null else Node.new()
		n.name = i.title
		print(i.title, " is title")
		root.add_child(n) if i.parent == "." else root.get_node(i.parent).add_child(n)
		n.owner = root
	return root





























