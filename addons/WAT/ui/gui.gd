tool
extends PanelContainer

const TestRunner: String = "res://addons/WAT/test_runner/TestRunner.tscn"
const RESULTS = preload("res://addons/WAT/cache/Results.tres")
onready var Summary: Label = $GUI/Interact/Summary
onready var Results: TabContainer = $GUI/Results
onready var ViewMenu: PopupMenu = $GUI/Interact/View.get_popup()
onready var QuickStart: Button = $GUI/Interact/QuickStart
onready var Repeater: SpinBox = $GUI/Interact/Repeat
export(PoolStringArray) var view_options: PoolStringArray
var sceneWasLaunched: bool = false
var p = EditorPlugin.new().get_editor_interface()
var filecache = preload("res://addons/WAT/cache/test_cache.gd").new()

func _init():
	var e = EditorPlugin.new().get_editor_interface().get_file_system_dock()
	filecache.scripts = {}
	filecache.directories = []
	filecache.script_paths = []
	e.connect("files_moved", filecache, "_on_files_moved")
	e.connect("file_removed", filecache, "_on_files_removed")
	e.connect("folder_moved", filecache, "_on_folder_moved")
	e.connect("folder_removed", filecache, "_on_folder_removed")
	filecache.initialize()

func _ready() -> void:
	$GUI/Interact/MenuButton.FileCache = filecache
	# Begin Mediator Refactor
	# Temp Removal
	# QuickStart.connect("pressed", TestRunnerLauncher, "run", [TestRunnerLauncher.RUN.ALL])
	$GUI/Interact/MenuButton.connect("_test_path_selected", self, "run")
	# End Mediator Refactor
	ViewMenu.clear()
	for item in view_options:
		ViewMenu.add_item(item)
	ViewMenu.connect("id_pressed", $GUI/Results, "_on_view_pressed")
	
func _process(delta):
	if not p.is_playing_scene() and sceneWasLaunched:
		sceneWasLaunched = false
		_display_results()

func get_repeat() -> int:
	return Repeater.value as int

func run(tests) -> void:
	_run_as_editor(tests) if Engine.is_editor_hint() else _run_as_game()
	sceneWasLaunched = true
	
func _run_as_editor(tests) -> void:
	var instance = load("res://addons/WAT/test_runner/TestRunner.tscn").instance()
	instance.tests = tests
	var scene = PackedScene.new()
	scene.pack(instance)
	ResourceSaver.save("res://addons/WAT/test_runner/TestRunner.tscn", scene)
	var plugin = EditorPlugin.new()
	plugin.get_editor_interface().reload_scene_from_path("res://addons/WAT/test_runner/TestRunner.tscn")
	plugin.get_editor_interface().play_custom_scene(TestRunner)
	plugin.make_bottom_panel_item_visible(self)
	
func _run_as_game() -> void:
	var instance = preload(TestRunner).instance()
	#instance.is_editor = false
	add_child(instance)

func _display_results() -> void:
	var _res = RESULTS.retrieve()
	Summary.summarize(_res)
	Results.clear()
	Results.display(_res)
