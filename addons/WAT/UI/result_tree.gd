extends PanelContainer
tool

onready var _display = $Display
const _SUCCESS: Color = Color(0, 1, 0, 1)
const _FAILED: Color = Color(1, 1, 1, 1)
var _successes: int = 0
var _total: int = 0
var _root: TreeItem

func display(cases: Array):
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
	_successes += 1 if case.success() else 0
	_total += 1

	var script: TreeItem = _display.create_item(_root)
	script.collapsed = true
	script.set_text(0, case.title)
	script.set_custom_color(0, _SUCCESS if case.success() else _FAILED)
	script.set_custom_color(1, _SUCCESS if case.success() else _FAILED)
	script.set_text(1, "%s / %s" % [str(case.successes()), str(case.total())])

	for method in case.methods:
		var m: TreeItem = _display.create_item(script)
		m.collapsed = true
		m.set_text(0, method.title)
		m.set_custom_color(0, _SUCCESS if method.success() else _FAILED)
		m.set_custom_color(1, _SUCCESS if method.success() else _FAILED)
		m.set_text(1, "%s / %s" % [str(method.successes()), str(method.total())])

		for expectation in method.expectations:
			var e: TreeItem = _display.create_item(m)
			e.set_text(0, expectation.expected)
			e.set_text(1, expectation.result)
			e.set_custom_color(0, _SUCCESS if expectation.success else _FAILED)
			e.set_custom_color(1, _SUCCESS if expectation.success else _FAILED)