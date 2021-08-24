extends Reference

const AssertionTreeItem: GDScript = preload("res://addons/WAT/ui/results/assertion.gd")

var scriptpath: String
var component: TreeItem
var path: String
var title: String
var passed: int = 0
var total: int = 0
var name: String
var assertions: Array = []

func _init(_component: TreeItem, _title: String, _script: String) -> void:
	scriptpath = _script
	component = _component
	path = _title
	name = _title # func name
	title = _title.replace("test_", "").replace("_", " ")
	_component.set_text(0, title) 
	
func add_assertion(tree: Tree, data: Dictionary):
	total += 1
	if data["assertion"]["success"]:
		passed += 1
	component.set_text(0, "%s" % title)
	if data["assertion"]["context"] == "":
		component.collapsed = true
		var expected: TreeItem = tree.create_item(component)
		var actual: TreeItem = tree.create_item(component)
		expected.set_text(0, "EXPECTED: %s" % data["assertion"]["expected"])
		actual.set_text(0, "RESULTED: %s" % data["assertion"]["actual"])
	else:
		var assertion: AssertionTreeItem = AssertionTreeItem.new(tree.create_item(component), data["assertion"])
		assertion.component.collapsed = true
		var expected: TreeItem = tree.create_item(assertion.component)
		var actual: TreeItem = tree.create_item(assertion.component)
		expected.set_text(0, "EXPECTED: %s" % data["assertion"]["expected"])
		actual.set_text(0, "RESULTED: %s" % data["assertion"]["actual"])
		assertion.component.set_custom_color(0, tree.PASSED if assertion.success else tree.FAILED)
		assertion.component.set_icon(0, tree.icons.passed if assertion.success else tree.icons.failed)
		tree.scroll_to_item(assertion.component)
		assertions.append(assertion)
		return assertion
