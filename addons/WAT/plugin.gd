tool
extends EditorPlugin

const TITLE: String = "Tests"
const Global: String = "res://addons/WAT/globals/namespace.gd"
const ControlPanel: PackedScene = preload("res://addons/WAT/gui.tscn")
const DockController: Script = preload("ui/dock.gd")

var _ControlPanel: PanelContainer
var _DockController: Node

func get_plugin_name() -> String:
   return "WAT"

func _enter_tree() -> void:
	WAT.Settings.initialize()

	_ControlPanel = ControlPanel.instance()
	_DockController = DockController.new(self, _ControlPanel)
	
	add_child(_DockController)
	
	_ControlPanel.Results.connect("function_sought", self, "goto_function")
	connect_filemanager(_ControlPanel.get_node("GUI/Interact").TestMenu.Tests)
		
func connect_filemanager(filemanager) -> void:
	var filedock = get_editor_interface().get_file_system_dock()
	filedock.connect("files_moved", filemanager, "_on_files_moved")
	filedock.connect("file_removed", filemanager, "_on_file_removed")
	filedock.connect("folder_moved", filemanager, "_on_folder_moved")
	filedock.connect("folder_removed", filemanager, "_on_folder_removed")
	
func disconnect_filemanager(filemanager) -> void:
	var filedock = get_editor_interface().get_file_system_dock()
	filedock.disconnect("files_moved", filemanager, "_on_files_moved")
	filedock.disconnect("file_removed", filemanager, "_on_file_removed")
	filedock.disconnect("folder_moved", filemanager, "_on_folder_moved")
	filedock.disconnect("folder_removed", filemanager, "_on_folder_removed")
	
func goto_function(path: String, function: String):
	var script: Script = load(path)
	get_editor_interface().edit_resource(script)
	var source: PoolStringArray = script.source_code.split("\n")
	for i in source.size():
		if function in source[i]:
			get_editor_interface().get_script_editor().goto_line(i)
			return

func _exit_tree() -> void:
	disconnect_filemanager(_ControlPanel.get_node("GUI/Interact").TestMenu.Tests)
	_DockController.free()
	_ControlPanel.free()
	
