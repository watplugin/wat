tool
extends PanelContainer

const FileSystem: GDScript = preload("res://addons/WAT/filesystem/filesystem.gd")
const SceneTreeAdjuster: GDScript = preload("res://addons/WAT/ui/scaling/scene_tree_adjuster.gd")
const Settings: GDScript = preload("res://addons/WAT/settings.gd")
const JUnitXML: GDScript = preload("res://addons/WAT/io/junit_xml.gd")
onready var RunAll: Button = $Core/Menu/RunAll
onready var DebugAll: Button = $Core/Menu/DebugAll
onready var TestMenu: Button = $Core/Menu/TestMenu
onready var Results: TabContainer = $Core/Results
onready var Summary: HBoxContainer = $Core/Summary
onready var Threads: SpinBox = $Core/Menu/RunSettings/Threads
onready var Repeats: SpinBox = $Core/Menu/RunSettings/Repeats
onready var Server: Node = $Server

var _icons: Reference 
var _filesystem: FileSystem
var _plugin = null

func _ready() -> void:
	_icons = preload("res://addons/WAT/ui/scaling/icons.gd").new()
	TestMenu.icons = _icons
	Results.icons = _icons
	RunAll.set_focus_mode(FOCUS_ALL)
	DebugAll.set_focus_mode(FOCUS_ALL)
	TestMenu.set_focus_mode(FOCUS_ALL)
	$Core/Menu.set_focus_mode(FOCUS_ALL) 
	TestMenu.connect("update", self, "build")

	if not Engine.is_editor_hint():
		_setup_scene_context()
	Threads.max_value = OS.get_processor_count() - 1
	RunAll.connect("pressed", self, "_on_run_all_pressed")
	DebugAll.connect("pressed", self, "_on_debug_all_pressed")
	TestMenu.connect("run_pressed", self, "_on_run_pressed")
	TestMenu.connect("debug_pressed", self, "_on_debug_pressed")
	$Core/Menu/ResultsMenu.get_popup().connect("index_pressed", Results, "_on_view_pressed")
	
func _setup_scene_context() -> void:
	OS.window_size = ProjectSettings.get_setting("Test/Config/Window_Size")
	SceneTreeAdjuster.adjust(self, _icons)
	_filesystem = load("res://addons/WAT/filesystem/filesystem.gd").new()
	TestMenu.filesystem = _filesystem
	_filesystem.update()
	TestMenu.update_menus()
	DebugAll.disabled = true
	
func setup_editor_context(plugin, goto_func: FuncRef, filesystem: Reference) -> void:
	yield(self, "ready")
	SceneTreeAdjuster.adjust(self, _icons, plugin)
	_plugin = plugin
	_filesystem = filesystem
	Results.goto_function = goto_func
	TestMenu.filesystem = _filesystem
	_filesystem.update()
	TestMenu.update_menus()
	Server.results_view = Results

# Setup tests for display. Returns false if run should be terminated.
func _setup_display(tests: Array) -> bool:
	if tests.empty():
		push_warning("WAT: No tests found. Terminating run")
		return false
	Summary.time()
	Results.display(tests, Repeats.value)
	return true


enum RUN_ALL {
	NOT_RUN_ALL
	NORMAL_RUN_ALL
	DEBUG_RUN_ALL
}

func set_run_mode(run_mode: int):
	OS.set_environment("WAT_RUN_ALL_MODE", run_mode as String)
	
func _on_run_all_pressed():
	_on_run_pressed(_filesystem.root, RUN_ALL.NORMAL_RUN_ALL)
	
func _on_debug_all_pressed():
	_on_debug_pressed(_filesystem.root, RUN_ALL.DEBUG_RUN_ALL)

func _on_run_pressed(data = _filesystem.root, run_mode = RUN_ALL.NOT_RUN_ALL) -> void:
	set_run_mode(run_mode)
	Results.clear()
	data = build(data)
	var tests: Array = data.get_tests()
	if _setup_display(tests):
		var instance = preload("res://addons/WAT/runner/TestRunner.gd").new()
		add_child(instance)
		var results: Array = yield(instance.run(tests, Repeats.value,
				Threads.value, Results), "completed")
		instance.queue_free()
		_on_test_run_finished(results)

func _on_debug_pressed(data = _filesystem.root, run_mode: int = RUN_ALL.NOT_RUN_ALL) -> void:
	set_run_mode(run_mode)
	Results.clear()
	data = build(data)

	if Server.kick_current_peer():
			_plugin.get_editor_interface().stop_playing_scene()
	var tests: Array = data.get_tests()
	if _setup_display(tests):
		_plugin.get_editor_interface().play_custom_scene(
				"res://addons/WAT/runner/TestRunner.tscn")
		if Settings.is_bottom_panel():
			_plugin.make_bottom_panel_item_visible(self)
		yield(Server, "network_peer_connected")
		Server.send_tests(tests, Repeats.value, Threads.value)
		var results: Array = yield(Server, "results_received")
		_plugin.get_editor_interface().stop_playing_scene()
		_on_test_run_finished(results)

func build(data = null):
	if not Engine.is_editor_hint():
		# Can't build as game
		return data
	if not _filesystem.changed and Settings.cache_tests():
		return data
	var build_tool = _plugin.get_editor_interface().get_editor_settings().get("mono/builds/build_tool")
	if build_tool == 3: # DOTNET
		var output = []
		OS.execute("DOTNET", ["build"], true, output, true, false)
	else:
		print("MSBuild not supported yet")
	if data == _filesystem.root:
		_filesystem.update()
		data = _filesystem.root # New Root
		TestMenu.update_menus() # Also update the "Select Tests" dropdown
	return data
	

func _on_test_run_finished(results: Array) -> void:
	Summary.summarize(results)
	JUnitXML.write(results, Settings, Summary.time_taken)
	_filesystem.failed.update(results)
	
func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		queue_free()
