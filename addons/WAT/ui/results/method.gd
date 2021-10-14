extends "res://addons/WAT/ui/results/counter.gd"

const AssertionTreeItem: GDScript = preload("res://addons/WAT/ui/results/assertion.gd")

var scriptpath: String
var name: String
var assertions: Array = []

func _init(_component: TreeItem, _title: String, _script: String).(_component) -> void:
	scriptpath = _script
	path = _title
	name = _title # func name
	set_title(_title.replace("test_", "").replace("_", " "))
	show = false # Modify if test method results should display number of assertions passed.
	
func add_assertion(tree: Tree, data: Dictionary):
	set_total(total + 1)
	if data["assertion"]["success"]:
		set_passed(passed + 1)
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
