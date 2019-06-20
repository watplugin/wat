extends HBoxContainer
tool

onready var FolderSelect: OptionButton = $Folder/Select
onready var ScriptSelect: OptionButton = $TestScript/Select
onready var MethodSelect: OptionButton = $Method/Select
onready var RunFolder: OptionButton = $Folder/Run
onready var RunScript: OptionButton = $TestScript/Run
onready var RunMethod: OptionButton = $Method/Run
signal RUN

func _ready() -> void:
	_connect()

func _connect():
	FolderSelect.connect("pressed", self, "_select_folder")
	ScriptSelect.connect("pressed", self, "_select_script")
	MethodSelect.connect("pressed", self, "_select_method")
	RunFolder.connect("pressed", self, "_run_folder")
	RunScript.connect("pressed", self, "_run_script")
	RunMethod.connect("pressed", self, "_run_method")

func _select_folder() -> void:
	FolderSelect.clear()
	FolderSelect.add_item("res://tests")
	var dir: Directory = Directory.new()
	dir.open("res://tests")
	dir.list_dir_begin(true) # Only Search Children
	var folder = dir.get_next()
	while folder != "":
		if dir.current_is_dir():
			FolderSelect.add_item("res://tests/%s" % folder)
		folder = dir.get_next()

func _select_script() -> void:
	ScriptSelect.clear()
	var dir: Directory = Directory.new()
	var path: String = FolderSelect.get_item_text(FolderSelect.selected)
	dir.open(path)
	dir.list_dir_begin(true) # Only Search Children
	var file = dir.get_next()
	while file != "":
		if _valid_test(file):
			ScriptSelect.add_item("%s/%s" % [path, file])
		file = dir.get_next()

func _select_method() -> void:
	MethodSelect.clear()
	var test = load(ScriptSelect.get_item_text(ScriptSelect.selected)).new()
	for method in test.get_method_list():
		if _valid_method(method.name):
			MethodSelect.add_item(method.name)

func _run_folder() -> void:
	var tests: Array = []
	var dir: Directory = Directory.new()
	var path: String = FolderSelect.get_item_text(FolderSelect.selected)
	dir.open(path)
	dir.list_dir_begin(true)
	var file = dir.get_next()
	while file != "":
		if _valid_test(file):
			tests.append(load("%s/%s" % [path, file]))
		file = dir.get_next()
	emit_signal("RUN", tests)

func _run_script() -> void:
	if not ScriptSelect.items.size() > 0:
		OS.alert("No Scripts to Select")
		return
	var path: String = ScriptSelect.get_item_text(ScriptSelect.selected)
	if _valid_test(path):
		emit_signal("RUN", [load(path)])
	else:
		OS.alert("Not a Valid Test Script")

func _run_method() -> void:
	OS.alert("Not Implemented Yet")

func _valid_test(file: String) -> bool:
	return file.ends_with(".gd")

func _valid_method(method: String) -> bool:
	return method.begins_with("test_")