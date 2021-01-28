extends Node

const NodeAdded: String = "node_added"

func _init() -> void:
	custom_multiplayer = MultiplayerAPI.new()
	custom_multiplayer.set_root_node(self)

func _process(delta: float) -> void:
	if custom_multiplayer.has_network_peer():
		custom_multiplayer.poll()


#func _notification(notification: int) -> void:
#	if notification != NOTIFICATION_ENTER_TREE:
#		return
#	get_tree().connect(NodeAdded, self, "_on_node_added")
#	customize_children()
#
#func _on_node_added(node: Node) -> void:
#	var treepath: String = node.get_path()
#	var ourpath: String = get_path()
#	var substr: String = treepath.substr(0, ourpath.length())
#	if substr != ourpath:
#		return
#	var relativepath: String = treepath.substr(ourpath.length(), treepath.length())
#	if relativepath.length() > 0 and !relativepath.begins_with("/"):
#		return
#	node.custom_multiplayer = custom_multiplayer
#
#func customize_children() -> void:
#	var frontier: Array = []
#	for child in get_children():
#		frontier.append(child)
#
#	while not frontier.empty():
#		var child: Node = frontier.pop_front()
#		child.custom_multiplayer = custom_multiplayer
#		for grandchild in child.get_children():
#			frontier.append(grandchild)
