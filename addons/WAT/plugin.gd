tool
extends EditorPlugin

const TITLE: String = "Tests"
const EditorContext = preload("res://addons/WAT/ui/editor_context.gd")
const ControlPanel: PackedScene = preload("res://addons/WAT/gui.tscn")
const TestMetadataEditor: Script = preload("res://addons/WAT/ui/metadata/editor.gd")
const DockController: Script = preload("ui/dock.gd")

var _ControlPanel: PanelContainer
var _TestMetadataEditor: EditorInspectorPlugin
var _DockController: Node

func get_plugin_name() -> String:
   return "WAT"

func _enter_tree() -> void:
	if not get_tree().root.has_node("WAT"):
		add_autoload_singleton("WAT", "res://addons/WAT/namespace.gd")
	
	WAT.FileManager.initialize()
	
	_ControlPanel = ControlPanel.instance()
	_ControlPanel.EditorContext = EditorContext
	_TestMetadataEditor = TestMetadataEditor.new()
	_DockController = DockController.new(self, _ControlPanel)
	
	add_inspector_plugin(_TestMetadataEditor)
	add_child(_DockController)
	
	_ControlPanel.Results.connect("function_sought", self, "goto_function")
		
func connect_filemanager() -> void:
	var filedock = get_editor_interface().get_file_system_dock()
	filedock.connect("files_moved", WAT.FileManager, "_on_files_moved")
	filedock.connect("file_removed", WAT.FileManager, "_on_files_removed")
	filedock.connect("folder_moved", WAT.FileManager, "_on_folder_moved")
	filedock.connect("folder_removed", WAT.FileManager, "_on_folder_removed")
	
func create_results() -> void:
	var path = ProjectSettings.get_setting("WAT/Results_Directory") + "/Results.tres"
	if not Directory.new().file_exists(path):
		var r = load("res://addons/WAT/cache/results.gd").new()
		ResourceSaver.save(path, r)
	
func goto_function(path: String, function: String):
	var script: Script = load(path)
	get_editor_interface().edit_resource(script)
	var source: PoolStringArray = script.source_code.split("\n")
	for i in source.size():
		if function in source[i] and "describe" in source[i]:
			get_editor_interface().get_script_editor().goto_line(i)
			return

func _exit_tree() -> void:
	_DockController.free()
	_ControlPanel.free()
	remove_inspector_plugin(_TestMetadataEditor)

func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		save()
	
func save() -> void:
	ResourceSaver.save("res://addons/WAT/cache/cache.tres", WAT.FileManager._cache)
	
