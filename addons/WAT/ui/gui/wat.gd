tool
extends PanelContainer

enum RUN { ALL, DIRECTORY, SCRIPT, TAGGED }
enum OPTION { ADD_SCRIPT_TEMPLATE, PRINT_STRAY_NODES } # MoveToSelector
const FileSystem: Reference = preload("res://addons/WAT/system/filesystem.gd")
const NOTHING_SELECTED: int = -1
const INVALID_PATH: String = ""
const TestRunner: String = "res://addons/WAT/test_runner/TestRunner.tscn"
signal test_runner_started
signal results_displayed
onready var GUI: VBoxContainer = $GUI
var execute = preload("res://addons/WAT/execute.gd").new()

func _ready() -> void:
	set_process(false)
	GUI.Interact.Run.QuickStart.connect("pressed", self, "_on_run_pressed", [RUN.ALL])
	GUI.Interact.Run.Menu.connect("id_pressed", self, "_on_run_pressed")
	GUI.Results.connect("displayed", self, "display")
	GUI.filesystem = FileSystem

func _on_run_pressed(option: int) -> void:
	set_process(true)
	match option:
		RUN.ALL:
			_run(WAT.Settings.test_directory())
		RUN.DIRECTORY:
			_run(selected(GUI.Interact.Select.DirectorySelector))
		RUN.SCRIPT:
			_run(selected(GUI.Interact.Select.ScriptSelector))
		RUN.TAGGED:
			_run("Tag." + selected(GUI.Interact.Select.TagSelector))

func _run(path: String) -> void:
	GUI.Summary.start_time()
	WAT.Settings.set_run_path(path)
	execute.run(TestRunner)
	
func _process(delta):
	if WAT.Results.exist():
		var results = WAT.Results.withdraw()
		GUI.Summary.summarize(results)
		GUI.Results.display(results)
		set_process(false)

func selected(selector: OptionButton) -> String:
	if selector.selected == NOTHING_SELECTED:
		push_warning("Nothing Selected")
	return selector.get_item_text(selector.selected)
	
func display() -> void:
	EditorPlugin.new().make_bottom_panel_item_visible(self)


