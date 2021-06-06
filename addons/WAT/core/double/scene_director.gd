extends Reference
tool
# We don't seem to need tool here yet but I'm keeping this comment JIC

var nodes: Dictionary = {}
var _created: bool = false
var cache: Array = []
var _export_vars = {}

func _init(nodes: Dictionary = {}, export_vars = {}) -> void:
	self.nodes = nodes
	_export_vars = export_vars

func get_node(path: String) -> Node:
	return nodes[path]

func double() -> Node:
	if _created:
		push_error("WAT: You can only create one instance of a double"
		+ "Create a new doubler Object for new Test Doubles")
		return nodes["."]
	_created = true
	var root: Node = nodes["."].double()
	for nodepath in nodes:
		var path: PoolStringArray = nodepath.split("/")
		if nodepath == ".":
			# Skip if root node since already defined
			continue
		elif path.size() == 1:
			_add_child(path, nodepath, root)
		elif path.size() > 1:
			_add_grandchild(path, nodepath, root)
	for prop_name in _export_vars:
		root.set(prop_name, _export_vars[prop_name])
	return root
	
func _add_child(path: PoolStringArray, nodepath: String, root: Node) -> void:
	var node: Node = nodes[nodepath].double()
	node.name = path[0]
	root.add_child(node)

func _add_grandchild(path: PoolStringArray, nodepath: String, root: Node) -> void:
	var node: Node = nodes[nodepath].double()
	var p = Array(path)
	node.name = p.pop_back()
	var parent = ""
	for element in p:
		parent += "%s/" % element
	parent = parent.rstrip("/")
	var grandparent = root.get_node(parent)
	grandparent.add_child(node)

func clear() -> void:
	nodes = {}
