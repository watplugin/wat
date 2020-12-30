tool
extends PanelContainer


const TestRunner: String = "res://addons/WAT/test_runner/TestRunner.tscn"
onready var Summary: HBoxContainer = $GUI/Interact/Summary
onready var Results: TabContainer = $GUI/Results
onready var ViewMenu: PopupMenu = $GUI/Interact/View.get_popup()
onready var Repeater: SpinBox = $GUI/Interact/Repeat
var sceneWasLaunched: bool = false
var Context
var EditorContext: Script

func _ready() -> void:
	$GUI/Interact/MenuButton.connect("_test_path_selected", self, "run")
	ViewMenu.connect("id_pressed", $GUI/Results, "_on_view_pressed")
	
func _process(delta):
	if Context != null and Context.is_finished() and sceneWasLaunched:
		sceneWasLaunched = false
		_display_results()

func duplicate_tests(tests: Array, repeat: int) -> Array:
	var duplicates = []
	for test in tests:
		for i in repeat:
			duplicates.append(test.duplicate())
	tests += duplicates
	return tests

func run(tests = []) -> void:
	tests = duplicate_tests(tests, Repeater.value as int)
	_run_as_editor(tests) if Engine.is_editor_hint() else _run_as_game(tests)
	sceneWasLaunched = true
	
func _run_as_editor(tests):
	Context = EditorContext.new()
	add_child(Context)
	Context.run(tests, self)
	
func _run_as_game(tests) -> void:
	var instance = preload(TestRunner).instance()
	instance.is_editor = false
	instance.tests = tests
	instance.connect("finished", self, "_display_results")
	Summary.start_time()
	add_child(instance)

func _display_results() -> void:
	if is_instance_valid(Context):
		Context.free()
	var results: Array = WAT.Settings.results().retrieve()
	Summary.summarize(results)
	Results.display(results)
	
func results() -> Resource:
	return ResourceLoader.load(ProjectSettings.get_setting("WAT/Results_Directory") + "/Results.tres", "", true)
