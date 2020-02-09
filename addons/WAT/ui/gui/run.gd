extends HBoxContainer
tool

onready var QuickStart: Button = $QuickStart
onready var Menu: MenuButton = $Menu.get_popup()

func _ready():
	Menu.clear()
	Menu.add_item("Run All Tests")
	Menu.add_item("Run Selected Directory")
	Menu.add_item("Run Selected Script")
	Menu.add_item("Run Tagged")
