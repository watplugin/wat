tool
extends EditorPlugin

var state: int # window state, change names?
const TITLE: String = "Tests"
const UI: PackedScene = preload("res://addons/WAT/Wat.tscn")
const TestMetadataEditor: Script = preload("res://addons/WAT/ui/metadata/exports.gd")
var interface: PanelContainer
var test_metadata_editor: EditorInspectorPlugin
var Window: Reference

func get_plugin_name() -> String:
   return "WAT"

func _enter_tree() -> void:
	interface = UI.instance()
	test_metadata_editor = TestMetadataEditor.new()
	Window = WAT.Settings.Window.new(self, interface)
	Window.construct()
	add_inspector_plugin(test_metadata_editor)
	WAT.Settings.create_test_folder()
	WAT.Settings.create_results_folder()	
	WAT.Settings.set_minimize_on_load()
	
func _exit_tree() -> void:
	Window.deconstruct()
	interface.free()
	remove_inspector_plugin(test_metadata_editor)

func _process(delta):
	Window.update()
