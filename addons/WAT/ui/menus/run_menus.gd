extends PanelContainer

var _dirs: PopupMenu = PopupMenu.new()
var _scripts: PopupMenu = PopupMenu.new()
var _failed: PopupMenu = PopupMenu.new()
var _tagged: PopupMenu = PopupMenu.new()
var filesystem


func _ready() -> void:
	$Buttons/All.connect("pressed", self, "_pressed", ["All"])
	$Buttons/Dir.connect("pressed", self, "_pressed", ["Dir"])
	$Buttons/Script.connect("pressed", self, "_pressed", ["Script"])
	$Buttons/Failed.connect("pressed", self, "_pressed", ["Failed"])
	$Buttons/Tagged.connect("pressed", self, "_pressed", ["Tagged"])

func _pressed(pressed) -> void:
	if filesystem.has_been_changed:
		update()
		# debug won't capture this
	
	print(pressed)

	
#func update_menu(menu) -> void:
#	# Just update all menus?
#	if filesystem.has_been_changed:
#		update()
#		filesystem.has_been_changed = false
#	var position: Vector2 = rect_global_position
#	position.y += rect_size.y
#	_menu.rect_global_position = position
#	_menu.rect_size = Vector2(rect_size.x, 0)
#	_menu.grab_focus()
#	_menu.popup()
