extends HBoxContainer
tool

# We could possibly split this into at least two subscenes
# the first for our run options
# the second for our selector options
# the subsplit would also be good for naming (but we may still require the
# hbox parent?

enum OPTION { ADD_SCRIPT_TEMPLATE, PRINT_STRAY_NODES }
const filesystem = preload("res://addons/WAT/system/filesystem.gd")

onready var Run: HBoxContainer = $Run
onready var ViewMenu: MenuButton = $View.get_popup()
onready var MoreMenu: MenuButton = $More.get_popup()
onready var Overwrite: ConfirmationDialog = $More/Overwrite

onready var DirectorySelector: OptionButton = $DirectorySelector
onready var ScriptSelector: OptionButton = $ScriptSelector
onready var TagSelector: OptionButton = $TagSelector

func _ready():
	ViewMenu.clear()
	MoreMenu.clear()
	ViewMenu.add_item("Expand All Results")
	ViewMenu.add_item("Collapse All Results")
	ViewMenu.add_item("Expand All Failures")
	MoreMenu.add_item("Add Script Templates")
	MoreMenu.add_item("Print Stray Nodes")
	MoreMenu.connect("id_pressed", self, "_on_more_options_pressed")
	DirectorySelector.connect("pressed", self, "_on_directory_selector_pressed")
	ScriptSelector.connect("pressed", self, "_on_script_selector_pressed")
	TagSelector.connect("pressed", self, "_on_tag_selector_pressed")
	ViewMenu.connect("id_pressed", self, "_on_view_pressed")
	Overwrite.connect("confirmed", self, "_save_templates")

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

# Could Refactor
func _on_more_options_pressed(id: int) -> void:
	match id:
		OPTION.ADD_SCRIPT_TEMPLATE:
			add_templates()
		OPTION.PRINT_STRAY_NODES:
			print_stray_nodes()

func add_templates():
	var data = filesystem.templates()
	if data.exists:
		Overwrite.popup_centered()
	else:
		_save_templates()
		
func _save_templates() -> void:
	var path = ProjectSettings.get_setting("editor/script_templates_search_path")
	var wat_template = load("res://addons/WAT/test/template.gd")
	var savepath: String = "%s/wat.test.gd" % path
	ResourceSaver.save(savepath, wat_template)
