extends PanelContainer
tool

onready var _display = $Display
const _SUCCESS: Color = Color(0, 1, 0, 1)
const _FAILED: Color = Color(1, 1, 1, 1)
const _CRASHED: Color = Color(1, 1, 0, 1)
const _FAILED_ICON: Texture = preload("res://addons/WAT/UI/icons/failed.png")
const _SUCCESS_ICON: Texture = preload("res://addons/WAT/UI/icons/success.png")
const _WARNING_ICON: Texture = preload("res://addons/WAT/UI/icons/warning.png")
var _successes: int = 0
var _total: int = 0
var _root: TreeItem
var _cache: Array = []
var includes_crash: bool = false

func success() -> bool:
	return _successes == _total

func display(cases: Array):
	_cache = []
	_root = _display.create_item()
	_root.set_text(0, "Root")
	_successes = 0
	_total = 0

	for case in cases:
		_display_results(case)

	_root.set_text(1, "%s / %s" % [str(_successes), str(_total)])
	_root.set_custom_color(0, _SUCCESS if _successes == _total else _FAILED)
	_root.set_custom_color(1, _SUCCESS if _successes == _total else _FAILED)

func _display_results(case) -> void:
	_total += 1
	if case.crashed:
		includes_crash = true
		var crash: TreeItem = _display.create_item(_root)
		crash.set_text(0, case.title)
		crash.set_text(1, "Crashed")
		crash.set_custom_color(0, _CRASHED)
		crash.set_custom_color(1, _CRASHED)
		crash.set_icon(0, _WARNING_ICON)

		var crash_data: TreeItem = _display.create_item(crash)
		crash_data.set_text(0, case.crash_data.expected)
		crash_data.set_text(1, case.crash_data.result)
		crash_data.set_custom_color(0, _CRASHED)
		crash_data.set_custom_color(1, _CRASHED)
		crash_data.set_icon(0, _WARNING_ICON)
		_cache.append(crash)
		_root.set_custom_color(0, _CRASHED)
		_root.set_custom_color(1, _CRASHED)
		return
	_successes += 1 if case.success() else 0


	var script: TreeItem = _display.create_item(_root)
#	script.add_button(0, _SUCCESS_ICON)
	script.collapsed = true
	script.set_text(0, case.title)
	script.set_custom_color(0, _SUCCESS if case.success() else _FAILED)
	script.set_custom_color(1, _SUCCESS if case.success() else _FAILED)
	script.set_text(1, "%s / %s" % [str(case.successes()), str(case.total())])
	script.set_icon(0, _SUCCESS_ICON if case.success() else _FAILED_ICON)
	_cache.append(script)

	for method in case.methods:
		var m: TreeItem = _display.create_item(script)
		m.collapsed = true
		m.set_text(0, method.title)
		m.set_custom_color(0, _SUCCESS if method.success() else _FAILED)
		m.set_custom_color(1, _SUCCESS if method.success() else _FAILED)
		m.set_text(1, "%s / %s" % [str(method.successes()), str(method.total())])
		m.set_icon(0, _SUCCESS_ICON if method.success() else _FAILED_ICON)
		_cache.append(m)

		for expectation in method.expectations:
			var context: TreeItem = _display.create_item(m)
			_cache.append(context)
			context.set_text(0, expectation.context)
			context.set_custom_color(0, _SUCCESS if expectation.success else _FAILED)
			context.set_custom_color(1, _SUCCESS if expectation.success else _FAILED)
			var e: TreeItem = _display.create_item(context)
			e.collapsed = true
			e.set_text(0, "Expect: %s" % expectation.expected)
			e.set_text(1, "Result: %s" % expectation.result)
			e.set_custom_color(0, _SUCCESS if expectation.success else _FAILED)
			e.set_custom_color(1, _SUCCESS if expectation.success else _FAILED)
			e.set_icon(0, _SUCCESS_ICON if expectation.success else _FAILED_ICON)
#			_cache.append(e)

func expand_all(expand: bool):
	for item in _cache:
		item.collapsed = !expand