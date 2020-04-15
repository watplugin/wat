tool
extends EditorPlugin

var state: int # window state, change names?
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
	state = WAT.Settings.get_window_state(true)
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
	
func _exit_tree() -> void:
	WAT.Settings.destroy_window(self, interface)
	interface.free()
	remove_inspector_plugin(exports)

func connect_signals() -> void:
	_connect(interface, "test_runner_started", self, "_on_test_runner_started")
	_connect(interface, "results_displayed", self, "make_bottom_panel_item_visible", [interface])

func _connect(emitter, event, target, method, binds = []):
	if not emitter.is_connected(event, target, method):
		emitter.connect(event, target, method, binds)

func _process(delta):
	WAT.Settings.change(self, interface)
	
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
