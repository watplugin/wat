extends Object
# We don't seem to need tool here yet but I'm keeping this comment JIC

var nodes: Dictionary = {}
var _created: bool = false

func _init(nodes: Dictionary) -> void:
	print(self.nodes.size() == 0)
	self.nodes = nodes
	
func get_node(path: String):
	return nodes[path]
	
func object():
	# Arrange and Create
	var root: Node = nodes["."].object() # If we ca
	return root
	
func clear():
	nodes = {}