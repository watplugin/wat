extends HBoxContainer
tool

onready var Run: HBoxContainer = $Run
onready var Select: HBoxContainer = $Select
onready var ViewMenu: MenuButton = $View.get_popup()

func _ready():
	ViewMenu.clear()
	ViewMenu.add_item("Expand All Results")
	ViewMenu.add_item("Collapse All Results")
	ViewMenu.add_item("Expand All Failures")
