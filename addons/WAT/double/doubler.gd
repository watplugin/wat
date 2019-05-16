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
		IO.save_script(tokens.title, rewrite)
#		var script: Script = load(script_path)
		var path: String = str(root.get_path_to(root))
		tree.append({PATH.SELF: path, PATH.PARENT: null, PATH.SCRIPT: script_path, "NAME": root.name})
	else:
		var path: String = str(root.get_path_to(root))
		tree.append({PATH.SELF: path, PATH.PARENT: null, PATH.SCRIPT: null, "NAME": root.name})
		
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
			IO.save_script(tokens.title, rewrite)
			tree.append({PATH.SELF: path, PATH.PARENT: parent, PATH.SCRIPT: script_path, "NAME": node.name})
		else:
			tree.append({PATH.SELF: path, PATH.PARENT: parent, PATH.SCRIPT: null, "NAME": node.name})
	return tree
	
static func double_tree(outline: Array):
	# Earliest gens are near the frotn
	var root: Node
	var first = outline.pop_front()
	root = load(first[PATH.SCRIPT]).new() if first[PATH.SCRIPT] != null else Node.new()
	root.name = first["NAME"]
	
	### More
	for i in outline:
		var n: Node = load(i[PATH.SCRIPT]).new() if i[PATH.SCRIPT] != null else Node.new()
		n.name = i["NAME"]
		print("trying to add %s to %s" % [i[PATH.SELF], i[PATH.PARENT]])
		root.add_child(n) if i[PATH.PARENT] == "." else root.get_node(i[PATH.PARENT]).add_child(n)
		n.owner = root
	return root

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	