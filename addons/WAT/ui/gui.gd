tool
extends PanelContainer

var filesystem setget set_fs

onready var Results = $Core/Results

func set_fs(f):
	filesystem = f
	$Core/Menu/TestMenu.filesystem = f
	$Core/Menu/TestMenu.update_menus()
	
func _ready() -> void:
	$Core/Menu/TestMenu.connect("run_pressed", self, "_on_run_pressed")
	$Core/Menu/TestMenu.connect("debug_pressed", self, "_on_debug_pressed")
	
func _on_run_pressed(data = filesystem.root) -> void:
	var tests: Array = data.get_tests()
	Results.display(tests)
	print("run pressed: ", data.path)
	
func _on_debug_pressed(data = filesystem.root) -> void:
	print("debug pressed: ", data.path)

# Resources require tool to work inside the editor whereas..
# ..scripts objects without tool can be called from tool based scripts

#enum { RUN, DEBUG, NONE }
#const XML: Script = preload("res://addons/WAT/editor/junit_xml.gd")
#const PluginAssetsRegistry: Script = preload("res://addons/WAT/ui/plugin_assets_registry.gd")
#const PARCEL = preload("res://addons/WAT/filesystem/test_parcel.gd")
#onready var TestMenu: Button = $Core/Menu/TestMenu
#onready var Results: TabContainer = $Core/Results
#onready var Summary: HBoxContainer = $Core/Summary
#onready var Threads: SpinBox = $Core/Menu/RunSettings/Threads
#onready var Repeats: SpinBox = $Core/Menu/RunSettings/Repeats
#
## Buttons
#onready var RunAll: Button = $Core/Menu/RunAll
#onready var DebugAll: Button = $Core/Menu/DebugAll
#
#onready var ViewMenu: PopupMenu = $Core/Menu/ResultsMenu.get_popup()
#onready var Menu: HBoxContainer = $Core/Menu
#onready var Server: Node = $Server
#
#onready var Core = $Core
#
#var filesystem = load("res://addons/WAT/filesystem/filesystem.gd").new()
#var _plugin: Node
#
#func _ready() -> void:
#	setup_game_context()
#	TestMenu.filesystem = filesystem
#	Threads.max_value = OS.get_processor_count() - 1
#	Threads.min_value = 1
#	Results.connect("function_selected", self, "_on_function_selected")
#	ViewMenu.connect("index_pressed", Results, "_on_view_pressed")
#	TestMenu.connect("tests_selected", self, "_launch")	
#	_connect_run_button(RunAll, RUN, filesystem)
#	_connect_run_button(DebugAll, DEBUG, filesystem)
#	TestMenu.connect("build", self, "_on_build")
#
#func _connect_run_button(run: Button, run_type: int, source: Reference) -> void:
#	run.connect("pressed", self, "_launch", [PARCEL.new(run_type, source)])
#
#func setup_game_context() -> void:
#	if Engine.is_editor_hint():
#		return
#	filesystem.initialize()
#	OS.window_size = ProjectSettings.get_setting("WAT/Window_Size")
#	# No argument makes the AssetsRegistry default to a scale of 1, which
#	# should make every icon look normal when the Tests UI launches
#	# outside of the editor.
#	DebugAll.disabled = true
#	_setup_editor_assets(PluginAssetsRegistry.new())
#
#func _launch(parcel: Object) -> void:
#	var tests: Array = parcel.get_tests()
#	if tests.empty():
#		push_warning("Tests not found")
#		return
#	Results.clear()
#	Summary.time()
#	var results: Array = []
#	match parcel.run_type:
#		RUN:
#			results = yield(_launch_runner(tests, Repeats.value, Threads.value), "completed")
#		DEBUG:
#			results = yield(_launch_debugger(tests, Repeats.value, Threads.value), "completed")
#	Summary.summarize(results)
#	XML.write(results)
#	Results.display(results)
#	filesystem.set_failed(results)
#
#
#func _launch_runner(tests: Array, repeat: int, threads: int) -> Array:
#	var instance = preload("res://addons/WAT/runner/TestRunner.gd").new()
#	add_child(instance)
#	var results: Array = yield(instance.run(tests, repeat, threads), "completed")
#	instance.queue_free()
#	return results
#
#func _launch_debugger(tests: Array, repeat: int, threads: int) -> Array:
#	_plugin.get_editor_interface().play_custom_scene("res://addons/WAT/runner/TestRunner.tscn")
#	if ProjectSettings.get_setting("WAT/Display") == 8:
#		_plugin.make_bottom_panel_item_visible(self)
#	yield(Server, "network_peer_connected")
#	Server.send_tests(tests, repeat, threads)
#	var results: Array = yield(Server, "results_received")
#	_plugin.get_editor_interface().stop_playing_scene()
#	return results
#
## TO BE MOVED SOMEWHERE MORE PROPER
#func setup_editor_context(plugin = null) -> void:
#	_plugin = plugin
#
## Loads scaled assets like icons and fonts
#func _setup_editor_assets(assets_registry = null):
#	pass
#	#Core._setup_editor_assets(assets_registry)
#
#func _on_build(pos) -> void:
#	_plugin.get_editor_interface().play_custom_scene("res://addons/WAT/Empty.tscn")
#	while(_plugin.get_editor_interface().get_playing_scene() == "res://addons/WAT/Empty.tscn"):
#		yield(get_tree(), "idle_frame")
#	TestMenu.display(pos)
#	if ProjectSettings.get_setting("WAT/Display") == 8:
#		_plugin.make_bottom_panel_item_visible(self)
#
#func _on_function_selected(path: String, function: String) -> void:
#	if not _plugin:
#		return
#	var script: Script = load(path)
#	var script_editor = _plugin.get_editor_interface().get_script_editor()
#	_plugin.get_editor_interface().edit_resource(script)
#
#	# We could add this as metadata information when looking for yield times
#	# ..in scripts?
#	var idx: int = 0
#	for line in script.source_code.split("\n"):
#		idx += 1
#		if function in line and line.begins_with("func"):
#			script_editor.goto_line(idx)
#			return
