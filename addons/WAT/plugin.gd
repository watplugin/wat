tool
extends EditorPlugin

const TITLE: String = "Tests"
const ControlPanel: PackedScene = preload("res://addons/WAT/Wat.tscn")
const TestMetadataEditor: Script = preload("res://addons/WAT/ui/metadata/exports.gd")
const DockController: Script = preload("system/dock.gd")
const SystemInitializer: Script = preload("system/initializer.gd")

var _ControlPanel: PanelContainer
var _TestMetadataEditor: EditorInspectorPlugin
var _DockController: Node

func get_plugin_name() -> String:
   return "WAT"

func _enter_tree() -> void:
	SystemInitializer.new()
	_ControlPanel = ControlPanel.instance()
	_TestMetadataEditor = TestMetadataEditor.new()
	_DockController = DockController.new(self, _ControlPanel)
	add_child(_DockController)
	add_inspector_plugin(_TestMetadataEditor)
	
	# ???????
	WAT.Settings.set_minimize_on_load()
	
func _exit_tree() -> void:
	_DockController.free()
	_ControlPanel.free()
	remove_inspector_plugin(_TestMetadataEditor)
