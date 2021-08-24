tool
extends Tree

const ScriptTreeItem: GDScript = preload("res://addons/WAT/ui/results/script.gd")
const MethodTreeItem: GDScript = preload("res://addons/WAT/ui/results/method.gd")
const AssertionTreeItem: GDScript = preload("res://addons/WAT/ui/results/assertion.gd")

var tests = []
var root: TreeItem
var scripts: Dictionary = {}
var current_method: MethodTreeItem
var icons: Reference
var failed: bool = false
var goto_function: FuncRef

func _init(_icons: Reference) -> void:
	icons = _icons
	if Engine.is_editor_hint():
		connect("button_pressed", self, "_on_button_pressed")
	
func _on_button_pressed(item: TreeItem, col: int = 0, id: int = 0) -> void:
	var data: MethodTreeItem = item.get_meta("data")
	goto_function.call_func(data.scriptpath, data.name)

func _ready() -> void:
	visible = false
	hide_root = true
	root = create_item()
	add_constant_override("Scroll Speed", 24)
	
const PASSED: Color = Color(0.34375, 1, 0.34375)
const FAILED: Color = Color(1, 0.425781, 0.425781)

func add_result(result) -> void:
	var script: ScriptTreeItem = scripts[result["path"]]
	var success: bool = result["success"]
	script.component.set_custom_color(0, PASSED if success else FAILED)
	script.component.set_icon(0, icons.passed if success else icons.failed)
	failed = not success
	scroll_to_item(root)

# TODO: All of these dict values should be serialized and unserialized at server points
# ..or sent directly if run in the editor but point is objects > dicts
func add_test(test) -> void:
	var script: ScriptTreeItem = ScriptTreeItem.new(create_item(root), test)
	scripts[script.path] = script
	# Scrolling to a Script Component hides the scroll bar so don't

func add_method(data: Dictionary) -> void:
	var script: ScriptTreeItem = scripts[data["path"]]
	script.add_method(self, data)
	var method: MethodTreeItem = script.methods.values().back()
	if Engine.is_editor_hint():
		method.component.add_button(0, icons.function)
		method.component.set_tooltip(0, "Click function icon to show test method in editor")
		method.component.set_meta("data", method)

func add_assertion(data: Dictionary) -> void:
	var script: ScriptTreeItem = scripts[data["path"]]
	var method: MethodTreeItem = script.methods[data["method"]]
	var assertion_maybe = method.add_assertion(self, data)
	if not data["assertion"]["success"]:
		script.component.set_custom_color(0, FAILED)
		script.component.set_icon(0, icons.failed)
		method.component.set_custom_color(0, FAILED)
		method.component.set_icon(0, icons.failed)
		if assertion_maybe != null:
			_failures.append(assertion_maybe.component)
		failed = true
	
func on_test_method_described(data: Dictionary) -> void:
	scripts[data["path"]].methods[data["method"]].component.set_text(0, data["description"])
	
func on_test_script_finished(data: Dictionary) -> void:
	# On a finished test, change its color
	var script: ScriptTreeItem = scripts[data["path"]]
	var success: bool = data["success"]
	script.component.set_custom_color(0, PASSED if success else FAILED)
	script.component.set_icon(0, icons.passed if success else icons.failed)
	_results.append(script.component)
	if not success:
		_failures.append(script.component)
	
func on_test_method_finished(data: Dictionary) -> void:
	# On a finished method, change its color
	var script: ScriptTreeItem = scripts[data["path"]]
	var method: MethodTreeItem = script.methods[data["method"]]
	script.on_method_finished(data)
	_results.append(method.component)
	if not data["success"]:
		script.component.set_custom_color(0, FAILED)
		script.component.set_icon(0, icons.failed)
		failed = true
		_failures.append(method.component)
	method.component.set_custom_color(0, PASSED if data["success"] else FAILED)
	method.component.set_icon(0, icons.passed if data["success"] else icons.failed)
	method.component.collapsed = true
	scroll_to_item(method.component)

var _results: Array = []
var _failures: Array = []

func expand_all() -> void:
	for item in _results:
		item.collapsed = false
	
func collapse_all() -> void:
	for item in _results:
		item.collapsed = true
	
func expand_failures() -> void:
	collapse_all()
	for item in _failures:
		item.collapsed = false
