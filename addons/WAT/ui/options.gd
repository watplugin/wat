tool
extends HBoxContainer

const FILESYSTEM = preload("res://addons/WAT/filesystem.gd")
onready var Run: PopupMenu = $Run.get_popup()
onready var More: PopupMenu = $More.get_popup()
onready var FolderSelect: OptionButton = $SelectDir
onready var ScriptSelect: OptionButton = $SelectScript
var wat_templates_dir: = "res://addons/WAT/script_templates"
var wat_templates
var script_templates_dir: String
signal RUN

func _default_directory() -> String:
	return ProjectSettings.get("WAT/Test_Directory")

func _run(path: String  = _default_directory()) -> void:
	emit_signal("RUN", path)

func _run_folder() -> void:
	if _exists(FolderSelect):
		_run(_selected(FolderSelect))

func _run_script() -> void:
	if _exists(ScriptSelect):
		_run(_selected(ScriptSelect))

func _ready() -> void:
	_select_folder()
	_select_script()
	_connect()

func _connect():
	Run.connect("id_pressed", self, "call_run_methods")
	More.connect("id_pressed", self, "more_menu_options")
	FolderSelect.connect("pressed", self, "_select_folder")
	ScriptSelect.connect("pressed", self, "_select_script")
	ScriptSelect.get_popup().hide()
	FolderSelect.get_popup().hide()

func call_run_methods(run_id):
	match run_id:
		0:
			_run()
		1:
			_run_folder()
		2:
			_run_script()

func more_menu_options(menu_id):
	match menu_id:
		0:
			prepare_script_templates()
		1:
			print_stray_nodes()

func prepare_script_templates():
	script_templates_dir = ProjectSettings.get_setting("editor/script_templates_search_path")
	var _dir = Directory.new()
	if not _dir.dir_exists(script_templates_dir):
		_dir.make_dir_recursive(script_templates_dir)

	wat_templates = FILESYSTEM._list(wat_templates_dir, 1, false)
	var script_templates = FILESYSTEM._list(script_templates_dir, 1, false)

	var templates_exist: = false
	for i in wat_templates:
		for j in script_templates:
			if i.name == j.name:
				templates_exist = true
				break

		if templates_exist:
			$More/Overwrite.popup_centered()
			# If Ok selected, signal calls `copy_script_templates`
			break

	if not templates_exist:
		copy_script_templates()

func copy_script_templates():
	for i in wat_templates:
		var _file = load(wat_templates_dir + "/" + i.name)
		ResourceSaver.save(script_templates_dir + "/" + i.name, _file)

func _select_folder(path: String = _default_directory()) -> void:
	if not Directory.new().dir_exists(path):
		return
	FolderSelect.clear()
	FolderSelect.add_item(path)
	for directory in FILESYSTEM.directory_list(path):
		FolderSelect.add_item(directory)

func _select_script() -> void:
	ScriptSelect.clear()
	for file in FILESYSTEM.file_list(_selected(FolderSelect)):
		if _valid_test(file.name) and file.path == ("%s/%s" % [_selected(FolderSelect), file.name]):
			ScriptSelect.add_item(file.path)
	ScriptSelect.get_popup().popup()

func _exists(list: OptionButton) -> bool:
	if list.items.empty():
		OS.alert("Nothing to Run")
		return false
	return true

func _valid_test(file: String) -> bool:
	return file.ends_with(".gd")

func _selected(item: OptionButton) -> String:
	return item.get_item_text(item.selected)
