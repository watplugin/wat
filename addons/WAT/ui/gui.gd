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
var _build: FuncRef

func _ready() -> void:
	_icons = preload("res://addons/WAT/ui/scaling/icons.gd").new()
	TestMenu.icons = _icons
	Results.icons = _icons
	RunAll.set_focus_mode(FOCUS_ALL)
	DebugAll.set_focus_mode(FOCUS_ALL)
	TestMenu.set_focus_mode(FOCUS_ALL)
	$Core/Menu.set_focus_mode(FOCUS_ALL) 

	if not Engine.is_editor_hint():
		_setup_scene_context()
	Threads.max_value = OS.get_processor_count() - 1
	RunAll.connect("pressed", self, "_on_run_pressed")
	DebugAll.connect("pressed", self, "_on_debug_pressed")
	TestMenu.connect("run_pressed", self, "_on_run_pressed")
	TestMenu.connect("debug_pressed", self, "_on_debug_pressed")
	$Core/Menu/ResultsMenu.get_popup().connect("index_pressed", Results, "_on_view_pressed")
	
func _setup_scene_context() -> void:
	OS.window_size = ProjectSettings.get_setting("WAT/Window_Size")
	SceneTreeAdjuster.adjust(self, _icons)
	_filesystem = load("res://addons/WAT/filesystem/filesystem.gd").new()
	TestMenu.filesystem = _filesystem
	_filesystem.update()
	TestMenu.update_menus()
	DebugAll.disabled = true
	
func setup_editor_context(plugin, build: FuncRef, goto_func: FuncRef, filesystem: Reference) -> void:
	yield(self, "ready")
	SceneTreeAdjuster.adjust(self, _icons, plugin)
	_plugin = plugin
	_filesystem = filesystem
	_build = build
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

func _on_run_pressed(data = _filesystem.root) -> void:
	Results.clear()
	var current_build = true
	if _filesystem.changed or not Settings.cache_tests():
		if not _filesystem.built:
			current_build = false
			_filesystem.built = yield(_filesystem.build_function.call_func(), "completed")
		if data == _filesystem.root:
			_filesystem.update()
			data = _filesystem.root # New Root
			TestMenu.update_menus() # Also update the "Select Tests" dropdown
	# Only run if the build is current and up to date.
	if current_build:
		var tests: Array = data.get_tests()
		if _setup_display(tests):
			var client = preload("res://addons/WAT/client/Client.tscn").instance()
			add_child(client)
			yield(Server, "web_network_peer_connected")
			Server.send_tests(tests, Repeats.value, Threads.value) # Is Actually a client
			var results: Array = yield(Server, "results_received")
			client.queue_free()
			_on_test_run_finished(results)
			
#			_plugin.get_editor_interface().play_custom_scene(
#					"res://addons/WAT/runner/TestRunner.tscn")
#			if Settings.is_bottom_panel():
##				_plugin.make_bottom_panel_item_visible(self)
#			yield(Server, "web_network_peer_connected")
#			Server.send_tests(tests, Repeats.value, Threads.value)
#			var results: Array = yield(Server, "results_received")
#			_plugin.get_editor_interface().stop_playing_scene()
#			_on_test_run_finished(results)

func _on_debug_pressed(data = _filesystem.root) -> void:
	Results.clear()
	var current_build = true
	if _filesystem.changed or not Settings.cache_tests():
		if not _filesystem.built:
			current_build = false
			_filesystem.built = yield(_filesystem.build_function.call_func(), "completed")
		if data == _filesystem.root:
			_filesystem.update()
			data = _filesystem.root # New Root
			TestMenu.update_menus()

	if current_build:
#		if Server.kick_current_peer():
#				_plugin.get_editor_interface().stop_playing_scene()
		var tests: Array = data.get_tests()
		if _setup_display(tests):
			
			# Debug is implicit when running as a GUI
			_plugin.get_editor_interface().play_custom_scene(
					"res://addons/WAT/runner/TestRunner.tscn")
			if Settings.is_bottom_panel():
				_plugin.make_bottom_panel_item_visible(self)
			yield(Server, "web_network_peer_connected")
			Server.send_tests(tests, Repeats.value, Threads.value)
			var results: Array = yield(Server, "results_received")
			_plugin.get_editor_interface().stop_playing_scene()
			_on_test_run_finished(results)

func _on_test_run_finished(results: Array) -> void:
	Summary.summarize(results)
	JUnitXML.write(results, Settings, Summary.time_taken)
	_filesystem.failed.update(results)
	
func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		queue_free()
