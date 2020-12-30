extends Button
tool

signal _test_path_selected
var FileCache
onready var Directories: PopupMenu = $Directories
onready var Scripts: PopupMenu = $Directories/Scripts
onready var Methods: PopupMenu = $Directories/Scripts/Methods
onready var Tags: PopupMenu = $Directories/Tags


func _ready() -> void:
	Directories.connect("index_pressed", self, "_on_idx_pressed", [Directories])
	Scripts.connect("index_pressed", self, "_on_idx_pressed", [Scripts])
	Methods.connect("index_pressed", self, "_on_idx_pressed", [Methods])
	Tags.connect("index_pressed", self, "_on_idx_pressed", [Tags])
	
	
func _on_idx_pressed(idx: int, menu: PopupMenu) -> void:
	var run_failures = false
	var tests = []
	var metadata = menu.get_item_metadata(idx)
	if metadata is bool:
		run_failures = true
	else:
		tests = metadata
	emit_signal("_test_path_selected", tests, run_failures)


func _on_Directories_about_to_show():
	Directories.clear()
	Directories.set_as_minsize()
	Directories.add_item("Run All")
	Directories.add_item("Rerun Failures")
	Directories.add_submenu_item("Tags", "Tags")
	Directories.set_item_metadata(0, FileCache.scripts(ProjectSettings.get_setting("WAT/Test_Directory")))
	Directories.set_item_metadata(1, true) # Failures aren't easily accessible at the moment
	var dirs: Array = FileCache.directories
	if dirs.empty():
		return
	for dir in dirs:
		if not FileCache.scripts(dir).empty():
			Directories.add_submenu_item(dir, "Scripts")


func _on_Tags_about_to_show():
	Tags.clear()
	Tags.set_as_minsize()
	var idx: int = 0
	for tag in ProjectSettings.get("WAT/Tags"):
		Tags.add_item(tag)
		Tags.set_item_metadata(idx, FileCache.tagged(tag))
		idx += 1


func _on_Scripts_about_to_show():
	Scripts.clear()
	Scripts.set_as_minsize()
	Scripts.add_item("Run All")
	Scripts.set_item_metadata(0, FileCache.scripts(Directories.get_item_text(Directories.get_current_index())))
	var tests: Array = FileCache.scripts(Directories.get_item_text(Directories.get_current_index()))
	if tests.empty():
		return
	for test in tests:
		Scripts.add_submenu_item(test.path, "Methods")


func _on_Methods_about_to_show():
	Methods.clear()
	Methods.set_as_minsize()
	Methods.add_item("Run All")
	Methods.set_item_metadata(0, FileCache.scripts(Scripts.get_item_text(Scripts.get_current_index())))
	var test = FileCache.scripts(Scripts.get_item_text(Scripts.get_current_index()))[0]
	var methods = test.test.get_script_method_list()
	var idx: int = 1
	for method in methods:
		if method.name.begins_with("test"):
			var dupe = test.duplicate()
			dupe.method = method.name
			Methods.add_item(method.name)
			Methods.set_item_metadata(idx, [dupe])
			idx += 1


func _input(event):
	if get_parent().get_node("QuickStart").shortcut.is_shortcut(event):
		_on_QuickStart_pressed()
		
		
func _on_pressed():
	var position = rect_global_position
	position.y += rect_size.y
	Directories.rect_global_position = position
	Directories.rect_size = Vector2(rect_size.x, 0)
	Directories.grab_focus()
	Directories.popup()

func _on_QuickStart_pressed():
	_on_idx_pressed(0, Directories)

