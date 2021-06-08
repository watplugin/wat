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
	docker = Docker.new(self, instance)
	instance.setup_editor_context(self)
	add_child(docker)
	yield(get_tree().create_timer(0.5), "timeout")
	
func _exit_tree():
	docker.free()
	instance.free()
	
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
