tool
extends PanelContainer


# Resources require tool to work inside the editor whereas..
# ..scripts objects without tool can be called from tool based scripts
const TestRunner: PackedScene = preload("res://addons/WAT/runner/TestRunner.tscn")
const XML: Script = preload("res://addons/WAT/editor/junit_xml.gd")
const PluginAssetsRegistry: Script = preload("res://addons/WAT/ui/plugin_assets_registry.gd")

onready var TestMenu: Button = $Core/Menu/TestMenu
onready var Results: TabContainer = $Core/Results
onready var Summary: HBoxContainer = $Core/Summary
onready var Threads: SpinBox = $Core/Menu/RunSettings/Threads
onready var Repeats: SpinBox = $Core/Menu/RunSettings/Repeats
onready var Quickstart: Button = $Core/Menu/QuickRunAll
onready var QuickstartDebug: Button = $Core/Menu/QuickRunAllDebug
onready var ViewMenu: PopupMenu = $Core/Menu/ResultsMenu.get_popup()
onready var Menu: HBoxContainer = $Core/Menu
onready var Server: Node = $Server

var filesystem = preload("res://addons/WAT/filesystem/filesystem.gd").new()
var instance: Node
var _plugin: Node

func _ready() -> void:
	TestMenu.filesystem = filesystem
	setup_game_context()
	Threads.max_value = OS.get_processor_count() - 1
	Threads.min_value = 1
	Results.connect("function_selected", self, "_on_function_selected")
	ViewMenu.connect("index_pressed", Results, "_on_view_pressed")
	var shortcut = ProjectSettings.get_setting("WAT/Run_All_Tests")
	Quickstart.shortcut.shortcut = shortcut
	Quickstart.connect("pressed", self, "_launch_runner")
	QuickstartDebug.connect("pressed", self, "_launch_debugger")
	TestMenu.connect("tests_selected", self, "_launch_runner")
	TestMenu.connect("tests_selected_debug", self, "_launch_debugger")
	
func setup_game_context() -> void:
	if Engine.is_editor_hint():
		return
	OS.window_size = ProjectSettings.get_setting("WAT/Window_Size")
	# No argument makes the AssetsRegistry default to a scale of 1, which
	# should make every icon look normal when the Tests UI launches
	# outside of the editor.
	QuickstartDebug.disabled = true
	_setup_editor_assets(PluginAssetsRegistry.new())
	
func setup_editor_context(plugin: Node) -> void:
	_plugin = plugin
	var file_dock: Node = plugin.get_editor_interface().get_file_system_dock()
	for event in ["folder_removed", "folder_moved", "file_removed"]:
		file_dock.connect(event, filesystem, "_on_filesystem_changed", [], CONNECT_DEFERRED)
	file_dock.connect("files_moved", filesystem, "_on_file_moved")
	_plugin.connect("resource_saved", filesystem, "_on_resource_saved", [], CONNECT_DEFERRED)
	
func _on_function_selected(path: String, function: String) -> void:
	if not _plugin:
		return
	var script: Script = load(path)
	var script_editor = _plugin.get_editor_interface().get_script_editor()
	_plugin.get_editor_interface().edit_resource(script)
	
	# We could add this as metadata information when looking for yield times
	# ..in scripts?
	var idx: int = 0
	for line in script.source_code.split("\n"):
		idx += 1
		if function in line and line.begins_with("func"):
			script_editor.goto_line(idx)
			return

func _repeat(tests: Array, repeat: int) -> Array:
	var duplicates: Array = []
	for idx in repeat:
		for test in tests:
			duplicates.append(test)
	duplicates += tests
	return duplicates

func _launch_runner(tests: Array = filesystem.get_tests(), threads: int = Threads.value) -> void:
	# This is also the launch method used for exported scenes
	if tests.empty():
		push_warning("Tests Are Empty!")
		return
	Results.clear()
	Summary.time()
	tests = _repeat(tests, Repeats.value)
	instance = TestRunner.instance()
	add_child(instance)
	var results = yield(instance.run(tests, threads), "completed")
	instance.queue_free()
	_on_run_completed(results)
	
	
const RUN_CURRENT_SCENE_GODOT_3_2: int = 39
const RUN_CURRENT_SCENE_GODOT_3_1: int = 33
func _launch_debugger(tests: Array = filesystem.get_tests(), threads: int = Threads.value) -> void:
	
	if tests.empty():
		push_warning("Tests Are Empty!")
		return
	Results.clear()
	Summary.time()
	tests = _repeat(tests, Repeats.value)
	
	var version = Engine.get_version_info()
	var editor = _plugin.get_editor_interface()
	if editor.has_method("play_custom_scene"):
		editor.play_custom_scene("res://addons/WAT/runner/TestRunner.tscn")
	else:
		var run = RUN_CURRENT_SCENE_GODOT_3_1 if version.minor == 1 else RUN_CURRENT_SCENE_GODOT_3_2
		editor.open_scene_from_path("res://addons/WAT/runner/TestRunner.tscn")
		editor.get_parent()._menu_option(RUN_CURRENT_SCENE_GODOT_3_2)
	_plugin.make_bottom_panel_item_visible(self)
	
	yield(Server, "network_peer_connected")
	Server.send_tests(tests, threads)
	var results = yield(Server, "results_received")
	_on_run_completed(results)
	
func _on_run_completed(results: Array) -> void:
	Summary.summarize(results)
	XML.write(results)
	Results.display(results)
	filesystem.set_failed(results)
	
# Loads scaled assets like icons and fonts
func _setup_editor_assets(assets_registry):
	Summary._setup_editor_assets(assets_registry)
	Results._setup_editor_assets(assets_registry)
#	TestMenu._setup_editor_assets(assets_registry)
	Quickstart.icon = assets_registry.load_asset(Quickstart.icon)
	QuickstartDebug.icon = assets_registry.load_asset(QuickstartDebug.icon)
