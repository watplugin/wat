tool
extends EditorPlugin

var state: int # window state, change names?
const TITLE: String = "Tests"
const RUN_CURRENT_SCENE_GODOT_3_2: int = 39
const RUN_CURRENT_SCENE_GODOT_3_1: int = 33
const UI: PackedScene = preload("res://addons/WAT/Wat.tscn")
const TestMetadataEditor: Script = preload("res://addons/WAT/ui/metadata/exports.gd")
var interface: PanelContainer
var Editor: EditorInterface
var RunCommand: FuncRef
var test_metadata_editor: EditorInspectorPlugin
var Window: Reference

func get_plugin_name() -> String:
   return "WAT"

func _enter_tree() -> void:
	interface = UI.instance()
	Editor = get_editor_interface()
	test_metadata_editor = TestMetadataEditor.new()
	Window = WAT.Settings.Window.new(self, interface)
	Window.construct()
	connect_signals()
	add_inspector_plugin(test_metadata_editor)
	WAT.Settings.create_test_folder()
	WAT.Settings.create_results_folder()	
	WAT.Settings.set_minimize_on_load()
	
func _exit_tree() -> void:
	Window.deconstruct()
	interface.free()
	remove_inspector_plugin(test_metadata_editor)

func connect_signals() -> void:
	_connect(interface, "test_runner_started", self, "_on_test_runner_started")
	_connect(interface, "results_displayed", self, "make_bottom_panel_item_visible", [interface])

func _connect(emitter, event, target, method, binds = []):
	if not emitter.is_connected(event, target, method):
		emitter.connect(event, target, method, binds)

func _process(delta):
	Window.update()

func _on_test_runner_started(test_runner_path: String) -> void:
	Editor.open_scene_from_path(test_runner_path)
	var previous_resource = get_editor_interface().get_script_editor().get_current_script()
	var version = Engine.get_version_info()
	if version.minor == 1:
		_run(RUN_CURRENT_SCENE_GODOT_3_1)
	elif version.minor == 2:
		_run(RUN_CURRENT_SCENE_GODOT_3_2)
	if previous_resource:
		get_editor_interface().edit_resource(previous_resource)

func _run(version: int) -> void:
	Editor.get_parent()._menu_option(version)
