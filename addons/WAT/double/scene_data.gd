extends Reference

var _nodes: Dictionary = {}
var instance: Node

func _init(nodes: Dictionary, scene: Node) -> void:
	self._nodes = nodes
	self.instance = scene
	quick_node_swap()
	
func quick_node_swap():
	if "." in _nodes:
		print("setting root")
		var false_parent = Node
		
		var children = instance.get_children()
		var script = instance.get_script()
		var replacement = script.new()
#		_nodes["."].instance = self.instance
#		self.instance.set_meta("double", _nodes["."])
		
		for child in children:
			child.get_parent().remove_child(child)
			replacement.add_child(child)
			
		var data = _nodes["."]
		data.instance = replacement
		data.instance.set_meta("double", data)
		
		self.instance = replacement

	for path in _nodes:
		if path == ".":
			continue
		# Can't find grandchildren? or "A/B" / We're moving them when setting replacement nodes
		var node = instance.get_node(path as NodePath)
		if node == null:
			continue
		var parent = node.get_parent()
		parent.remove_child(node)
		var script = node.script
		var replacement_node = script.new()
		parent.add_child(replacement_node)
		replacement_node.name = node.name
		
		# grabbing children
		for child in node.get_children():
			node.remove_child(child)
			replacement_node.add_child(child)
		
		# update metadata
		var data = _nodes[path]
		data.instance = replacement_node
		replacement_node.set_meta("double", data)
	
func get_retval(node: String, method: String, arguments: Dictionary):
	return _nodes[node].get_retval(method, arguments)
	
func stub(node: String, method: String, arguments: Dictionary, retval) -> void:
	_nodes[node].stub(method, arguments, retval)
	
func call_count(node: String, method: String) -> int:
	return _nodes[node].call_count(method)
	
func calls(node: String, method: String) -> Array:
	return _nodes[node].calls(method)