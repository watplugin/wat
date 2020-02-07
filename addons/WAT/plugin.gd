tool
extends EditorPlugin

# Add Ability To Refresh/Update (May Not Need To Remove Plugin)
var displays: Dictionary = {
	0: "Left.UL Dock",
	1: "Left.BL Dock",
	2: "Left.UR Dock",
	3: "Left.BR Dock",
	4: "Right.UL Dock",
	5: "Right.BL Dock",
	6: "Right.UR Dock",
	7: "Right.BR Dock",
	8: "Bottom Panel",
}

enum {
	LEFT_UPPER_LEFT,
	LEFT_BOTTOM_LEFT,
	LEFT_UPPER_RIGHT,
	LEFT_BOTTOM_RIGHT,
	RIGHT_UPPER_LEFT,
	RIGHT_BOTTOM_LEFT,
	RIGHT_UPPER_RIGHT,
	RIGHT_BOTTOM_RIGHT,
	BOTTOM_PANEL,
	# MainWindow Option Here
	OUT_OF_BOUNDS
}

var state: int
const TITLE: String = "Tests"
const RUN_CURRENT_SCENE_GODOT_3_2: int = 39
const RUN_CURRENT_SCENE_GODOT_3_1: int = 33
const UI: PackedScene = preload("res://addons/WAT/Wat.tscn")
const EXPORTS: Script = preload("res://addons/WAT/ui/metadata/exports.gd")
var interface: PanelContainer
var exports

func get_plugin_name() -> String:
   return "WAT"

func _enter_tree() -> void:
	state = _get_state()
	interface = UI.instance()
	exports = EXPORTS.new()
	if state == BOTTOM_PANEL:
		_show_as_bottom_panel()
	elif state < BOTTOM_PANEL:
		_show_as_dock(state)
	else:
		push_warning("Display Option Is Out Of Bounds")
	connect_signals()
	add_inspector_plugin(exports)
	_set_tags()
	_create_test_folder()
	create_goto_function()
	
func _exit_tree() -> void:
	if _get_state() == BOTTOM_PANEL:
		_remove_as_bottom_panel()
	elif _get_state() < BOTTOM_PANEL:
		_remove_as_dock()
	interface.free()
	remove_inspector_plugin(exports)

func _get_state() -> int:
	if not ProjectSettings.has_setting("WAT/Display"):
		ProjectSettings.set_setting("WAT/Display", BOTTOM_PANEL)
	var property = {}
	property.name = "WAT/Display"
	property.type = TYPE_INT
	property.hint = PROPERTY_HINT_ENUM
	property.hint_string = PoolStringArray(displays.values()).join(",")
	ProjectSettings.add_property_info(property)
	ProjectSettings.save()
	return ProjectSettings.get_setting("WAT/Display")
	
func _show_as_bottom_panel() -> void:
	add_control_to_bottom_panel(interface, "Tests")
	ProjectSettings.set_setting("WAT/Goto_Test_Method", funcref(self, "goto_function"))
	
func _show_as_dock(slot: int) -> void:
	add_control_to_dock(slot, interface)
	
func _remove_as_bottom_panel() -> void:
	remove_control_from_bottom_panel(interface)
	
func _remove_as_dock() -> void:
	remove_control_from_docks(interface)
	
func connect_signals() -> void:
	_connect(interface, "test_runner_started", self, "_on_test_runner_started")
	_connect(interface, "results_displayed", self, "make_bottom_panel_item_visible", [interface])

func _connect(emitter, event, target, method, binds = []):
	if not emitter.is_connected(event, target, method):
		emitter.connect(event, target, method, binds)
	
func _change(new_state: int) -> void:
	var previous_state: int = state
	
	# Clear Old State
	if previous_state == BOTTOM_PANEL:
		_remove_as_bottom_panel()
	elif previous_state < BOTTOM_PANEL:
		_remove_as_dock()

	# Create New State
	if new_state == BOTTOM_PANEL:
		_show_as_bottom_panel()
	elif new_state < BOTTOM_PANEL:
		_show_as_dock(new_state)

	state = new_state
	ProjectSettings.set_setting("WAT/Display", new_state)
	ProjectSettings.save()
	
func _process(delta):
	if state != _get_state():
		_change(_get_state())
	
func _set_tags() -> void:
	if ProjectSettings.has_setting("WAT/Tags"):
		return
	var tags: PoolStringArray = []
	var property_info: Dictionary = {
		"name": "WAT/Tags",
		"type": TYPE_STRING_ARRAY,
		"hint_string": "Defines Tags to group Tests"
	}
	ProjectSettings.set("WAT/Tags", tags)
	ProjectSettings.add_property_info(property_info)
	
func create_goto_function() -> void:
	if not ProjectSettings.has_setting("WAT/Goto_Test_Method"):
		ProjectSettings.set_setting("WAT/Goto_Test_Method", funcref(self, "goto_functions"))
	
func goto_function(path: String, function: String) -> void:
	var script: Script = load(path)
	get_editor_interface().edit_resource(script)
	var source: PoolStringArray = script.source_code.split("\n")
	for i in source.size():
		if function in source[i] and "describe" in source[i]:
			get_editor_interface().get_script_editor().goto_line(i)
			return

func _create_test_folder() -> void:
	var title: String = "WAT/Test_Directory"
	if not ProjectSettings.has_setting(title):
		var property_info: Dictionary = {"name": title, "type": TYPE_STRING, "hint_string": "Store your WATTests here"}
		ProjectSettings.set(title, "res://tests")
		ProjectSettings.add_property_info(property_info)
		push_warning("Set Test Directory to 'res://tests'. You can change this in Project -> Project Settings -> General -> WAT")
		return

func _on_test_runner_started(test_runner_path: String) -> void:
	print(test_runner_path)
	get_editor_interface().open_scene_from_path(test_runner_path)
	var version = Engine.get_version_info()
	if version.major == 3 and version.minor == 1:
		get_editor_interface().get_parent()._menu_option(RUN_CURRENT_SCENE_GODOT_3_1)
	elif version.major == 3 and version.minor == 2:
		get_editor_interface().get_parent()._menu_option(RUN_CURRENT_SCENE_GODOT_3_2)
