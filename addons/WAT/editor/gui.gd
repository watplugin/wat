tool
extends PanelContainer

onready var Summary: HBoxContainer = $GUI/Interact/Summary
onready var Results: TabContainer = $GUI/Results
onready var ViewMenu: PopupMenu = $GUI/Interact/View.get_popup()
onready var Repeater: SpinBox = $GUI/Interact/Repeat
onready var TestLauncher: Node = $Launcher
var runkey: int = 0

func _ready() -> void:
	ViewMenu.connect("id_pressed", $GUI/Results, "_on_view_pressed")
	
func _on_tests_selected(tests = []) -> void:
	runkey = OS.get_unix_time()
	get_tree().root.get_node("WATNamespace").Settings.results().add_unique_run_key(runkey)
	tests = duplicate_tests(tests, Repeater.value as int)
	TestLauncher.launch(tests)
	Summary.start_time()
	if Engine.is_editor_hint():
		get_tree().root.get_node("WATNamespace").Plugin.make_bottom_panel_item_visible(self)
		
func _on_launch_finished():
	var results: Array = get_tree().root.get_node("WATNamespace").Settings.results().retrieve(runkey)
	Summary.summarize(results)
	Results.display(results)	
	
func duplicate_tests(tests: Array, repeat: int) -> Array:
	var duplicates = []
	for i in repeat:
		duplicates += tests.duplicate()
	tests += duplicates
	return tests
