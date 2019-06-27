extends PanelContainer
tool

class Cache:
	var scripts: Array = []
	var methods: Array = []
	var contexts: Array = []
	var expectations: Array = []

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
var _cache: Cache
var includes_crash: bool = false

func success() -> bool:
	return _successes == _total

func display(cases: Array):
	_cache = Cache.new()
	_root = _display.create_item()
	_root.set_text(0, "Root")
	_successes = 0
	_total = 0

	for case in cases:
		case.calculate()
		_display_results(case)

	_root.set_text(1, "%s / %s" % [str(_successes), str(_total)])
	_root.set_custom_color(0, _SUCCESS if _successes == _total else _FAILED)
	_root.set_custom_color(1, _SUCCESS if _successes == _total else _FAILED)

func _display_results(case) -> void:
	_total += 1
	if case.crashed:
		display_crash(case)
		return
	_successes += 1 if case.success else 0

	var script: TreeItem = _display.create_item(_root)
	_cache.scripts.append(script)
	add_result(script, case, case.title)
	script.set_text(1, "%s / %s" % [str(case.passed), str(case.total)])

	for method in case.methods:
		var m: TreeItem = _display.create_item(script)
		_cache.methods.append(m)
		add_result(m, method, method.title)
		m.set_text(1, "%s / %s" % [str(method.passed), str(method.total)])

		for expectation in method.expectations:
			var context: TreeItem = _display.create_item(m)
			_cache.contexts.append(context)
			add_result(context, expectation, expectation.context)
			context.set_tooltip(0, "Expected: " + expectation.expected + "\n" +  "Result: " + expectation.result)

func add_result(item: TreeItem, data, text) -> void:
	item.set_text(0, text)
	item.set_custom_color(0, _SUCCESS if data.success else _FAILED)
	item.set_custom_color(1, _SUCCESS if data.success else _FAILED)
	item.set_icon(0, _SUCCESS_ICON if data.success else _FAILED_ICON)
	item.collapsed = true

func display_crash(case) -> bool:
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
	return false

func expand_all(expand: bool):
	for item in _cache.scripts:
		item.collapsed = !expand
	for item in _cache.methods:
		item.collapsed = !expand
	for item in _cache.contexts:
		item.collapsed = true
