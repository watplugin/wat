extends PanelContainer
tool

const ICON_SUCCESS: Texture = preload("res://addons/WAT/ui/icons/success.png")
const ICON_FAILED: Texture = preload("res://addons/WAT/ui/icons/failed.png")
const ICON_CRASH: Texture = preload("res://addons/WAT/ui/icons/crash_warning.png")
const COLOR_SUCCESS: Color = Color(0, 1, 0, 1)
const COLOR_FAILED: Color = Color(1, 1, 1, 1)
const COLOR_CRASHED: Color = Color(1, 1, 0, 1)

var cache: Array = []
var success: bool = false
var crashed: bool = false
var passed: int = 0
var total: int = 0

func display(cases: Array) -> void:
	var tree: Tree = $Display
	var root: TreeItem = tree.create_item()

	for case in cases:
		if case.crashed:
			crash(case)
			return

		case.calculate()
		var c: TreeItem = tree.create_item(root)
		c.set_text(0, case.title)
		c.set_text(1, "%s/%s" % [case.passed, case.total])
		c.set_icon(0, ICON_SUCCESS if case.success else ICON_FAILED)
		c.set_custom_color(0, COLOR_SUCCESS if case.success else COLOR_FAILED)
		c.set_custom_color(1, COLOR_SUCCESS if case.success else COLOR_FAILED)
		cache.append(c)

		for method in case.methods:
			var m: TreeItem = tree.create_item(c)
			m.set_text(0, method.title)
			m.set_text(1, "%s/%s" % [method.passed, method.total])
			m.set_icon(0, ICON_SUCCESS if method.success else ICON_FAILED)
			m.set_custom_color(0, COLOR_SUCCESS if method.success else COLOR_FAILED)
			m.set_custom_color(1, COLOR_SUCCESS if method.success else COLOR_FAILED)
			cache.append(m)

			for expectation in method.expectations:
				var e: TreeItem = tree.create_item(m)
				e.set_text(0, expectation.context)
				e.set_icon(0, ICON_SUCCESS if expectation.success else ICON_FAILED)
				e.set_custom_color(0, COLOR_SUCCESS if expectation.success else COLOR_FAILED)
				e.set_tooltip(0, "Expected: %s\nResult: %s" % [expectation.expected, expectation.result])
				cache.append(e)

		passed += int(case.success)
	total = cases.size()
	success = total > 0 and total == passed
	root.set_text(0, "%s/%s" % [passed, total])
	root.set_custom_color(0, COLOR_SUCCESS if success else COLOR_FAILED)

func crash(data) -> void:
	print("Crash Not Implemented")
#
#func display_crash(case) -> bool:
#	includes_crash = true
#	var crash: TreeItem = _display.create_item(_root)
#	crash.set_text(0, case.title)
#	crash.set_text(1, "Crashed")
#	crash.set_custom_color(0, _CRASHED)
#	crash.set_custom_color(1, _CRASHED)
#	crash.set_icon(0, _WARNING_ICON)
#
#	var crash_data: TreeItem = _display.create_item(crash)
#	crash_data.set_text(0, case.crash_data.expected)
#	crash_data.set_text(1, case.crash_data.result)
#	crash_data.set_custom_color(0, _CRASHED)
#	crash_data.set_custom_color(1, _CRASHED)
#	crash_data.set_icon(0, _WARNING_ICON)
#	_cache.append(crash)
#	_root.set_custom_color(0, _CRASHED)
#	_root.set_custom_color(1, _CRASHED)
#	return false
#
func expand_all(expand: bool):
	print(000)
#	for item in _cache.scripts:
#		item.collapsed = !expand
#	for item in _cache.methods:
#		item.collapsed = !expand
#	for item in _cache.es:
#		item.collapsed = true
