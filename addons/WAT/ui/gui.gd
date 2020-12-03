tool
extends PanelContainer

enum RESULTS { EXPAND_ALL, COLLAPSE_ALL, EXPAND_FAILURES }
const NOTHING_SELECTED: int = -1
onready var Summary: Label = $GUI/Summary
onready var Results: TabContainer = $GUI/Results
onready var Run: HBoxContainer = $GUI/Interact/Run
onready var ViewMenu: PopupMenu = $GUI/Interact/View.get_popup()
onready var QuickStart: Button = $GUI/Interact/Run/QuickStart
onready var Menu: PopupMenu = $GUI/Interact/Run/Menu.get_popup()
onready var Repeater: SpinBox = $GUI/Interact/Repeat
onready var HiddenBorder: Separator = $GUI/HiddenBorder
onready var MethodSelector: OptionButton = $GUI/Method
onready var More: Button = $GUI/Interact/More

# Refactored Variables
onready var Selection: HBoxContainer = $GUI/Interact/Select

func get_repeat() -> int:
	return Repeater.value as int

export(PoolStringArray) var run_options: PoolStringArray
export(PoolStringArray) var view_options: PoolStringArray

func _on_view_pressed(id: int) -> void:
	match id:
		RESULTS.EXPAND_ALL:
			Results.expand_all()
		RESULTS.COLLAPSE_ALL:
			Results.collapse_all()
		RESULTS.EXPAND_FAILURES:
			Results.expand_failures()

func _ready() -> void:
	# Begin Mediator Refactor
	var TestRunnerLauncher = get_node("Controllers/TestRunnerLauncher")
	TestRunnerLauncher.Server = $Host
	TestRunnerLauncher.Root = self
	QuickStart.connect("pressed", TestRunnerLauncher, "_on_run_pressed", [TestRunnerLauncher.RUN.ALL])
	Menu.connect("id_pressed", TestRunnerLauncher, "_on_run_pressed")
	TestRunnerLauncher.Selection = $GUI/Interact/Select
	$GUI/MenuButton.connect("_test_path_selected", TestRunnerLauncher, "run")
	# End Mediator Refactor
	
	
	$Host.connect("results_received", self, "OnResultsReceived")
	More.connect("pressed", self, "_show_more")
	Menu.clear()
	ViewMenu.clear()
	for item in run_options:
		Menu.add_item(item)
	for item in view_options:
		ViewMenu.add_item(item)
	ViewMenu.connect("id_pressed", $GUI/Results, "_on_view_pressed")

	MethodSelector.connect("pressed", self, "_on_method_selector_pressed")
	
func OnResultsReceived(results: Array) -> void:
	Summary.summarize(results)
	Results.display(results)
	
func _show_more() -> void:
	MethodSelector.visible = not MethodSelector.visible
	HiddenBorder.visible = MethodSelector.visible
	
func _on_method_selector_pressed() -> void:
	MethodSelector.clear()
	var path: String = $GUI/Interact/Select.get_script()[0]
	if not path.ends_with(".gd"):
		MethodSelector.add_item("Please Select A Script First")
		return
	var script = load(path)
	for method in script.get_script_method_list():
		if method.name.begins_with("test"):
			MethodSelector.add_item(method.name)

func selected(selector: OptionButton) -> String:
	if selector.selected == NOTHING_SELECTED:
		push_warning("Nothing Selected")
	var text = selector.get_item_text(selector.selected)
	print("selected ", text)
	return text
