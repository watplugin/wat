tool
extends EditorPlugin

const EditorContext = preload("res://addons/WAT/ui/editor_context.gd")
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
	_FileCache.initialize()
	SystemInitializer.new()
	_ControlPanel = ControlPanel.instance()
	_ControlPanel.EditorContext = EditorContext
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
	_ControlPanel.Results.connect("function_sought", self, "goto_function")
	
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
	ResourceSaver.save("res://addons/WAT/cache/cache.tres", _FileCache._cache)
	
