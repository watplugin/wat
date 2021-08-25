tool
extends Button

# TODO
# Add RunTag
# Add RunFailures

const Settings: GDScript = preload("res://addons/WAT/settings.gd")
var _menu: PopupMenu
var filesystem
var icons
signal run_pressed
signal debug_pressed
signal built

func _init() -> void:
	_menu = PopupMenu.new()
	add_child(_menu)

func _pressed():
	if filesystem.changed:
		if not filesystem.built:
			build()
			return
		filesystem.update()
		update_menus()
	var position: Vector2 = rect_global_position
	position.y += rect_size.y
	_menu.rect_global_position = position
	_menu.rect_size = Vector2(rect_size.x, 0)
	_menu.grab_focus()
	_menu.popup()
	
func clear() -> void:
	_menu.queue_free()
	
func build():
	if not filesystem.built and ClassDB.class_exists("CSharpScript") and Engine.is_editor_hint():
		filesystem.built = yield(filesystem.build_function.call_func(), "completed")
		return
	
func update_menus() -> void:
	_menu.queue_free()
	_menu = PopupMenu.new()
	add_child(_menu)
	
	_add_failed_run_menu()
	_add_tag_run_menu()
	
	for dir in [filesystem.root] + filesystem.root.nested_subdirs:
		if dir.tests.empty():
			continue
		var dir_menu = _add_menu(_menu, dir, icons.folder, -1)
		_add_run_callback(dir_menu, dir)
		
		for script in dir.tests:
			var script_menu = _add_menu(dir_menu, script, icons.scriptx)
			_add_run_callback(script_menu, script)
			_add_tag_editor(script_menu, script)
		
			for method in script.methods:
				var method_menu = _add_menu(script_menu, method, icons.function)
				_add_run_callback(method_menu, method)
				
func _add_menu(parent: PopupMenu, data: Object, icon, offset: int = 1) -> PopupMenu:
		var child: PopupMenu = PopupMenu.new()
		parent.add_child(child)
		child.name = child.get_index() as String
		parent.add_submenu_item(data.name, child.name, child.get_index())
		parent.set_item_icon(child.get_index() + offset, icon)
		parent.hide_on_item_selection = true
		child.hide_on_item_selection = true
		return child
				
func _add_run_callback(menu: PopupMenu, data: Object) -> void:
	menu.add_item("Run")
	menu.add_item("Debug")
	menu.set_item_metadata(0, data)
	menu.set_item_metadata(1, data)
	menu.set_item_icon(0, icons.play)
	menu.set_item_icon(1, icons.play_debug)
	menu.set_item_disabled(1, not Engine.is_editor_hint())
	menu.connect("index_pressed", self, "_on_idx_pressed", [menu])
	
func _add_failed_run_menu() -> void:
	var failed_menu: PopupMenu = PopupMenu.new()
	_menu.add_child(failed_menu)
	_menu.add_submenu_item("Failed", failed_menu.name)
	_menu.set_item_icon(failed_menu.get_index() - 1, icons.failed)
	failed_menu.add_item("Run")
	failed_menu.add_item("Debug")
	failed_menu.set_item_icon(0, icons.play)
	failed_menu.set_item_icon(1, icons.play_debug)
	failed_menu.set_item_metadata(0, filesystem.failed)
	failed_menu.set_item_metadata(1, filesystem.failed)
	failed_menu.set_item_disabled(1, not Engine.is_editor_hint())
	failed_menu.connect("index_pressed", self, "_on_failed_menu_pressed")
	
func _add_tag_run_menu() -> void:
	var tag_menu: PopupMenu = PopupMenu.new()
	_menu.add_child(tag_menu)
	_menu.add_submenu_item("Tagged", tag_menu.name)
	_menu.set_item_icon(tag_menu.get_index() - 1, icons.label)
	for tag in Settings.tags():
		var options: PopupMenu = PopupMenu.new()
		tag_menu.add_child(options)
		tag_menu.add_submenu_item(tag, options.name)
		tag_menu.set_item_icon(options.get_index() - 1, icons.label)
		options.add_item("Run")
		options.add_item("Debug")
		options.set_item_icon(0, icons.play)
		options.set_item_icon(1, icons.play_debug)
		options.set_item_disabled(1, not Engine.is_editor_hint())
		options.connect("index_pressed", self, "_on_tag_pressed", [tag])

func _add_tag_editor(script_menu: PopupMenu, script: Object) -> void:
	var tagger: PopupMenu = PopupMenu.new()
	tagger.hide_on_checkable_item_selection = false
	tagger.connect("about_to_show", self, "_on_tag_editor_about_to_show", [tagger, script])
	tagger.connect("index_pressed", self, "_on_tagged", [tagger, script])
	# Unnecessary since we change per access
	for tag in Settings.tags():
		tagger.add_check_item(tag)
	script_menu.add_child(tagger)
	script_menu.add_submenu_item("Edit Tags", tagger.name)
	script_menu.set_item_icon(2, icons.label)
	
func _on_tag_editor_about_to_show(tagger: PopupMenu, script: Object) -> void:
	tagger.clear()
	tagger.set_as_minsize()
	var idx: int = 0
	for tag in Settings.tags():
		tagger.add_check_item(tag)
		if filesystem.tagged.is_tagged(tag, script.path):
			tagger.set_item_checked(idx, true)
		idx += 1
	
func _on_tagged(index: int, tagger: PopupMenu, script: Object) -> void:
	var tag: String = tagger.get_item_text(index)
	if tagger.is_item_checked(index):
		filesystem.tagged.untag(tag, script.path)
		tagger.set_item_checked(index, false)
	else:
		filesystem.tagged.tag(tag, script.path)
		tagger.set_item_checked(index, true)

func _on_idx_pressed(idx: int, menu: PopupMenu) -> void:
	match idx:
		0:
			emit_signal("run_pressed", menu.get_item_metadata(idx))
		1:
			emit_signal("debug_pressed", menu.get_item_metadata(idx))
			
func _on_failed_menu_pressed(idx: int) -> void:
	filesystem.failed.set_tests(filesystem.root)
	match idx:
		0:
			emit_signal("run_pressed", filesystem.failed)
		1:
			emit_signal("debug_pressed", filesystem.failed)
			
func _on_tag_pressed(idx: int, tag: String) -> void:
	filesystem.tagged.set_tests(tag, filesystem.root)
	match idx:
		0:
			emit_signal("run_pressed", filesystem.tagged)
		1:
			emit_signal("debug_pressed", filesystem.tagged)
