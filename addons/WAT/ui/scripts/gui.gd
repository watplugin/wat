extends PanelContainer
tool

const Log: Script = preload("res://addons/WAT/log.gd")

# Resources require tool to work inside the editor whereas..
# ..scripts objects without tool can be called from tool based scripts
const TestRunner: PackedScene = preload("res://addons/WAT/runner/TestRunner.tscn")
const Server: Script = preload("res://addons/WAT/network/server.gd")
const XML: Script = preload("res://addons/WAT/editor/junit_xml.gd")
const PluginAssetsRegistry: Script = preload("res://addons/WAT/ui/scripts/plugin_assets_registry.gd")
onready var TestMenu: Button = $Core/Menu/TestMenu
onready var Results: TabContainer = $Core/Results
onready var Summary: HBoxContainer = $Core/Summary
onready var Threads: SpinBox = $Core/Menu/RunSettings/Threads
onready var Repeats: SpinBox = $Core/Menu/RunSettings/Repeats
onready var Core: VBoxContainer = $Core
var instance #: #TestRunner
var server: Server
signal launched_via_editor
signal function_selected

func _ready() -> void:
	Threads.max_value = OS.get_processor_count() - 1
	Threads.min_value = 1
	if not Engine.is_editor_hint():
		_set_window_size()
		# No argument makes the AssetsRegistry default to a scale of 1, which
		# should make every icon look normal when the Tests UI launches
		# outside of the editor.
		_setup_editor_assets(PluginAssetsRegistry.new())
	$Core.connect("test_strategy_set", self, "_on_test_strategy_set")
	Results.connect("function_selected", self, "_on_function_selected")
	
func _on_function_selected(path: String, function: String) -> void:
	emit_signal("function_selected", path, function)

func _on_test_strategy_set(tests, run_in_editor) -> void:
	if tests.empty():
		push_warning("Tests Are Empty!")
		return
	Results.clear()
	Summary.time()
	tests = _repeat(tests, Repeats.value)
	if run_in_editor:
		_launch_in_editor(tests, Threads.value)
	else:
		_launch_via_editor(tests, Threads.value)
		
func _repeat(tests: Array, repeat: int) -> Array:
	var duplicates: Array = []
	for idx in repeat:
		for test in tests:
			duplicates.append(test)
	duplicates += tests
	return duplicates
	
func _launch_in_editor(tests: Array, threads: int) -> void:
	# This is also the launch method used for exported scenes
	instance = TestRunner.instance() #tests, threads)
	#instance.connect("run_completed", self, "_on_run_completed")
	add_child(instance)
	var results = yield(instance.run(tests, threads), "completed")
	_on_run_completed(results)
	
func _launch_via_editor(tests: Array, threads: int) -> void:
	if not is_instance_valid(server):
		server = Server.new()
		server.connect("run_completed", self, "_on_run_completed")
		add_child(server)
	server.tests = tests
	server.threads = threads
	emit_signal("launched_via_editor")
	
func _on_run_completed(results: Array = []) -> void:
	if is_instance_valid(instance):
		instance.queue_free()
	Summary.summarize(results)
	TestMenu.set_last_run_success(results)
	XML.write(results)
	Results.display(results)


func _exit_tree() -> void:
	if is_instance_valid(server):
		server.close()
		server.free()

func _set_window_size() -> void:
	OS.window_size = ProjectSettings.get_setting("WAT/Window_Size")

# Loads scaled assets like icons and fonts
func _setup_editor_assets(assets_registry):
	Core._setup_editor_assets(assets_registry)
