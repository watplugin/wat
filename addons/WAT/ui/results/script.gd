extends Reference

const MethodTreeItem: GDScript = preload("res://addons/WAT/ui/results/method.gd")
var component: TreeItem
var path: String
var title: String
var methods: Dictionary = {}
var method_names: PoolStringArray
var total: int = 0
var passed: int = 0

func _init(_component: TreeItem, data: Dictionary) -> void:
	component = _component
	title = data["name"] if data["title"] == "" else data["title"]
	path = data["path"]
	method_names = data["methods"]
	_component.set_text(0, title)

func add_method(tree: Tree, data: Dictionary) -> void:
	var method = MethodTreeItem.new(tree.create_item(component), data["method"], path)
	methods[method.path] = method
	total += 1
	component.set_text(0, "(%s/%s) %s" % [passed, total, title])
	tree.scroll_to_item(method.component)

func on_method_finished(data: Dictionary) -> void:
	if data["success"]:
		passed += 1
	component.set_text(0, "(%s/%s) %s" % [passed, total, title])
