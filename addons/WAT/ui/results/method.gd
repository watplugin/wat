extends Reference

var component: TreeItem
var path: String
var title: String

func _init(_component: TreeItem, _title: String) -> void:
	component = _component
	path = _title
	title = _title.replace("test_", "").replace("_", " ")
	_component.set_text(0, title)
