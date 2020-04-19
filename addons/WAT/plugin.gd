tool
extends EditorPlugin

var state: int # Dock state, change names?
const TITLE: String = "Tests"
const UI: PackedScene = preload("res://addons/WAT/Wat.tscn")
const TestMetadataEditor: Script = preload("res://addons/WAT/ui/metadata/exports.gd")
var interface: PanelContainer
var test_metadata_editor: EditorInspectorPlugin
var Dock: Node
var IO: Reference

func get_plugin_name() -> String:
   return "WAT"

func _enter_tree() -> void:
	interface = UI.instance()
	test_metadata_editor = TestMetadataEditor.new()
	WAT.Settings.add_templates()
	IO = WAT.Settings.IO.new()
	Dock = WAT.Settings.Dock.new(self, interface)
	add_child(Dock)
	add_inspector_plugin(test_metadata_editor)
	WAT.Settings.set_minimize_on_load()
	
func _exit_tree() -> void:
	Dock.free()
	interface.free()
	remove_inspector_plugin(test_metadata_editor)
