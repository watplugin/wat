tool
extends Tree

var tests = []
var root: TreeItem
var scripts: Dictionary = {}

func _ready() -> void:
	hide_root = true
	root = create_item()
	
func add_test(test: Dictionary) -> void: # Script
	var script: ScriptTreeItem = ScriptTreeItem.new(create_item(root), test)
	scripts[script.path] = script
	for title in script.method_names:
		var method: MethodTreeItem = MethodTreeItem.new(create_item(script.component), title)
		script.methods[method.path] = method
		
func add_result(result) -> void:
	print(result)
	
func add_assertion(assertion) -> void:
	#
	pass

class ScriptTreeItem:
	var component: TreeItem
	var path: String
	var title: String
	var methods: Dictionary = {}
	var method_names: PoolStringArray
	
	func _init(_component: TreeItem, data: Dictionary) -> void:
		component = _component
		title = data["name"]
		path = data["path"]
		method_names = data["methods"]
		_component.set_text(0, title)
	
class MethodTreeItem:
	var component: TreeItem
	var path: String
	var title: String
	
	func _init(_component: TreeItem, _title: String) -> void:
		component = _component
		path = _title
		title = _title.replace("test_", "").replace("_", " ")
		_component.set_text(0, title)
	
class AssertionTreeItem:
	# Assertions have to wait until results are finished
	const x = 0
#	print("\n")
#	print(result)
#	print("\n")
	
#class ScriptTreeItem:
#	var instance: TreeItem
#	var methods: Array = [] # TreeItems
#
#	func _init():
#		pass

#var FUNCTION
#var PASSED_ICON
#var FAILED_ICON
#const PASSED: Color = Color(0.34375, 1, 0.34375)
#const FAILED: Color = Color(1, 0.425781, 0.425781)
#signal calculated
#var _parent: TabContainer
#var _results: Array = []
#var _failures: Array = []
#
#func _init(parent: TabContainer) -> void:
#	_parent = parent
#
#func _ready():
#	hide_root = true
#
#func display(cases: Array) -> void:
#	var total = cases.size()
#	var passed = 0
#	var root = create_item()
#
#	for c in cases:
#		passed += c.success as int
#		var script = create_item(root)
#		script.set_text(0, "(%s/%s) %s" % [c.passed, c.total, c.context])
#		script.set_custom_color(0, _color(c.success))
#		script.set_icon(0, _icon(c.success))
#		_results.append(script)
#		if not c.success:
#			_failures.append(script)
#
#		_results.append(script)
#
#		for m in c.methods:
#			var method = create_item(script)
#			method.set_text(0, "%s" % m.context)
#			method.set_custom_color(0, _color(m.success))
#			method.set_icon(0, _icon(m.success))
#			if Engine.is_editor_hint():
#				method.add_button(0, FUNCTION)
#			method.set_tooltip(0, "Click icon to show test method in editor")
#			method.set_meta("path", c.path)
#			method.set_meta("context", m.context)
#			method.set_meta("fullname", m.fullname)
#			_results.append(method)
#			if not m.success:
#				_failures.append(method)
#
#			for a in m.assertions:
#				if a.context != "":
#					method.collapsed = false
#					var assertion = create_item(method)
#					assertion.set_text(0, a.context)
#					assertion.set_custom_color(0, _color(a.success))
#					assertion.set_icon(0, _icon(a.success))
#					assertion.collapsed = true
#					var expected = create_item(assertion)
#					var actual = create_item(assertion)
#					expected.set_text(0, "EXPECTED: %s" % a.expected)
#					actual.set_text(0, "RESULTED: %s" % a.actual)
#					if not a.success:
#						_failures.append(assertion)
#				else:
#					method.collapsed = true
#					var expected = create_item(method)
#					var actual = create_item(method)
#					expected.set_text(0, "EXPECTED: %s" % a.expected)
#					actual.set_text(0, "RESULTED: %s" % a.actual)
#
#
#	var success = total > 0 and total == passed
#	root.set_text(0, "%s/%s" % [passed, total])
#	root.set_custom_color(0, _color(success))
#	root.set_icon(0, _icon(success))
#
#	name += " (%s|%s)" % [passed, total]
#	_parent.set_tab_icon(get_index(), _icon(success))
#
#func _color(success: bool) -> Color:
#	return PASSED if success else FAILED
#
#func _icon(success: bool) -> Texture:
#	return PASSED_ICON if success else FAILED_ICON
#
#func expand_all():
#	for item in _results:
#		item.collapsed = false
#
#func collapse_all():
#	for item in _results:
#		item.collapsed = true
#
#func expand_failures():
#	collapse_all()
#	for item in _failures:
#		item.collapsed = false
#
#func _setup_editor_assets(assets_registry):
#	FUNCTION = assets_registry.load_asset("assets/function.png")
#	PASSED_ICON = assets_registry.load_asset("assets/passed.png")
#	FAILED_ICON = assets_registry.load_asset("assets/failed.png")
