tool
extends VBoxContainer

enum RESULTS { EXPAND_ALL, COLLAPSE_ALL, EXPAND_FAILURES }
onready var RunOptions: MenuButton = $Options/Run.get_popup()
onready var ViewOptions: MenuButton = $Options/View.get_popup()
onready var MoreOptions: OptionButton = $Options/More.get_popup()
onready var DirectorySelector: OptionButton = $Options/DirectorySelector
onready var ScriptSelector: OptionButton = $Options/ScriptSelector
onready var TagSelector: OptionButton = $Options/TagSelector
onready var Results: TabContainer = $Results
onready var Info: HBoxContainer = $Info
onready var QuickPlay: Button = $Options/QuickPlay
var filesystem
var current_main_dir
var tags

func _ready() -> void:
	name = "GUI"
	$Info/Settings.connect("pressed", self, "_open_settings")
	RunOptions.clear()
	ViewOptions.clear()
	MoreOptions.clear()
	RunOptions.connect("id_pressed", self, "_add_run_count")
	RunOptions.add_item("Run All Tests")
	RunOptions.add_item("Run Selected Directory")
	RunOptions.add_item("Run Selected Script")
	RunOptions.add_item("Run Tagged")
	ViewOptions.add_item("Expand All Results")
	ViewOptions.add_item("Collapse All Results")
	ViewOptions.add_item("Expand All Failures")
	MoreOptions.add_item("Add Script Templates")
	MoreOptions.add_item("Print Stray Nodes")
	DirectorySelector.connect("pressed", self, "_on_directory_selector_pressed")
	ScriptSelector.connect("pressed", self, "_on_script_selector_pressed")
	TagSelector.connect("pressed", self, "_on_tag_selector_pressed")
	ViewOptions.connect("id_pressed", self, "_on_view_pressed")
	Info.get_node("Issue").connect("pressed", OS, "shell_open", ["https://github.com/CodeDarigan/WAT/issues/new"], CONNECT_DEFERRED)
	Info.get_node("RequestDocs").connect("pressed", OS, "shell_open", ["https://github.com/CodeDarigan/WAT-docs/issues/new"], CONNECT_DEFERRED)
	Info.get_node("OnlineDocs").connect("pressed", OS, "shell_open", ["https://wat.readthedocs.io/en/latest/index.html"], CONNECT_DEFERRED)
	Info.get_node("Support").connect("pressed", OS, "shell_open", ["https://www.ko-fi.com/alexanddraw"], CONNECT_DEFERRED)

func _open_settings() -> void:
	push_warning("Open Setting Not Implemented")

func _process(delta: float) -> void:
	if WAT.Settings.test_directory() != current_main_dir:
		current_main_dir = ProjectSettings.get_setting("WAT/Test_Directory")
		_show_dir()
	
func _show_dir():
	DirectorySelector.clear()
	DirectorySelector.add_item(ProjectSettings.get_setting("WAT/Test_Directory"))
	update()
	
func _on_directory_selector_pressed() -> void:
	DirectorySelector.clear()
	DirectorySelector.add_item(ProjectSettings.get_setting("WAT/Test_Directory"))
	for directory in filesystem.directories():
		DirectorySelector.add_item(directory)
		
func _on_script_selector_pressed() -> void:
	ScriptSelector.clear()
	for script in filesystem.scripts():
		if script.ends_with(".gd"):
			if load(script).get("TEST") != null:
				ScriptSelector.add_item(script)
			if load(script).get("IS_WAT_SUITE"):
				ScriptSelector.add_item(script)
				
func _on_tag_selector_pressed() -> void:
	TagSelector.clear()
	for tag in ProjectSettings.get_setting("WAT/Tags"):
		TagSelector.add_item(tag)

var _run_count: int = 0
func _add_run_count(id):
	_run_count += 1
	$Info/RunCount.text = "Ran Tests: %s times" % _run_count as String
			
func _on_view_pressed(id: int) -> void:
	match id:
		RESULTS.EXPAND_ALL:
			Results.expand_all()
		RESULTS.COLLAPSE_ALL:
			Results.collapse_all()
		RESULTS.EXPAND_FAILURES:
			Results.expand_failures()
