tool
extends VBoxContainer

enum RESULTS { EXPAND_ALL, COLLAPSE_ALL, EXPAND_FAILURES }
onready var Interact: HBoxContainer = $Interact
onready var Summary: Label = $Summary
onready var Results: TabContainer = $Results
var filesystem
var current_main_dir
var tags

func _process(delta: float) -> void:
	if WAT.Settings.test_directory() != current_main_dir:
		current_main_dir = ProjectSettings.get_setting("WAT/Test_Directory")
		_show_dir()
	
func _show_dir():
	Interact.DirectorySelector.clear()
	Interact.DirectorySelector.add_item(ProjectSettings.get_setting("WAT/Test_Directory"))
	Interact.update()
	
func _on_view_pressed(id: int) -> void:
	match id:
		RESULTS.EXPAND_ALL:
			Results.expand_all()
		RESULTS.COLLAPSE_ALL:
			Results.collapse_all()
		RESULTS.EXPAND_FAILURES:
			Results.expand_failures()

