extends HBoxContainer
tool

const CONFIG = preload("res://addons/WAT/Settings/Config.tres")
const FILESYSTEM = preload("res://addons/WAT/utils/filesystem.gd")
onready var FolderSelect: OptionButton = $Folder/Select
onready var ScriptSelect: OptionButton = $TestScript/Select
onready var RunFolder: OptionButton = $Folder/Run
onready var RunScript: OptionButton = $TestScript/Run
onready var PrintStrayNodes: Button = $Debug/PrintStrayNodes
signal RUN
signal START_TIME

func run(path: String) -> void:
	emit_signal("START_TIME")
	emit_signal("RUN", path)

func _ready() -> void:
	_select_folder()
	_select_script()
	_connect()

func _connect():
	PrintStrayNodes.connect("pressed", self, "print_stray_nodes")
	FolderSelect.connect("pressed", self, "_select_folder")
	ScriptSelect.connect("pressed", self, "_select_script")
	RunFolder.connect("pressed", self, "_run_folder")
	RunScript.connect("pressed", self, "_run_script")
	# We trigger these once before opening them so our popup menu
	# actually pops up, and doesn't get cut off anymore.
	# However this also means they appear on first instance
	# so we need to auto-hide them to look nice
	ScriptSelect.get_popup().hide()
	FolderSelect.get_popup().hide()

func _select_folder(path: String = CONFIG.main_test_folder) -> void:
	if not Directory.new().dir_exists(path):
		return
	FolderSelect.clear()
	FolderSelect.add_item(path)
	for directory in FILESYSTEM.directory_list(path):
		FolderSelect.add_item(directory)
#	FolderSelect.get_popup()

func _select_script() -> void:
	ScriptSelect.clear()
	for file in FILESYSTEM.file_list(_selected(FolderSelect)):
		if _valid_test(file.name) and file.path == ("%s/%s" % [_selected(FolderSelect), file.name]):
			ScriptSelect.add_item(file.path)
	ScriptSelect.get_popup().popup()
#	open_and_close(ScriptSelect)
	

func _run_folder() -> void:
	if _exists(FolderSelect):
		run(_selected(FolderSelect))

func _run_script() -> void:
	if _exists(ScriptSelect):
		run(_selected(ScriptSelect))

func _exists(list: OptionButton) -> bool:
	if list.items.empty():
		OS.alert("Nothing to Run")
		return false
	return true

func _valid_test(file: String) -> bool:
	return file.ends_with(".gd")

func _selected(item: OptionButton) -> String:
	return item.get_item_text(item.selected)