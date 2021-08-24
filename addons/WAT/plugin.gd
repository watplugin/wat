tool
extends EditorPlugin

const Title: String = "Tests"
const GUI: PackedScene = preload("res://addons/WAT/gui.tscn")
const TestPanel: GDScript = preload("res://addons/WAT/ui/gui.gd")
const TestPanelDocker: GDScript = preload("res://addons/WAT/ui/docker.gd")
const FileSystem: GDScript = preload("res://addons/WAT/filesystem/filesystem.gd")
const FileTracker: GDScript = preload("res://addons/WAT/filesystem/tracker.gd")
const Settings: GDScript = preload("res://addons/WAT/settings.gd")
const PluginAssetsRegistry: GDScript = preload("res://addons/WAT/ui/scaling/plugin_assets_registry.gd")
var _test_panel: TestPanel
var _file_system: FileSystem
var _file_tracker: FileTracker
var _assets_registiry: PluginAssetsRegistry
var _panel_docker:  TestPanelDocker

func _enter_tree() -> void:
	Settings.initialize()
	var build: FuncRef = funcref(self, "_build_function")
	_file_system = FileSystem.new(build)
	_file_tracker = FileTracker.new(_file_system)
	_assets_registiry = PluginAssetsRegistry.new(self)
	_file_tracker.start_tracking_files(self)
	_test_panel = GUI.instance()
	_test_panel.setup_editor_context(self, build, funcref(self, "goto_function"), _file_system)
	_panel_docker = TestPanelDocker.new(self, _test_panel)
	add_child(_panel_docker)

func _exit_tree() -> void:
	_panel_docker.queue_free()
	_test_panel.queue_free()
	
func _build_function() -> bool:
	var text: String = "FileSystem has been changed since last build."
	text += "\nTriggering a Build by launching an Empty Scene."
	text += "\nPlease select your option again after the scene quits."
	OS.alert(text, "Build Required")
	var editor: EditorInterface = get_editor_interface()
	editor.play_custom_scene("res://addons/WAT/mono/BuildScene.tscn")
	while editor.is_playing_scene():
		yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	_file_system.update()
	_file_system.changed = false
	make_bottom_panel_item_visible(_test_panel)
	return true
	
func goto_function(path: String, function: String) -> void:
	var script: Script = load(path)
	var script_editor: ScriptEditor = get_editor_interface().get_script_editor()
	get_editor_interface().edit_resource(script)
	var idx: int = 0
	for line in script.source_code.split("\n"):
		idx += 1
		if function in line and line.begins_with("func"):
			script_editor.goto_line(idx)
			return
	

#const Docker: Script = preload("res://addons/WAT/ui/docker.gd")
#const PluginAssetsRegistry: Script = preload("res://addons/WAT/ui/plugin_assets_registry.gd")
#var docker: Docker
#var assets_registry = PluginAssetsRegistry.new(self)
#
#func _ready():
#	call_deferred("setup")
#
#func setup():
#	Settings.initialize()
#	_initialize_metadata()
#	instance.setup_editor_context(self)
#	docker = Docker.new(self, instance)
#	add_child(docker)
##	get_editor_interface().play_custom_scene("res://addons/WAT/Empty.tscn")
##	while get_editor_interface().get_playing_scene() == "res://addons/WAT/Empty.tscn":
##		yield(get_tree(), "idle_frame")
#	instance.filesystem.call_deferred("initialize")
#	instance._setup_editor_assets(assets_registry)
#
#
#func _exit_tree():
#	#_save_metadata()
#	docker.free()
#	instance.free()
##
#func _track_files(filesystem) -> void:
#	var file_dock: Node = get_editor_interface().get_file_system_dock()
#	for event in ["folder_removed", "folder_moved", "file_removed"]:
#		file_dock.connect(event, filesystem, "_on_filesystem_changed", [], CONNECT_DEFERRED)
#	file_dock.connect("files_moved", filesystem, "_on_file_moved")
#	connect("resource_saved", filesystem, "_on_resource_saved", [], CONNECT_DEFERRED)
#
## These functions cause an error and sometimes make the plugin fail to load
#func _initialize_metadata() -> void:
#	# Check if file exists!
#	var path: String = ProjectSettings.get_setting("WAT/Test_Metadata_Directory") + "/test_metadata.tres"
#	if Directory.new().file_exists(path):
#		return
#	var res = load("res://addons/WAT/metadata.gd").new()
#	var err = ResourceSaver.save(path, res)
#	if err != OK:
#		push_warning("Error saving test metadata to %s : %s" % [path, err as String])
#		return
##
## 
#func _save_metadata() -> void:
#	var path = ProjectSettings.get_setting("WAT/Test_Metadata_Directory") + "/test_metadata.tres"
#	var err = ResourceSaver.save(path, instance.filesystem.resource)
#	if err != OK:
#		push_warning("Error saving test metadata to %s : %s" % [path, err as String])
#
