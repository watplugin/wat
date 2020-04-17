extends HBoxContainer
tool

enum OPTION { ADD_SCRIPT_TEMPLATE, PRINT_STRAY_NODES }
const filesystem = preload("res://addons/WAT/system/filesystem.gd")

onready var Run: HBoxContainer = $Run
onready var Select: HBoxContainer = $Select
onready var ViewMenu: MenuButton = $View.get_popup()
onready var MoreMenu: MenuButton = $More.get_popup()
onready var Overwrite: ConfirmationDialog = $More/Overwrite

func _ready():
	ViewMenu.clear()
	MoreMenu.clear()
	ViewMenu.add_item("Expand All Results")
	ViewMenu.add_item("Collapse All Results")
	ViewMenu.add_item("Expand All Failures")
	MoreMenu.add_item("Add Script Templates")
	MoreMenu.add_item("Print Stray Nodes")
	MoreMenu.connect("id_pressed", self, "_on_more_options_pressed")
	Overwrite.connect("confirmed", self, "_save_templates")


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
