tool
extends PanelContainer

enum { EXPAND_ALL, COLLAPSE_ALL, EXPAND_FAILURES }
onready var Summary: Label = $GUI/Interact/Summary
onready var Results: TabContainer = $GUI/Results
onready var ViewMenu: PopupMenu = $GUI/Interact/View.get_popup()
onready var QuickStart: Button = $GUI/Interact/QuickStart
onready var Repeater: SpinBox = $GUI/Interact/Repeat
const RESULTS = preload("res://addons/WAT/system/Results.tres")
var p = EditorPlugin.new().get_editor_interface()

func get_repeat() -> int:
	return Repeater.value as int

export(PoolStringArray) var view_options: PoolStringArray

func _on_view_pressed(id: int) -> void:
	match id:
		EXPAND_ALL:
			Results.expand_all()
		COLLAPSE_ALL:
			Results.collapse_all()
		EXPAND_FAILURES:
			Results.expand_failures()
			
func _process(delta):
	if not p.is_playing_scene() and $Controllers/TestRunnerLauncher.sceneWasLaunched:
		$Controllers/TestRunnerLauncher.sceneWasLaunched = false
		_display_results()

func _ready() -> void:
	# Begin Mediator Refactor
	var TestRunnerLauncher = get_node("Controllers/TestRunnerLauncher")
	TestRunnerLauncher.Server = $Host
	TestRunnerLauncher.Root = self
	# Temp Removal
	# QuickStart.connect("pressed", TestRunnerLauncher, "run", [TestRunnerLauncher.RUN.ALL])
	$GUI/Interact/MenuButton.connect("_test_path_selected", TestRunnerLauncher, "run")
	# End Mediator Refactor
	ViewMenu.clear()
	for item in view_options:
		ViewMenu.add_item(item)
	ViewMenu.connect("id_pressed", $GUI/Results, "_on_view_pressed")
	
func _display_results() -> void:
	var _res = RESULTS.retrieve()
	Summary.summarize(_res)
	Results.display(_res)
