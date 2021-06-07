tool
extends Button

# We'll have to figure this out later with the plugin assets registry
class Icon:
	var assets_registry
	const FOLDER = preload("res://addons/WAT/assets/folder.png")
	const FAILED = preload("res://addons/WAT/assets/failed.png")
	const SCRIPT = preload("res://addons/WAT/assets/script.png")
	const PLAY = preload("res://addons/WAT/assets/play.png")
	const DEBUG = preload("res://addons/WAT/assets/play_debug.png")
	const TAG = preload("res://addons/WAT/assets/label.png")
	const FUNCTION = preload("res://addons/WAT/assets/function.png")

var filesystem: Reference # Set by GUI
var _menu: PopupMenu = PopupMenu.new()
var _id: int = 0
signal tests_selected
signal tests_selected_debug
enum { NONE, RUN, DEBUG } # This may be unnecessary

func _pressed() -> void:
	if filesystem.has_been_updated:
		update()
		filesystem.has_been_updated = false
	var position: Vector2 = rect_global_position
	position.y += rect_size.y
	_menu.rect_global_position = position
	_menu.rect_size = Vector2(rect_size.x, 0)
	_menu.grab_focus()
	_menu.popup()
	
func update() -> void:
	# We still require tags as well
	filesystem.update()
	_menu.free()
	_menu = PopupMenu.new()
	add_child(_menu)
	_menu.add_icon_item(Icon.PLAY, "Run All", 0)
	_menu.add_icon_item(Icon.DEBUG, "Debug All", 1)
	_menu.add_icon_item(Icon.FAILED, "Run Failed", 2)
	_menu.add_icon_item(Icon.TAG, "Run Tagged", 3)
	_menu.set_item_metadata(0, Metadata.new(RUN, filesystem))
	_menu.set_item_metadata(1, Metadata.new(DEBUG, filesystem))
	_menu.connect("index_pressed", self, "_on_idx_pressed", [_menu])
	_id = 4
	for dir in filesystem.dirs:
		if dir.tests.empty():
			continue
		var dir_menu: PopupMenu = add_menu(_menu, dir, Icon.FOLDER)
		
		for test in dir.tests:
			var test_menu = add_menu(dir_menu, test, Icon.SCRIPT)
			
			for method in test.methods:
				add_menu(test_menu, method, Icon.FUNCTION)

				
func add_menu(parent: PopupMenu, data: Reference, ico: Texture) -> PopupMenu:
	var child: PopupMenu = PopupMenu.new()
	child.connect("index_pressed", self, "_on_idx_pressed", [child])
	parent.add_child(child)
	child.name = child.get_index() as String
	parent.add_submenu_item(data.path, child.name, _id)
	parent.set_item_icon(parent.get_item_index(_id), ico)
	_id += 1
	child.add_icon_item(Icon.PLAY, "Run All", _id)
	child.set_item_metadata(0, Metadata.new(RUN, data))
	_id += 1
	child.add_icon_item(Icon.DEBUG, "Debug All", _id)
	child.set_item_metadata(1, Metadata.new(DEBUG, data))
	_id += 1
	return child

func _on_idx_pressed(idx: int, menu: PopupMenu) -> void:
	var data: Metadata = menu.get_item_metadata(idx)
	match data.run_type:
		RUN:
			emit_signal("tests_selected", data.tests.get_ref())
		DEBUG:
			emit_signal("tests_selected_debug", data.tests.get_ref())
		NONE:
			pass

class Metadata extends Reference:
	var run_type: int
	var tests
	
	func _init(_run_type: int, _tests: Object) -> void:
		run_type = _run_type
		tests = weakref(_tests)
