tool
extends Button

var _menu: PopupMenu = PopupMenu.new()

func _init() -> void:
	add_child(_menu)

func display() -> void:
	var position: Vector2 = rect_global_position
	position.y += rect_size.y
	_menu.rect_global_position = position
	_menu.rect_size = Vector2(rect_size.x, 0)
	_menu.popup()
	
func update_menu(tests: Array) -> void:
	var id: int = 0
	for test in tests:
		var child: PopupMenu = PopupMenu.new()
		child.name = (child.get_index() - 1) as String
		_menu.add_child(child)
		_menu.add_submenu_item(test.path, child.name, id)
		_menu.set_item_icon(id, load("res://addons/WAT/assets/script.png"))
		
		child.add_icon_item(load("res://addons/WAT/assets/play.png"), "Run All")
		child.add_icon_item(load("res://addons/WAT/assets/play.png"), "Debug All")
		id += 1

func clear() -> void:
	for child in _menu.get_children():
		child.queue_free()
	_menu.clear()

