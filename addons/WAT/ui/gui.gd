tool
extends PanelContainer

onready var RunAll: Button = $Core/Menu/RunAll
onready var DebugAll: Button = $Core/Menu/DebugAll
onready var TestMenu: Button = $Core/Menu/TestMenu
onready var Results: TabContainer = $Core/Results
onready var Summary: HBoxContainer = $Core/Summary
onready var Threads: SpinBox = $Core/Menu/RunSettings/Threads
onready var Repeats: SpinBox = $Core/Menu/RunSettings/Repeats

var _icons: Reference 
var _filesystem
var _plugin = null
var _build: FuncRef

#	TestMenu.filesystem = filesystem
#	Threads.max_value = OS.get_processor_count() - 1
#	Threads.min_value = 1

func _ready() -> void:
	_icons = preload("res://addons/WAT/ui/scaling/icons.gd").new()
	TestMenu.icons = _icons
	Results.icons = _icons 

	if not Engine.is_editor_hint():
		_setup_scene_context()
	Threads.max_value = OS.get_processor_count() - 1
	RunAll.connect("pressed", self, "_on_run_pressed")
	DebugAll.connect("pressed", self, "_on_debug_pressed")
	TestMenu.connect("run_pressed", self, "_on_run_pressed", [], CONNECT_DEFERRED)
	TestMenu.connect("debug_pressed", self, "_on_debug_pressed", [], CONNECT_DEFERRED)
	
func _setup_scene_context() -> void:
	load("res://addons/WAT/ui/scaling/scene_tree_adjuster.gd").adjust(self, _icons)
	_filesystem = load("res://addons/WAT/filesystem/filesystem.gd").new()
	TestMenu.filesystem = _filesystem
	_filesystem.update()
	TestMenu.update_menus()
	DebugAll.disabled = true
	
func setup_editor_context(plugin, build: FuncRef, goto_func: FuncRef, filesystem: Reference) -> void:
	yield(self, "ready")
	load("res://addons/WAT/ui/scaling/scene_tree_adjuster.gd").adjust(self, _icons, plugin)
	_plugin = plugin
	_filesystem = filesystem
	_build = build
	Results.goto_function = goto_func
	TestMenu.filesystem = _filesystem
	_filesystem.update()
	TestMenu.update_menus()
	
func _on_run_pressed(data = _filesystem.root) -> void:
	if _filesystem.changed:
		if not _filesystem.built and ClassDB.class_exists("CSharpScript") and Engine.is_editor_hint():
			Results.clear()
			_filesystem.built = yield(_filesystem.build_function.call_func(), "completed")
			return
		if data == _filesystem.root:
			_filesystem.update()
			data = _filesystem.root # New Root
	Summary.time()
	yield(get_tree(), "idle_frame")
	var tests: Array = data.get_tests()
	Results.display(tests, Repeats.value)
	var instance = preload("res://addons/WAT/runner/TestRunner.gd").new()
	add_child(instance)
	var results: Array = yield(instance.run(tests, Repeats.value, Threads.value, Results), "completed")
	instance.queue_free()
	Summary.summarize(results)
	
func _on_debug_pressed(data = _filesystem.root) -> void:
	print("debug pressed: ", data.path)


#const XML: Script = preload("res://addons/WAT/editor/junit_xml.gd")
#onready var ViewMenu: PopupMenu = $Core/Menu/ResultsMenu.get_popup()
#onready var Server: Node = $Server

#
#func _ready() -> void:
#	Results.connect("function_selected", self, "_on_function_selected")
#	ViewMenu.connect("index_pressed", Results, "_on_view_pressed")
#

#func setup_game_context() -> void:
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

#	Summary.summarize(results)
#	XML.write(results)
#	Results.display(results)
#	filesystem.set_failed(results)
#
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
