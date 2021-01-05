tool
extends PanelContainer

onready var Summary: HBoxContainer = $GUI/Interact/Summary
onready var Results: TabContainer = $GUI/Results
onready var ViewMenu: PopupMenu = $GUI/Interact/View.get_popup()
onready var TestLauncher: Node = $Launcher
var runkey: int = 0

func _ready() -> void:
	ViewMenu.connect("id_pressed", $GUI/Results, "_on_view_pressed")
	
func _on_tests_selected(tests = [], threads: int = 1) -> void:
	runkey = OS.get_unix_time()
	WAT.ResManager.results().add_unique_run_key(runkey)
	TestLauncher.launch(tests, threads)
	Summary.start_time()
	if Engine.is_editor_hint():
		ClassDB.instance("EditorPlugin").make_bottom_panel_item_visible(self)
		
func _on_launch_finished():
	var results: Array = WAT.ResManager.results().retrieve(runkey)
	preload("res://addons/WAT/resources/junitxml.gd").save(results, Summary.Time.text)
	Summary.summarize(results)
	Results.display(results)	
