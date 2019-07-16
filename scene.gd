extends Object
# We don't seem to need tool here yet but I'm keeping this comment JIC

var nodes: Dictionary = {}
var _created: bool = false

func _init(nodes: Dictionary) -> void:
	self.nodes = nodes
	
func get_node(path: String):
	return nodes[path]
	
#func object():
#	# Arrange and Create
#	var root: Node = nodes["."].object() # If we ca
#	return root

func object():
	var root: Node = nodes["."].object()
	print(nodes)
	root.name = "Main"
	for nodepath in nodes:
		if nodepath == ".":
			continue # Skip if root node since already defined
		var node: Node = nodes[nodepath].object()
		assert(node != null)
		var path = nodepath.split("/")
		print(path)
		if path.size() == 1: # Node is a child of root
			node.name = path[0]
			print(node.name)
			root.add_child(node)
			node.owner = root
			## IGNORE THIS UNTIL WE CAN DO IMMEDIATE CHILDREN
#		elif path.size() > 1: # Node is a subchild of other children
#			var end: int = path.size()-1
#			node.name = path[end]
#			path.remove(path[end])
#			var parent: String = path.join("/")
#			root.get_node(parent).add_child(node)
	root.print_tree_pretty()
	print(root.name)
	return root
		
	
func clear():
	nodes = {}