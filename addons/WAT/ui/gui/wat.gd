tool
extends PanelContainer

enum RESULTS { EXPAND_ALL, COLLAPSE_ALL, EXPAND_FAILURES }
enum RUN { ALL, DIRECTORY, SCRIPT, TAGGED }
const NOTHING_SELECTED: int = -1
const filesystem = preload("res://addons/WAT/system/filesystem.gd")
const TestRunner: String = "res://addons/WAT/core/test_runner/TestRunner.tscn"
onready var GUI: VBoxContainer = $GUI
onready var Interact: HBoxContainer = $GUI/Interact
onready var Summary: Label = $GUI/Summary
onready var Results: TabContainer = $GUI/Results
onready var Run: HBoxContainer = $GUI/Interact/Run
onready var Select: HBoxContainer = $GUI/Interact/Select
onready var ViewMenu: MenuButton = $GUI/Interact/View.get_popup()
onready var QuickStart: Button = $GUI/Interact/Run/QuickStart
onready var Menu: MenuButton = $GUI/Interact/Run/Menu.get_popup()
onready var DirectorySelector: OptionButton = $GUI/Interact/Select/Directory
onready var ScriptSelector: OptionButton = $GUI/Interact/Select/Script
onready var TagSelector: OptionButton = $GUI/Interact/Select/Tag
var execute = preload("res://addons/WAT/core/test_runner/execute.gd").new()

func _on_view_pressed(id: int) -> void:
	match id:
		RESULTS.EXPAND_ALL:
			Results.expand_all()
		RESULTS.COLLAPSE_ALL:
			Results.collapse_all()
		RESULTS.EXPAND_FAILURES:
			Results.expand_failures()

func _ready() -> void:
	set_process(false)
	_link($GUI/Links/Issue, "https://github.com/CodeDarigan/WAT/issues/new")
	_link($GUI/Links/RequestDocs, "https://github.com/CodeDarigan/WAT-docs/issues/new")
	_link($GUI/Links/OnlineDocs, "https://wat.readthedocs.io/en/latest/index.html")
	_link($GUI/Links/Support, "https://www.ko-fi.com/alexanddraw")
	Menu.clear()
	Menu.add_item("Run All Tests")
	Menu.add_item("Run Selected Directory")
	Menu.add_item("Run Selected Script")
	Menu.add_item("Run Tagged")
	ViewMenu.clear()
	ViewMenu.add_item("Expand All Results")
	ViewMenu.add_item("Collapse All Results")
	ViewMenu.add_item("Expand All Failures")
	QuickStart.connect("pressed", self, "_on_run_pressed", [RUN.ALL])
	Menu.connect("id_pressed", self, "_on_run_pressed")
	ViewMenu.connect("id_pressed", $GUI/Results, "_on_view_pressed")
	DirectorySelector.clear()
	DirectorySelector.add_item("Select Directory")
	ScriptSelector.add_item("Select Script")
	TagSelector.add_item("Select Tag")
	DirectorySelector.connect("pressed", self, "_on_directory_selector_pressed")
	ScriptSelector.connect("pressed", self, "_on_script_selector_pressed")
	TagSelector.connect("pressed", self, "_on_tag_selector_pressed")

func _on_run_pressed(option: int) -> void:
	set_process(true)
	match option:
		RUN.ALL:
			_run(test_directory())
		RUN.DIRECTORY:
			_run(selected(GUI.Interact.Select.DirectorySelector))
		RUN.SCRIPT:
			_run(selected(GUI.Interact.Select.ScriptSelector))
		RUN.TAGGED:
			_run("Tag." + selected(GUI.Interact.Select.TagSelector))

func _run(path: String) -> void:
	Summary.start_time()
	Results.clear()
	WAT.Settings.set_run_path(path)
	execute.run(TestRunner)
	EditorPlugin.new().make_bottom_panel_item_visible(self)
	
func _process(delta):
	if WAT.Results.exist():
		var results = WAT.Results.withdraw()
		Summary.summarize(results)
		Results.display(results)
		set_process(false)

func selected(selector: OptionButton) -> String:
	if selector.selected == NOTHING_SELECTED:
		push_warning("Nothing Selected")
	return selector.get_item_text(selector.selected)

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

func _link(button: Button, link: String):
	button.connect("pressed", OS, "shell_open", [link], CONNECT_DEFERRED)
	
func test_directory() -> String:
	return ProjectSettings.get_setting("WAT/Test_Directory")
