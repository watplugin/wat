extends Reference

var component: TreeItem
var context: String = ""
var success: bool = false

func _init(_component: TreeItem, data: Dictionary) -> void:
	component = _component
	context = data["context"]
	success = data["success"]
	if context != "":
		component.set_text(0, context)
