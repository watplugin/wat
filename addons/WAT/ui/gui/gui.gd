tool
extends VBoxContainer

enum RESULTS { EXPAND_ALL, COLLAPSE_ALL, EXPAND_FAILURES }
onready var Interact: HBoxContainer = $Interact
onready var Summary: Label = $Summary
onready var Results: TabContainer = $Results
var filesystem

func _on_view_pressed(id: int) -> void:
	match id:
		RESULTS.EXPAND_ALL:
			Results.expand_all()
		RESULTS.COLLAPSE_ALL:
			Results.collapse_all()
		RESULTS.EXPAND_FAILURES:
			Results.expand_failures()

