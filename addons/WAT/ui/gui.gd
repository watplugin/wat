tool
extends PanelContainer

enum RESULTS { EXPAND_ALL, COLLAPSE_ALL, EXPAND_FAILURES }
enum RUN { ALL, DIRECTORY, SCRIPT, TAGGED, METHOD, RERUN_FAILURES }
const NOTHING_SELECTED: int = -1
const filesystem = preload("res://addons/WAT/system/filesystem.gd")
const TestRunner: String = "res://addons/WAT/test_runner/TestRunner.tscn"
onready var GUI: VBoxContainer = $GUI
onready var Interact: HBoxContainer = $GUI/Interact
onready var Summary: Label = $GUI/Summary
onready var Results: TabContainer = $GUI/Results
onready var Run: HBoxContainer = $GUI/Interact/Run
onready var Select: HBoxContainer = $GUI/Interact/Select
onready var ViewMenu: PopupMenu = $GUI/Interact/View.get_popup()
onready var QuickStart: Button = $GUI/Interact/Run/QuickStart
onready var Menu: PopupMenu = $GUI/Interact/Run/Menu.get_popup()
onready var Repeater: SpinBox = $GUI/Interact/Repeat
onready var HiddenBorder: Separator = $GUI/HiddenBorder
onready var MethodSelector: OptionButton = $GUI/Method
onready var More: Button = $GUI/Interact/More

var _directory: String
var _script: String
var _tag: String

func get_repeat() -> int:
	return Repeater.value as int
	
var execute = preload("res://addons/WAT/test_runner/execute.gd").new()

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
	
	#set_process(false)
	$Host.connect("ResultsReceived", self, "OnResultsReceived")
	More.connect("pressed", self, "_show_more")
	Menu.clear()
	ViewMenu.clear()
	for item in run_options:
		Menu.add_item(item)
	for item in view_options:
		ViewMenu.add_item(item)
		
	$GUI/Interact/Select.connect("directory_selected", self, "set")
	$GUI/Interact/Select.connect("script_selected", self, "set")
	$GUI/Interact/Select.connect("tag_selected", self, "set")
		
	QuickStart.connect("pressed", self, "_on_run_pressed", [RUN.ALL])
	Menu.connect("id_pressed", self, "_on_run_pressed")
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
	var path: String = _script
	if not path.ends_with(".gd"):
		MethodSelector.add_item("Please Select A Script First")
		return
	var script = load(path)
	for method in script.get_script_method_list():
		if method.name.begins_with("test"):
			MethodSelector.add_item(method.name)

func _on_run_pressed(option: int) -> void:
	var strat: Dictionary = {"repeat": get_repeat()}
	match option:
		RUN.ALL:
			strat["paths"] = filesystem.scripts(test_directory())
		RUN.DIRECTORY:
			strat["paths"] = filesystem.scripts(_directory)
		RUN.SCRIPT:
			strat["paths"] = [_script]
		RUN.TAGGED:
			strat["tag"] = _tag
			# IMPLEMENT THIS
			# strat["paths"] = filesystem.tags(strat["tag"]) // TestCollector, not filesystem?
		RUN.METHOD:
			strat["paths"] = [_script]
			strat["method"] = selected(MethodSelector)
		RUN.RERUN_FAILURES:
			strat["paths"] = Results.get_last_run_failures()
	_run(strat)

func _run(strat) -> void:
	$Host.host()
	Summary.start_time()
	Results.clear()
	if(Engine.is_editor_hint()):
		execute.run(TestRunner)
		EditorPlugin.new().make_bottom_panel_item_visible(self)
	else:
		var n = load(TestRunner).instance()
		n.is_editor = false
		add_child(n)
	yield($Host, "ClientConnected")
	$Host.send_strategy(strat)

func selected(selector: OptionButton) -> String:
	if selector.selected == NOTHING_SELECTED:
		push_warning("Nothing Selected")
	var text = selector.get_item_text(selector.selected)
	print("selected ", text)
	return text

func test_directory() -> String:
	return ProjectSettings.get_setting("WAT/Test_Directory")
