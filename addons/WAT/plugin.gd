tool
extends EditorPlugin

const Title: String = "Tests"
const GUI: PackedScene = preload("res://addons/WAT/gui.tscn")
const TestPanel: GDScript = preload("res://addons/WAT/ui/gui.gd")
const TestPanelDocker: GDScript = preload("res://addons/WAT/ui/docker.gd")
const FileSystem: GDScript = preload("res://addons/WAT/filesystem/filesystem.gd")
const FileTracker: GDScript = preload("res://addons/WAT/filesystem/tracker.gd")
const Settings: GDScript = preload("res://addons/WAT/settings.gd")
const Metadata: GDScript = preload("res://addons/WAT/io/metadata.gd")
const PluginAssetsRegistry: GDScript = preload("res://addons/WAT/ui/scaling/plugin_assets_registry.gd")
var _test_panel: TestPanel
var _file_system: FileSystem
var _file_tracker: FileTracker
var _assets_registiry: PluginAssetsRegistry
var _panel_docker:  TestPanelDocker

func _enter_tree() -> void:
	Settings.initialize()
	_file_system = FileSystem.new()
	_file_tracker = FileTracker.new(_file_system)
	Metadata.load_metadata(_file_system)
	_assets_registiry = PluginAssetsRegistry.new(self)
	_file_tracker.start_tracking_files(self)
	_test_panel = GUI.instance()
	_test_panel.setup_editor_context(self, funcref(self, "goto_function"), _file_system)
	_panel_docker = TestPanelDocker.new(self, _test_panel)
	add_child(_panel_docker)

func _exit_tree() -> void:
	Metadata.save_metadata(_file_system)
	_panel_docker.queue_free()
	if(is_instance_valid(_test_panel)):
		_test_panel.queue_free()

	
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
