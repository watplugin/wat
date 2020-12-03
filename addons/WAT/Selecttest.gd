extends HBoxContainer
tool

var x
var p
func _ready() -> void:
	var p = $MenuButton.get_popup()
	var x = PopupMenu.new()
	x.name = "SubMenu"
	#x.text = "Woohoo"
	#x.get_popup().name = "SubItem"
	p.add_submenu_item("Item", "SubMenu")
	p.add_child(x)
	x.add_item("Item Of Sub Menu")
	x.connect("id_pressed", self, "pressed")
	x.set_item_accelerator(-1, 1)
	
func x(id):
	print("pressed")
