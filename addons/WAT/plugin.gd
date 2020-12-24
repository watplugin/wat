tool
extends EditorPlugin

const TITLE: String = "Tests"
const ControlPanel: PackedScene = preload("res://addons/WAT/gui.tscn")
const TestMetadataEditor: Script = preload("res://addons/WAT/ui/metadata/editor.gd")
const DockController: Script = preload("ui/dock.gd")
const SystemInitializer: Script = preload("initializer.gd")
const FileCache: Script = preload("cache/test_cache.gd")

var _ControlPanel: PanelContainer
var _TestMetadataEditor: EditorInspectorPlugin
var _DockController: Node
var _FileCache = FileCache.new()

func get_plugin_name() -> String:
   return "WAT"

func _enter_tree() -> void:
	SystemInitializer.new()
	_ControlPanel = ControlPanel.instance()
	var filedock = get_editor_interface().get_file_system_dock()
	filedock.connect("files_moved", _FileCache, "_on_files_moved")
	filedock.connect("file_removed", _FileCache, "_on_files_removed")
	filedock.connect("folder_moved", _FileCache, "_on_folder_moved")
	filedock.connect("folder_removed", _FileCache, "_on_folder_removed")
	_ControlPanel.filecache = _FileCache
	_TestMetadataEditor = TestMetadataEditor.new()
	add_inspector_plugin(_TestMetadataEditor)
	_DockController = DockController.new(self, _ControlPanel)
	add_child(_DockController)

	
func _exit_tree() -> void:
	_DockController.free()
	_ControlPanel.free()
	remove_inspector_plugin(_TestMetadataEditor)
	
