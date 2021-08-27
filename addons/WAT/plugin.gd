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
	var build: FuncRef = funcref(self, "_build_function")
	_file_system = FileSystem.new(build)
	_file_tracker = FileTracker.new(_file_system)
	Metadata.load_metadata(_file_system)
	_assets_registiry = PluginAssetsRegistry.new(self)
	_file_tracker.start_tracking_files(self)
	_test_panel = GUI.instance()
	_test_panel.setup_editor_context(self, build, funcref(self, "goto_function"), _file_system)
	_panel_docker = TestPanelDocker.new(self, _test_panel)
	add_child(_panel_docker)

func _exit_tree() -> void:
	Metadata.save_metadata(_file_system)
	_panel_docker.queue_free()
	if(is_instance_valid(_test_panel)):
		_test_panel.queue_free()
	
func _build_function() -> bool:
	_test_panel.Results.clear()
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
