extends Reference

var component: TreeItem
var path: String
var title: String
var methods: Dictionary = {}
var method_names: PoolStringArray

func _init(_component: TreeItem, data: Dictionary) -> void:
	component = _component
	title = data["name"]
	path = data["path"]
	method_names = data["methods"]
	_component.set_text(0, title)
