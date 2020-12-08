tool
extends PanelContainer

enum { EXPAND_ALL, COLLAPSE_ALL, EXPAND_FAILURES }
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


func _ready() -> void:
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

func run() -> void:
	_run_as_editor() if Engine.is_editor_hint() else _run_as_game()
	sceneWasLaunched = true
	
func _run_as_editor() -> void:
	var plugin = EditorPlugin.new()
	plugin.get_editor_interface().play_custom_scene(TestRunner)
	plugin.make_bottom_panel_item_visible(self)
	
func _run_as_game() -> void:
	var instance = preload(TestRunner).instance()
	#instance.is_editor = false
	add_child(instance)

func _on_view_pressed(id: int) -> void:
	match id:
		EXPAND_ALL:
			Results.expand_all()
		COLLAPSE_ALL:
			Results.collapse_all()
		EXPAND_FAILURES:
			Results.expand_failures()

func _display_results() -> void:
	var _res = RESULTS.retrieve()
	Summary.summarize(_res)
	Results.clear()
	Results.display(_res)
