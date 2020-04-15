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
	ProjectSettings.set_setting("WAT/Goto_Test_Method", funcref(self, "goto_function"))
	state = _get_state(true)
	interface = UI.instance()
	exports = EXPORTS.new()
	WAT.Settings.initialize_window(self, interface)
	connect_signals()
	add_inspector_plugin(exports)
	_set_tags()
	WAT.Settings.create_test_folder()
	WAT.Settings.create_results_folder()	
	WAT.Settings.set_minimize_on_load()
	create_goto_function()
	
#func initialize_window(plugin = self, scene = self.interface):
#	if plugin.state == BOTTOM_PANEL:
#		plugin.add_control_to_bottom_panel(scene, "Tests")
#	elif plugin.state < BOTTOM_PANEL:
#		plugin.add_control_to_dock(plugin.state, scene)
#	else:
#		push_warning("Display Option Is Out Of Bounds")
#
#func destroy_window(plugin = self, scene = self.interface):
#	if plugin.state == BOTTOM_PANEL:
#		plugin.remove_control_from_bottom_panel(scene)
#	elif plugin.state < BOTTOM_PANEL:
#		plugin.remove_control_from_docks(scene)
	
func _exit_tree() -> void:
	WAT.Settings.destroy_window(self, interface)
	interface.free()
	remove_inspector_plugin(exports)

func _get_state(first: bool = false) -> int:
	if not ProjectSettings.has_setting("WAT/Display"):
		ProjectSettings.set_setting("WAT/Display", BOTTOM_PANEL)
		var property = {}
		property.name = "WAT/Display"
		property.type = TYPE_INT
		property.hint = PROPERTY_HINT_ENUM
		property.hint_string = PoolStringArray(displays.values()).join(",")
		ProjectSettings.add_property_info(property)
		ProjectSettings.save()
	elif first:
		var property = {}
		property.name = "WAT/Display"
		property.type = TYPE_INT
		property.hint = PROPERTY_HINT_ENUM
		property.hint_string = PoolStringArray(displays.values()).join(",")
		ProjectSettings.add_property_info(property)
		ProjectSettings.save()
	return ProjectSettings.get_setting("WAT/Display")
	
func connect_signals() -> void:
	_connect(interface, "test_runner_started", self, "_on_test_runner_started")
	_connect(interface, "results_displayed", self, "make_bottom_panel_item_visible", [interface])

func _connect(emitter, event, target, method, binds = []):
	if not emitter.is_connected(event, target, method):
		emitter.connect(event, target, method, binds)
	
func _change(plugin = self, scene = self.interface) -> void:
	var new_state = _get_state()
	if new_state == plugin.state:
		return
	var previous_state: int = plugin.state
	
	# Clear Old State
	if previous_state == BOTTOM_PANEL:
#		_remove_as_bottom_panel()
		remove_control_from_bottom_panel(scene)
	elif previous_state < BOTTOM_PANEL:
		remove_control_from_docks(scene)
#		_remove_as_dock()

	# Create New State
	if new_state == BOTTOM_PANEL:
#		_show_as_bottom_panel()
		add_control_to_bottom_panel(scene, "Tests")
	
	elif new_state < BOTTOM_PANEL:
		add_control_to_dock(new_state, scene)
#		_show_as_dock(new_state)

	plugin.state = new_state
	ProjectSettings.set_setting("WAT/Display", new_state)
	ProjectSettings.save()
	
func _process(delta):
	_change()
	
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

func _on_test_runner_started(test_runner_path: String) -> void:
	get_editor_interface().open_scene_from_path(test_runner_path)
	var previous_resource = get_editor_interface().get_script_editor().get_current_script()
	var version = Engine.get_version_info()
	if version.minor == 1:
		get_editor_interface().get_parent()._menu_option(RUN_CURRENT_SCENE_GODOT_3_1)
	elif version.minor == 2:
		get_editor_interface().get_parent()._menu_option(RUN_CURRENT_SCENE_GODOT_3_2)
	if previous_resource:
		get_editor_interface().edit_resource(previous_resource)
