extends HBoxContainer
tool


const FILESYSTEM = preload("res://addons/WAT/filesystem.gd")
onready var FolderSelect: OptionButton = $Folder/Select
onready var ScriptSelect: OptionButton = $TestScript/Select
onready var RunAll: Button = $VBox/RunAll
onready var RunFolder: Button = $Folder/Run
onready var RunScript: Button = $TestScript/Run
onready var PrintStrayNodes: Button = $VBox/PrintStrayNodes
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
	PrintStrayNodes.connect("pressed", self, "print_stray_nodes")
	FolderSelect.connect("pressed", self, "_select_folder")
	ScriptSelect.connect("pressed", self, "_select_script")
	RunAll.connect("pressed", self, "_run", [], CONNECT_DEFERRED)
	RunFolder.connect("pressed", self, "_run_folder")
	RunScript.connect("pressed", self, "_run_script")
	# We trigger these once before opening them so our popup menu
	# actually pops up, and doesn't get cut off anymore.
	# However this also means they appear on first instance
	# so we need to auto-hide them to look nice
	ScriptSelect.get_popup().hide()
	FolderSelect.get_popup().hide()

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