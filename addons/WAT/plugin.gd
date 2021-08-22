tool
extends EditorPlugin

const Title: String = "Tests"
const GUI: PackedScene = preload("res://addons/WAT/gui.tscn")
const TestPanel: GDScript = preload("res://addons/WAT/ui/gui.gd")
var _test_panel: TestPanel

func _enter_tree() -> void:
	_test_panel = GUI.instance()
	add_control_to_bottom_panel(_test_panel, Title)

func _exit_tree() -> void:
	remove_control_from_bottom_panel(_test_panel)
	_test_panel.queue_free()

#const Title: String = "Tests"
#const Settings: Script = preload("res://addons/WAT/settings.gd")
#const GUI: PackedScene = preload("res://addons/WAT/gui.tscn")
#const Docker: Script = preload("res://addons/WAT/ui/docker.gd")
#const PluginAssetsRegistry: Script = preload("res://addons/WAT/ui/plugin_assets_registry.gd")
#var instance
#var docker: Docker
#var assets_registry = PluginAssetsRegistry.new(self)
#
#func _ready():
#	call_deferred("setup")
#
#func setup():
#	Settings.initialize()
#	_initialize_metadata()
#	instance = GUI.instance()
#	instance.setup_editor_context(self)
#	docker = Docker.new(self, instance)
#	_track_files(instance.filesystem)
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
