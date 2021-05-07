extends VBoxContainer
tool

onready var Quickstart: Button = $Menu/QuickRunAll
onready var QuickstartDebug: Button = $Menu/QuickRunAllDebug
onready var Results: TabContainer = $Results
onready var ViewMenu: PopupMenu = $Menu/ResultsMenu.get_popup()
onready var RunSettings: HBoxContainer = $Menu/RunSettings
onready var RunMenu: Button = $Menu/TestMenu
signal test_strategy_set

func _ready() -> void:
	ViewMenu.connect("index_pressed", Results, "_on_view_pressed")
	Quickstart.connect("pressed", RunMenu, "select_tests", [{command = RunMenu.RUN_ALL, run_in_editor = true}])
	QuickstartDebug.connect("pressed", RunMenu, "select_tests", [{command = RunMenu.RUN_ALL, run_in_editor = false}])
	RunMenu.connect("_tests_selected", self, "_on_tests_selected")
	var shortcut = ProjectSettings.get_setting("WAT/Run_All_Tests")
	Quickstart.shortcut.shortcut = shortcut
	$Menu/SaveMetadata.connect("pressed", RunMenu, "save_metadata")

func _on_tests_selected(tests: Array, run_in_editor: bool) -> void:
	var repeats: int = RunSettings.repeats
	tests = _repeat(tests, RunSettings.repeats)
	var threads: int = RunSettings.threads
	emit_signal("test_strategy_set", tests, threads, run_in_editor)
	
func _repeat(tests: Array, repeat: int) -> Array:
	var duplicates: Array = []
	for idx in repeat:
		for test in tests:
			duplicates.append(test)
	duplicates += tests
	return duplicates
