tool
extends HBoxContainer

enum RESULTS { EXPAND_ALL, COLLAPSE_ALL }
const NOTHING_SELECTED: int = -1
const INVALID_PATH: String = ""
onready var RunOptions: MenuButton = $Options/Run.get_popup()
onready var ViewOptions: MenuButton = $Options/View.get_popup()
onready var MoreOptions: OptionButton = $Options/More.get_popup()
#onready var Overwrite: AcceptDialog = $Options/More/Overwrite
onready var DirectorySelector: OptionButton = $Options/DirectorySelector
onready var ScriptSelector: OptionButton = $Options/ScriptSelector
onready var Results: TabContainer = $Results
onready var Info: HBoxContainer = $Info
var filesystem

func _ready() -> void:
	name = "GUI"
	print("Hello World From GUI!!!!")
	RunOptions.clear()
	ViewOptions.clear()
	MoreOptions.clear()
	RunOptions.add_item("Run All Tests")
	RunOptions.add_item("Run Selected Directory")
	RunOptions.add_item("Run Selected Script")
	ViewOptions.add_item("Expand All Results")
	ViewOptions.add_item("Collapse All Results")
	MoreOptions.add_item("Add Script Templates")
	MoreOptions.add_item("Print Stray Nodes")
	DirectorySelector.connect("pressed", self, "_on_directory_selector_pressed")
	ScriptSelector.connect("pressed", self, "_on_script_selector_pressed")
	ViewOptions.connect("id_pressed", self, "_on_view_pressed")
	
func selected(selector: OptionButton) -> String:
	if selector.selected == NOTHING_SELECTED:
		push_warning("Nothing Selected")
		return INVALID_PATH
	return selector.get_item_text(selector.selected)
	
func _on_directory_selector_pressed() -> void:
	DirectorySelector.clear()
	for directory in filesystem.directories():
		DirectorySelector.add_item(directory)
		
func _on_script_selector_pressed() -> void:
	ScriptSelector.clear()
	for script in filesystem.scripts():
		if script.ends_with(".gd") and load(script).get("TEST") != null:
			ScriptSelector.add_item(script)
			
func _on_view_pressed(id: int) -> void:
	match id:
		RESULTS.EXPAND_ALL:
			Results.expand_all()
		RESULTS.COLLAPSE_ALL:
			Results.collapse_all()
