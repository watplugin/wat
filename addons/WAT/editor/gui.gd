tool
extends PanelContainer

onready var Summary: HBoxContainer = $GUI/Interact/Summary
onready var Results: TabContainer = $GUI/Results
onready var ViewMenu: PopupMenu = $GUI/Interact/View.get_popup()
onready var TestLauncher: Node = $Launcher
var runkey: int = 0
var _FileManager = preload("res://addons/WAT/cache/test_cache.gd").new()

func _ready() -> void:
	ViewMenu.connect("id_pressed", $GUI/Results, "_on_view_pressed")
	
func _on_tests_selected(tests = []) -> void:
	runkey = OS.get_unix_time()
	WAT.results().add_unique_run_key(runkey)
	TestLauncher.launch(tests)
	Summary.start_time()
	if Engine.is_editor_hint():
		ClassDB.instance("EditorPlugin").make_bottom_panel_item_visible(self)
		
func _on_launch_finished():
	var results: Array = WAT.results().retrieve(runkey)
	Summary.summarize(results)
	Results.display(results)	
	

