tool
extends Tree

const SUCCESS: Color = Color(0, 1, 0, 1)
const FAILED: Color = Color(1, 1, 1, 1)
var successes: int = 0
var total: int = 0
var _root: TreeItem

var scripts = []
var methods = []

func _expand_all(button):
	# Rushed but very helpful function
	var fold: bool
	if button.text == "Expand Results":
		fold = false
		button.text = "Collapse Results"
	else:
		fold = true
		button.text = "Expand Results"
	for s in scripts:
		if s is TreeItem:
			s.collapsed = fold
	for m in methods:
		if m is TreeItem:
			m.collapsed = fold

	

func _enter_tree() -> void:
	reset()

func reset() -> void:
	clear()
	_root = create_item()
	_root.set_text(0, "Test Root Created")
	
func _display_results(cases: Array):
	scripts = []
	methods = []
	successes = 0
	total = 0
	
	for case in cases:
		display(case)
		
	_root.set_text(1, "%s / %s" % [str(successes), str(total)])
	_root.set_custom_color(0, SUCCESS if successes == total else FAILED)
	_root.set_custom_color(1, SUCCESS if successes == total else FAILED)
	
func display(case) -> void:
	successes += 1 if case.success() else 0
	total += 1
	
	var script: TreeItem = create_item(_root)
	script.collapsed = true
	script.set_text(0, case.title)
	script.set_custom_color(0, SUCCESS if case.success() else FAILED)
	script.set_custom_color(1, SUCCESS if case.success() else FAILED)
	script.set_text(1, "%s / %s" % [str(case.successes()), str(case.total())])
	scripts.append(script)
	
	for method in case.methods:
		var m: TreeItem = create_item(script)
		m.collapsed = true
		m.set_text(0, method.title)
		m.set_custom_color(0, SUCCESS if method.success() else FAILED)
		m.set_custom_color(1, SUCCESS if method.success() else FAILED)
		m.set_text(1, "%s / %s" % [str(method.successes()), str(method.total())])
		methods.append(m)
		
		for expectation in method.expectations:
			var e: TreeItem = create_item(m)
			e.set_text(0, expectation.expected)
			e.set_text(1, expectation.result)
			e.set_custom_color(0, SUCCESS if expectation.success else FAILED)
			e.set_custom_color(1, SUCCESS if expectation.success else FAILED)
