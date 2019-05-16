extends Reference

var _nodes: Dictionary = {}
var instance: Node
const is_scene: bool = true

func _init(nodes, scene: Node) -> void:
	self._nodes = nodes
	self.instance = scene

func execute(node: String, method: String, count: int = 0, a = null, b = null, c = null, d = null, e = null, f = null, g = null, h = null, i = null):
	return _nodes[node].execute(method, count, a, b, c, d, e, f, g, h, i)
	
func default(node: String, method: String, default) -> void:
	_nodes[node].default(method, default)
	
func get_retval(node: String, method: String, arguments: Dictionary):
	return _nodes[node].get_retval(method, arguments)
	
func stub(node: String, method: String, arguments: Dictionary, retval) -> void:
	_nodes[node].stub(method, arguments, retval)
	
func call_count(node: String, method: String) -> int:
	return _nodes[node].call_count(method)
	
func calls(node: String, method: String) -> Array:
	return _nodes[node].calls(method)