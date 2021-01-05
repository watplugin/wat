extends HBoxContainer
tool

signal _tests_selected
onready var TestMenu: Button = $TestMenu
onready var Directories: PopupMenu = $TestMenu/Directories
onready var Scripts: PopupMenu = $TestMenu/Directories/Scripts
onready var Methods: PopupMenu = $TestMenu/Directories/Scripts/Methods
onready var Tags: PopupMenu = $TestMenu/Directories/Tags
onready var TagEditor: PopupMenu = $TestMenu/Directories/Scripts/Methods/TagEditor
onready var Repeater: SpinBox = $Repeat
onready var Tests: Node = $Explorer
onready var Threads: SpinBox = $Threads

func _ready() -> void:
	# Dictionaries are referenced, meaning this is a pointer to the main dir
#	tests = get_tree().root.get_node("WATNamespace").FileManager.tests
	Threads.max_value = OS.get_processor_count() - 1
	Directories.connect("index_pressed", self, "_on_idx_pressed", [Directories])
	Scripts.connect("index_pressed", self, "_on_idx_pressed", [Scripts])
	Methods.connect("index_pressed", self, "_on_idx_pressed", [Methods])
	Tags.connect("index_pressed", self, "_on_idx_pressed", [Tags])
	
func _on_idx_pressed(idx: int, menu: PopupMenu) -> void:
	emit_signal("_tests_selected", duplicate_tests(menu.get_item_metadata(idx)), Threads.value as int)

func _on_Directories_about_to_show():
	Directories.clear()
	Directories.set_as_minsize()
	Directories.add_item("Run All")
	Directories.add_item("Rerun Failures")
	Directories.add_submenu_item("Tags", "Tags")
	Directories.set_item_metadata(0, tests(WAT.Settings.test_directory()))
	Directories.set_item_metadata(1, WAT.results().failed())
	Directories.set_item_icon(0, WAT.Icon.RUN)
	Directories.set_item_icon(1, WAT.Icon.RERUN_FAILED)
	Directories.set_item_icon(2, WAT.Icon.TAG)
	
	var dirs: Array = tests("directories")
	if dirs.empty():
		return
	var idx: int = Directories.get_item_count()
	for dir in dirs:
		if not tests(dir).empty():
			Directories.add_submenu_item(dir, "Scripts")
			Directories.set_item_icon(idx, WAT.Icon.FOLDER)
			idx += 1


func _on_Tags_about_to_show():
	Tags.clear()
	Tags.set_as_minsize()
	var idx: int = 0
	for tag in WAT.Settings.tags(): # WAT.Settings.Tags()
		Tags.add_item(tag)
		Tags.set_item_metadata(idx, tests(tag))
		idx += 1


func _on_Scripts_about_to_show():
	Scripts.clear()
	Scripts.set_as_minsize()
	Scripts.add_item("Run All")
	Scripts.set_item_metadata(0, tests(Directories.get_item_text(Directories.get_current_index())))
	Scripts.set_item_icon(0, WAT.Icon.FOLDER)
	var scripts: Array = tests(Directories.get_item_text(Directories.get_current_index()))
	if scripts.empty():
		return
	var idx: int = Scripts.get_item_count()
	for test in scripts:
		Scripts.add_submenu_item(test.path, "Methods")
		Scripts.set_item_icon(idx, WAT.Icon.SCRIPT)
		idx += 1


func _on_Methods_about_to_show():
	Methods.clear()
	Methods.set_as_minsize()
	Methods.add_item("Run All")
#	Methods.add_item("Edit Tags")
	Methods.add_submenu_item("Edit Tags", "TagEditor")
	Methods.set_item_metadata(0, [tests(Scripts.get_item_text(Scripts.get_current_index()))])
	Methods.set_item_metadata(1, [tests(Scripts.get_item_text(Scripts.get_current_index()))])
	Methods.set_item_icon(0, WAT.Icon.SCRIPT)
	Methods.set_item_icon(1, WAT.Icon.TAG)
	var test = tests(Scripts.get_item_text(Scripts.get_current_index()))
	var methods = test.test.get_script_method_list()
	var idx: int = Methods.get_item_count()
	for method in methods:
		if method.name.begins_with("test"):
			var dupe = test.duplicate()
			dupe.method = method.name
			Methods.add_item(method.name)
			Methods.set_item_metadata(idx, [dupe])
			Methods.set_item_icon(idx, WAT.Icon.FUNCTION)
			idx += 1


func _on_TestMenu_pressed():
	var position = TestMenu.rect_global_position
	position.y += TestMenu.rect_size.y
	Directories.rect_global_position = position
	Directories.rect_size = Vector2(rect_size.x, 0)
	Directories.grab_focus()
	Directories.popup()


func _on_QuickStart_pressed():
	var scripts = duplicate_tests(tests(WAT.Settings.test_directory()))
	emit_signal("_tests_selected", scripts)
	
	
func duplicate_tests(scripts: Array) -> Array:
	var duplicates = []
	for i in Repeater.value as int:
		duplicates += scripts.duplicate()
	scripts += duplicates
	return scripts

func _on_TagEditor_about_to_show():
	var script = tests(Scripts.get_item_text(Scripts.get_current_index()))
	TagEditor.clear()
	TagEditor.set_as_minsize()
	var idx: int = 0
	for tag in WAT.Settings.tags():
		TagEditor.add_check_item(tag)
		if script.tags.has(tag):
			TagEditor.set_item_checked(idx, true)
		idx += 1

func _on_TagEditor_index_pressed(index):
	var script = tests(Scripts.get_item_text(Scripts.get_current_index()) as String)
	if TagEditor.is_item_checked(index):
		TagEditor.set_item_checked(index, false)
	else:
		TagEditor.set_item_checked(index, true)
		script.tags.append(TagEditor.get_item_text(TagEditor.get_current_index()) as String)

func tests(path: String):
	return Tests.tests[path]
	
