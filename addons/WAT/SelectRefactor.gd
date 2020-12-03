extends MenuButton
tool

const FileSystem = preload("res://addons/WAT/system/filesystem.gd")

var dirs = get_popup()
var scripts = PopupMenu.new()
var methods = PopupMenu.new()
signal _test_path_selected

func _ready() -> void:
	scripts.name = "Scripts"
	methods.name = "Methods"
	dirs.add_child(scripts, true)
	scripts.add_child(methods, true)
	dirs.connect("about_to_show", self, "_on_about_to_show_directories")
	scripts.connect("about_to_show", self, "_on_about_to_show_scripts")
	methods.connect("about_to_show", self, "_on_about_to_show_methods")
	dirs.connect("id_pressed", self, "_on_directory_pressed")
	scripts.connect("id_pressed", self, "_on_script_pressed")
	methods.connect("id_pressed", self, "_on_method_pressed")

func _on_about_to_show_directories():
	dirs.clear()
	var dirlist = FileSystem.directories()
	dirs.add_item("Run All")
	for item in dirlist:
		dirs.add_submenu_item(item, "Scripts")
		
func _on_about_to_show_scripts():
	scripts.clear()
	var scriptlist = FileSystem.scripts(_get_current_directory())
	scripts.add_item("Run Directory")
	for item in scriptlist:
		scripts.add_submenu_item(item, "Methods")
		
func _on_about_to_show_methods():
	methods.clear()
	methods.add_item("Run Script")
	var methodlist = []
	var script = load(_get_current_script())
	for method in script.get_script_method_list():
		if method.name.begins_with("test"):
			methods.add_item(method.name)

# Merge?
func _on_directory_pressed(id: int) -> void:
	var strategy = {"paths": FileSystem.scripts(_get_root_test_directory())}
	emit_signal("_test_path_selected", strategy)
	
func _on_script_pressed(id: int) -> void:
	var strategy = {"paths": FileSystem.scripts(_get_current_directory())}
	emit_signal("_test_path_selected", strategy)
	
func _on_method_pressed(id: int) -> void:
	var strategy = {"paths": FileSystem.scripts(_get_current_directory())}
	strategy["method"] = _get_current_method()
	emit_signal("_test_path_selected", strategy)
	
func _get_root_test_directory() -> String:
	return ProjectSettings.get_setting("WAT/Test_Directory")
	
func _get_current_directory() -> String:
	return dirs.get_item_text(dirs.get_current_index())
	
func _get_current_script() -> String:
	return scripts.get_item_text(scripts.get_current_index())
	
func _get_current_method() -> String:
	return methods.get_item_text(scripts.get_current_index())
