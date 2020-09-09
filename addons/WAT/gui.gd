tool
extends PanelContainer

const Strategy: Script = preload("res://addons/WAT/core/test_runner/strategy.gd")
enum RESULTS { EXPAND_ALL, COLLAPSE_ALL, EXPAND_FAILURES }
enum RUN { ALL, DIRECTORY, SCRIPT, TAGGED, METHOD, RERUN_FAILURES }
const NOTHING_SELECTED: int = -1
const filesystem = preload("res://addons/WAT/system/filesystem.gd")
const TestRunner: String = "res://addons/WAT/core/test_runner/TestRunner.tscn"
onready var GUI: VBoxContainer = $GUI
onready var Interact: HBoxContainer = $GUI/Interact
onready var Summary: Label = $GUI/Summary
onready var Results: TabContainer = $GUI/Results
onready var Run: HBoxContainer = $GUI/Interact/Run
onready var Select: HBoxContainer = $GUI/Interact/Select
onready var ViewMenu: PopupMenu = $GUI/Interact/View.get_popup()
onready var QuickStart: Button = $GUI/Interact/Run/QuickStart
onready var Menu: PopupMenu = $GUI/Interact/Run/Menu.get_popup()
onready var DirectorySelector: OptionButton = $GUI/Interact/Select/Directory
onready var ScriptSelector: OptionButton = $GUI/Interact/Select/Script
onready var TagSelector: OptionButton = $GUI/Interact/Select/Tag
onready var Repeater: SpinBox = $GUI/Interact/Repeat
onready var HiddenBorder: Separator = $GUI/HiddenBorder
onready var MethodSelector: OptionButton = $GUI/Method
onready var More: Button = $GUI/Interact/More
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
	More.connect("pressed", self, "_show_more")
	_link($GUI/Links/Issue, "https://github.com/CodeDarigan/WAT/issues/new")
	_link($GUI/Links/RequestDocs, "https://github.com/CodeDarigan/WATDocs/issues/new")
	_link($GUI/Links/OnlineDocs, "https://wat.readthedocs.io/en/latest/index.html")
	_link($GUI/Links/Support, "https://www.ko-fi.com/alexanddraw")
	Menu.clear()
	Menu.add_item("Run All Tests")
	Menu.add_item("Run Selected Directory")
	Menu.add_item("Run Selected Script")
	Menu.add_item("Run Tagged")
	Menu.add_item("Run Method")
	Menu.add_item("Rerun Failures")
	ViewMenu.clear()
	ViewMenu.add_item("Expand All Results")
	ViewMenu.add_item("Collapse All Results")
	ViewMenu.add_item("Expand All Failures")
	QuickStart.connect("pressed", self, "_on_run_pressed", [RUN.ALL])
	Menu.connect("id_pressed", self, "_on_run_pressed")
	ViewMenu.connect("id_pressed", $GUI/Results, "_on_view_pressed")
	DirectorySelector.clear()
	ScriptSelector.clear()
	TagSelector.clear()
	DirectorySelector.add_item("Select Directory")
	ScriptSelector.add_item("Select Script")
	TagSelector.add_item("Select Tag")
	DirectorySelector.connect("pressed", self, "_on_directory_selector_pressed")
	ScriptSelector.connect("pressed", self, "_on_script_selector_pressed")
	TagSelector.connect("pressed", self, "_on_tag_selector_pressed")
	MethodSelector.connect("pressed", self, "_on_method_selector_pressed")
	ScriptSelector.get_popup().hide()
	TagSelector.get_popup().hide()
	
func _show_more() -> void:
	MethodSelector.visible = not MethodSelector.visible
	HiddenBorder.visible = MethodSelector.visible
	
func _on_method_selector_pressed() -> void:
	MethodSelector.clear()
	var path: String = ScriptSelector.get_item_text(ScriptSelector.selected)
	if not path.ends_with(".gd"):
		MethodSelector.add_item("Please Select A Script First")
		return
	var script = load(path)
	for method in script.get_script_method_list():
		if method.name.begins_with("test"):
			MethodSelector.add_item(method.name)

func _on_run_pressed(option: int) -> void:
	set_process(true)
	ProjectSettings.set("WAT/TestStrategy", {})
	ProjectSettings.save()
	match option:
		RUN.ALL:
			Strategy.RunAll(Repeater.value as int)
		RUN.DIRECTORY:
			Strategy.RunDirectory(selected(DirectorySelector), Repeater.value as int)
		RUN.SCRIPT:
			Strategy.RunScript(selected((ScriptSelector)), Repeater.value as int)
		RUN.TAGGED:
			Strategy.RunTag(selected(TagSelector), Repeater.value as int)
		RUN.METHOD:
			Strategy.RunMethod(selected(ScriptSelector), selected(MethodSelector), Repeater.value as int)
		RUN.RERUN_FAILURES:
			Strategy.RunFailures(Repeater.value as int)
	_run()

func _run() -> void:
	start_time()
	Results.clear()
	if(Engine.is_editor_hint()):
		execute.run(TestRunner)
		EditorPlugin.new().make_bottom_panel_item_visible(self)
	else:
		var n = load(TestRunner).instance()
		n.is_editor = false
		add_child(n)
		print("run as child")
	#EditorPlugin.new().make_bottom_panel_item_visible(self)
	
func _process(delta):
	if WAT.Results.exist():
		var results = WAT.Results.withdraw()
		summarize(results)
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
	
func set_run_path(path: String) -> void:
	ProjectSettings.set("WAT/ActiveRunPath", path)

const SUMMARY: String = \
"Time Taken: {t} | Ran {r} Tests | {p} Tests Passed | {f} Tests Failed | Ran Tests {e} Times"

var time: float = 0
var passed: int = 0
var failed: int = 0
var total: int = 0
var runcount: int = 0

func start_time() -> void:
	runcount += 1
	time = OS.get_ticks_msec()

func summarize(caselist: Array) -> void:
	time = (OS.get_ticks_msec() - time) / 1000
	passed = 0
	failed = 0
	total = 0
	for case in caselist:
		total += 1
		if case.success:
			passed += 1
		else:
			failed += 1
	var summary = {t = time, r = total, p = passed, f = failed, e = runcount}
	$GUI/Summary.text = SUMMARY.format(summary)
