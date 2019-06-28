extends PanelContainer
tool

const ICON_SUCCESS: Texture = preload("res://addons/WAT/ui/icons/success.png")
const ICON_FAILED: Texture = preload("res://addons/WAT/ui/icons/failed.png")
const COLOR_SUCCESS: Color = Color(0, 1, 0, 1)
const COLOR_FAILED: Color = Color(1, 1, 1, 1)
const COLOR_CRASHED: Color = Color(1, 1, 0, 1)

var cache: Array = []
var success: bool = false
var crashed: bool = false
var passed: int = 0
var total: int = 0
var icon: Texture

func display(cases: Array) -> void:
	var tree: Tree = $Display
	var root: TreeItem = tree.create_item()
	total = cases.size()

	for c in cases:
		c.calculate()
		passed += int(c.success)
		var case: TreeItem = tree.create_item(root)
		_add_script_data(case, c)

		for m in c.methods:
			var method: TreeItem = tree.create_item(case)
			_add_method_data(method, m)

			for expectation in m.expectations:
				var e: TreeItem = tree.create_item(method)
				_add_expectation_data(e, expectation)

	success = total > 0 and total == passed
	icon = ICON_SUCCESS if success else ICON_FAILED
	root.set_text(0, "%s/%s" % [passed, total])
	root.set_icon(0, icon)
	root.set_custom_color(0, COLOR_SUCCESS if success else COLOR_FAILED)

func _add_script_data(script: TreeItem, data) -> void:
	script.set_text(0, "(%s/%s) %s" % [data.passed, data.total, data.title])
	script.set_icon(0, ICON_SUCCESS if data.success else ICON_FAILED)
	script.set_custom_color(0, COLOR_SUCCESS if data.success else COLOR_FAILED)
	cache.append(script)

func _add_method_data(method: TreeItem, data: Dictionary) -> void:
	method.set_text(0, "(%s/%s) %s" % [data.passed, data.total, data.context])
	method.set_icon(0, ICON_SUCCESS if data.success else ICON_FAILED)
	method.set_custom_color(0, COLOR_SUCCESS if data.success else COLOR_FAILED)
	method.set_tooltip(0, "Source: %s" % data.title)
	method.collapsed = true

func _add_expectation_data(expectation: TreeItem, data) -> void:
	expectation.set_text(0, data.context)
	expectation.set_icon(0, ICON_SUCCESS if data.success else ICON_FAILED)
	expectation.set_custom_color(0, COLOR_SUCCESS if data.success else COLOR_FAILED)
	expectation.set_tooltip(0, "Expected: %s\nResult: %s" % [data.expected, data.result])
	expectation.collapsed = true

func crash(data) -> void:
	print("Crash Not Implemented")
	print("Crash Data Should Not Reach Results?")

func collapse_all(collapse):
	for item in cache:
		item.collapsed = collapse
