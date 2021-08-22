tool
extends Button

enum { RUN, DEBUG }
var _menu: PopupMenu
var filesystem
signal run_pressed
signal debug_pressed


func _init() -> void:
	_menu = PopupMenu.new()
	add_child(_menu)

func _pressed():
	if filesystem.changed:
		update_menus()
	var position: Vector2 = rect_global_position
	position.y += rect_size.y
	_menu.rect_global_position = position
	_menu.rect_size = Vector2(rect_size.x, 0)
	_menu.grab_focus()
	_menu.popup()
	
func update_menus() -> void:
	text = "Updating"
	
	for dir in [filesystem.root] + filesystem.root.nested_subdirs:
		var dir_menu = _add_menu(_menu, dir)
		_add_run_callback(dir_menu, dir)
		
		for script in dir.tests:
			var script_menu = _add_menu(dir_menu, script)
			_add_run_callback(script_menu, script)
		
			for method in script.methods:
				var method_menu = _add_menu(script_menu, method)
				_add_run_callback(method_menu, method)
				
func _add_menu(parent: PopupMenu, data: Object):
		var child: PopupMenu = PopupMenu.new()
		parent.add_child(child)
		child.name = child.get_index() as String
		parent.add_submenu_item(data.name, child.name, child.get_index())
		return child
				
func _add_run_callback(menu: PopupMenu, data: Object) -> void:
	menu.add_item("Run", -2)
	menu.add_item("Debug", -1)
	menu.set_item_metadata(0, data)
	menu.set_item_metadata(1, data)
	menu.connect("index_pressed", self, "_on_idx_pressed", [menu])
				
func _on_idx_pressed(idx: int, dir_menu) -> void:
	match idx:
		0:
			emit_signal("run_pressed", dir_menu.get_item_metadata(idx))
		1:
			emit_signal("debug_pressed", dir_menu.get_item_metadata(idx))
		_:
			print("bad click (TestMenu.gd)")

# TODO:
#	Add Tag Editor
#	Add Tag Runner
#	Add Icons
	
	
	#text = filesystem.changed as String
#enum { RUN, DEBUG, NONE }
#const Parcel = preload("res://addons/WAT/filesystem/test_parcel.gd")
#var FOLDER = preload("res://addons/WAT/assets/folder.png")
#var FAILED = preload("res://addons/WAT/assets/failed.png")
#var SCRIPT = preload("res://addons/WAT/assets/script.png")
#var PLAY = preload("res://addons/WAT/assets/play.png")
#var DEBUGI = preload("res://addons/WAT/assets/play_debug.png")
#var TAG = preload("res://addons/WAT/assets/label.png")
#var FUNCTION = preload("res://addons/WAT/assets/function.png")
#
#const Settings: GDScript = preload("res://addons/WAT/settings.gd")
#var filesystem: Reference # Set by GUI
#var _menu: PopupMenu = PopupMenu.new()
#var _id: int = 0
#signal tests_selected
#signal build
#
#
#func _pressed() -> void:
#	if filesystem.has_been_changed:
#		if(ClassDB.class_exists("CSharpScript")) and Engine.is_editor_hint():
#			emit_signal("build", get_global_mouse_position())
#			filesystem.has_been_changed = false
#			return
#		update()
#	var position: Vector2 = rect_global_position
#	position.y += rect_size.y
#	_menu.rect_global_position = position
#	_menu.rect_size = Vector2(rect_size.x, 0)
#	_menu.grab_focus()
#	_menu.popup()
#
#func display(position):
#	update()
#	#var position: Vector2 = rect_global_position
#	position.y -= rect_size.y
#	_menu.rect_global_position = position
#	_menu.rect_size = Vector2(rect_size.x, 0)
#	_menu.grab_focus()
#	_menu.popup()
#
#func update() -> void:
#	filesystem.has_been_changed = false
#	filesystem.update()
#	if is_instance_valid(_menu):
#		_menu.queue_free()
#	_menu = PopupMenu.new()
#	add_child(_menu)
#	_menu.add_icon_item(FAILED, "Run Failed", 0)
#	_menu.add_icon_item(FAILED, "Debug Failed", 1)
#	if not Engine.is_editor_hint():
#		_menu.set_item_disabled(1, true)
#
#	# Do people actual run/debug all tags? Seems like a weird use case
#	var _tag_menu = PopupMenu.new()
#	_menu.add_child(_tag_menu)
#	_menu.add_submenu_item("Run Tagged", _tag_menu.name, 2)
#	_menu.set_item_icon(2, TAG)
#	for tag in Settings.tags():
#		add_menu(_tag_menu, filesystem.indexed[tag], TAG)
#
#	_menu.set_item_metadata(0, Parcel.new(RUN, filesystem.failed))
#	_menu.set_item_metadata(1, Parcel.new(DEBUG, filesystem.failed))
#	_menu.connect("index_pressed", self, "_on_idx_pressed", [_menu])
#	_id = 6
#	for dir in filesystem.dirs:
#		if dir.tests.empty():
#			continue
#		var dir_menu: PopupMenu = add_menu(_menu, dir, FOLDER)
#
#		for test in dir.tests:
#			var test_menu = add_menu(dir_menu, test, SCRIPT)
#			_add_tag_editor(test_menu, test)
#
#			for method in test.methods:
#				add_menu(test_menu, method, FUNCTION)
#
#func add_menu(parent: PopupMenu, data: Reference, ico: Texture) -> PopupMenu:
#	var child: PopupMenu = PopupMenu.new()
#	child.connect("index_pressed", self, "_on_idx_pressed", [child])
#	parent.add_child(child)
#	child.name = child.get_index() as String
#	parent.add_submenu_item(data.name, child.name, _id)
#	parent.set_item_icon(parent.get_item_index(_id), ico)
#	_id += 1
#	child.add_icon_item(PLAY, "Run All", _id)
#	child.set_item_metadata(0, Parcel.new(RUN, data))
#	_id += 1
#	child.add_icon_item(DEBUGI, "Debug All", _id)
#	child.set_item_metadata(1, Parcel.new(DEBUG, data))
#	child.set_item_disabled(1, not Engine.is_editor_hint())
#	_id += 1
#	return child
#
#func _add_tag_editor(script_menu: PopupMenu, test) -> void:
#	var _tag_editor: PopupMenu = PopupMenu.new()
#	var idx = 0
#	for tag in Settings.tags():
#		_tag_editor.add_check_item(tag)
#		if tag in test.tags:
#			_tag_editor.set_item_checked(0, true)
#		idx += 1
#	script_menu.add_child(_tag_editor)
#	script_menu.add_submenu_item("Edit Tags", _tag_editor.name)
#	script_menu.set_item_icon(2, TAG)
#	_tag_editor.connect("index_pressed", self, "_on_tagged", [_tag_editor, test])
#
#func _on_tagged(idx: int, tag_editor: PopupMenu, test: Reference) -> void:
#	var tag: String = tag_editor.get_item_text(idx)
#	var is_already_selected: bool = tag_editor.is_item_checked(idx)
#	if is_already_selected:
#		tag_editor.set_item_checked(idx, false)
#		test.tags.erase(tag)
#		filesystem.remove_test_from_tag(test, tag)
#		push_warning("Removing Tag %s From %s" % [tag, test.gdscript])
#	else:
#		tag_editor.set_item_checked(idx, true)
#		test.tags.append(tag)
#		filesystem.add_test_to_tag(test, tag)
#		push_warning("Adding Tag %s To %s" % [tag, test.gdscript])
#
#func _on_idx_pressed(idx: int, menu: PopupMenu) -> void:
#	emit_signal("tests_selected", menu.get_item_metadata(idx))
#
#func _setup_editor_assets(assets_registry):
#	FOLDER = assets_registry.load_asset("assets/folder.png")
#	FAILED = assets_registry.load_asset("assets/failed.png")
#	SCRIPT = assets_registry.load_asset("assets/script.png")
#	PLAY = assets_registry.load_asset("assets/play.png")
#	DEBUGI = assets_registry.load_asset("assets/play_debug.png")
#	TAG = assets_registry.load_asset("assets/label.png")
#	FUNCTION = assets_registry.load_asset("assets/function.png")
