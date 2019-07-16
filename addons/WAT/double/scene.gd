extends Object
# We don't seem to need tool here yet but I'm keeping this comment JIC

var nodes: Dictionary = {}
var _created: bool = false
var cache: Array = []

func _init(nodes: Dictionary) -> void:
	self.nodes = nodes

func get_node(path: String):
	return nodes[path]

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		for item in cache:
			if item is Object and not item is Reference and is_instance_valid(item):
				item.free()

func object():
	var root: Node = nodes["."].object()
#	root.name = "Main"
	for nodepath in nodes:
		if nodepath == ".":
			continue # Skip if root node since already defined
		var node: Node = nodes[nodepath].object()
		var path = nodepath.split("/")
		if path.size() == 1: # Node is a child of root
			node.name = path[0]
			root.add_child(node)
			node.owner = root
		elif path.size() > 1: # Node is a subchild of other children
			var end: int = path.size()-1
			node.name = path[end]
			path.remove(end)
			var parent: String = path.join("/")
			root.get_node(parent).add_child(node)
	cache.append(root)
	return root


func clear():
	nodes = {}