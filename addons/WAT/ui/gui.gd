tool
extends PanelContainer

enum RUN { ALL, DIRECTORY, SCRIPT, TAGGED, METHOD, RERUN_FAILURES }
const TestRunner: String = "res://addons/WAT/test_runner/TestRunner.tscn"
var Strategy: Dictionary = {"repeat": 0}
var Server: Node
var sceneWasLaunched: bool = false

enum { EXPAND_ALL, COLLAPSE_ALL, EXPAND_FAILURES }
onready var Summary: Label = $GUI/Interact/Summary
onready var Results: TabContainer = $GUI/Results
onready var ViewMenu: PopupMenu = $GUI/Interact/View.get_popup()
onready var QuickStart: Button = $GUI/Interact/QuickStart
onready var Repeater: SpinBox = $GUI/Interact/Repeat
const RESULTS = preload("res://addons/WAT/system/Results.tres")
var p = EditorPlugin.new().get_editor_interface()

func _ready() -> void:
	# Begin Mediator Refactor
	Server = $Host
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

export(PoolStringArray) var view_options: PoolStringArray

func run(strat = null) -> void:
	#if strat != null:
	#	Strategy = strat
	#	Strategy["repeat"] = 1
	#Server.host()
	_run_as_editor() if Engine.is_editor_hint() else _run_as_game()
	#yield(Server, "client_connected")
	#Server.send_strategy(Strategy)
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
	Results.display(_res)
