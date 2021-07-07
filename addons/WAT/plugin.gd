tool
extends EditorPlugin


const Title: String = "Tests"
const Settings: Script = preload("res://addons/WAT/settings.gd")
const GUI: PackedScene = preload("res://addons/WAT/gui.tscn")
const Docker: Script = preload("res://addons/WAT/ui/docker.gd")
const PluginAssetsRegistry: Script = preload("res://addons/WAT/ui/plugin_assets_registry.gd")
var instance: Control
var docker: Docker
var assets_registry = PluginAssetsRegistry.new(self)

func _ready():
	# Editor assets must be setup at ready time to give GUI scripts a chance to 
	# ready themselves first and store references to other nodes, which will be 
	# needed to call_setup_editor_assets() on.
	instance._setup_editor_assets(assets_registry)

func _enter_tree():
	Settings.initialize()
	_initialize_metadata()
	instance = GUI.instance()
	instance.setup_editor_context(self)
	docker = Docker.new(self, instance)
	_track_files(instance.filesystem)
	add_child(docker)
	yield(get_tree().create_timer(0.5), "timeout")
	
func _exit_tree():
	docker.free()
	instance.free()
	
func _track_files(filesystem: WAT.FileSystem) -> void:
	var file_dock: Node = get_editor_interface().get_file_system_dock()
	for event in ["folder_removed", "folder_moved", "file_removed"]:
		file_dock.connect(event, filesystem, "_on_filesystem_changed", [], CONNECT_DEFERRED)
	file_dock.connect("files_moved", filesystem, "_on_file_moved")
	connect("resource_saved", filesystem, "_on_resource_saved", [], CONNECT_DEFERRED)
	
func _initialize_metadata() -> void:
	# Check if file exists!
	var path: String = ProjectSettings.get_setting("WAT/Test_Metadata_Directory")
	if Directory.new().file_exists(path + "/test_metadata.json"):
		return
	var file: File = File.new()
	var err: int = file.open(path + "/test_metadata.json", File.WRITE)
	if err != OK:
		push_warning(err as String)
		return
	file.store_string("{}")
	file.close()
