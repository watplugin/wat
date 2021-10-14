extends "res://addons/WAT/ui/results/counter.gd"

const MethodTreeItem: GDScript = preload("res://addons/WAT/ui/results/method.gd")

var methods: Dictionary = {}
var method_names: PoolStringArray

func _init(_component: TreeItem, data: Dictionary).(_component) -> void:
	set_title(data["name"] if data["title"] == "" else data["title"])
	path = data["path"]
	method_names = data["methods"]

func add_method(tree: Tree, data: Dictionary) -> void:
	var method = MethodTreeItem.new(tree.create_item(component), data["method"], path)
	methods[method.path] = method
	set_total(total + 1)
	tree.scroll_to_item(method.component)

func on_method_finished(data: Dictionary) -> void:
	if data["success"]:
		set_passed(passed + 1)
