tool
extends PanelContainer


const TestRunner: PackedScene = preload("res://addons/WAT/core/test_runner/TestRunner.tscn")
onready var Summary: HBoxContainer = $GUI/Summary
onready var Results: TabContainer = $GUI/Results
onready var MainMenu: HBoxContainer = $GUI/MainMenu
onready var ViewMenu: PopupMenu = $GUI/MainMenu/View.get_popup()
onready var TestLauncher: Node = $Launcher
var runkey: int = 0

func _ready() -> void:
	ViewMenu.connect("id_pressed", $GUI/Results, "_on_view_pressed")
	
func _on_tests_selected(tests = [], threads: int = 1, run_in_editor: bool = false) -> void:
	runkey = OS.get_unix_time()
	WAT.ResManager.set_strategy(tests, threads)
	WAT.ResManager.results().add_unique_run_key(runkey)
	if not run_in_editor:
		TestLauncher.launch(tests, threads)
	else:
		var testrunner = TestRunner.instance()
		testrunner.editor_context = true
		testrunner.connect("finished", self, "_on_launch_finished")
		add_child(testrunner)
		print("added runner")
	Summary.start_time()
	if Engine.is_editor_hint():
		ClassDB.instance("EditorPlugin").make_bottom_panel_item_visible(self)
		
func _on_launch_finished(results: Array = []):
	if results.empty():
		results = WAT.ResManager.results().retrieve(runkey)
	preload("res://addons/WAT/resources/junitxml.gd").save(results, Summary.Time.text)
	Summary.summarize(results)
	Results.display(results)	

