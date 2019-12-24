extends Reference
# We don't seem to need tool here yet but I'm keeping this comment JIC

var nodes: Dictionary = {}
var _created: bool = false
var cache: Array = []

func _init(nodes: Dictionary = {}) -> void:
	print("Creating Scene Director with ID: %s" % get_instance_id() as String)
	print("Adding Nodes of Size %s (%s)" % [nodes.size(), nodes])
	self.nodes = nodes

func get_node(path: String):
	print("fetching: %s?" % path)
#	return nodes[path]

# func _notification(what: int) -> void:
# 	if what == NOTIFICATION_PREDELETE:
# 		print("Being Deleted")
# 		for item in cache:
# 			print("Checking if item %s is freeable" % item)
# 			if item is Object and not item is Reference and is_instance_valid(item):
# 				print("is Object? %s" % item is Object)
# 				print("is not Reference? %s" % (not item is Reference))
# 				print("is valid instance? %s" % is_instance_valid(item))
# 				print("Freeing %s item" % item)
# 				item.queue_free()

func double():
	if _created:
		push_warning("Already Created")
	_created = true
	print("Creating Double")
	var root: Node = nodes["."].double()
	for nodepath in nodes:
		var path = nodepath.split("/")
		if nodepath == ".":
			print("Skipping Root")
			# Skip if root node since already defined
			continue
			# Node is a child of root
		elif path.size() == 1:
			_add_child(path, nodepath, root)
		elif path.size() > 1:
			_add_grandchild(path, nodepath, root)
	print("adding root to cache")
	# cache.append(root)
	print("added root to cache")
	return root

func _add_child(path, nodepath, root):
	print("adding child")
	var node: Node = nodes[nodepath].double()
	node.name = path[0]
	root.add_child(node)
	cache.append(node)
	print("added child")

func _add_grandchild(path, nodepath, root):
	print("adding grandchild")
	var node: Node = nodes[nodepath].double()
	var p = Array(path)
	node.name = p.pop_back()
	var parent = ""
	for element in p:
		parent += "%s/" % element
	parent = parent.rstrip("/")
	var grandparent = root.get_node(parent)
	grandparent.add_child(node)
	cache.append(grandparent)
	print("added granchild")

func clear():
	nodes = {}