tool
extends PanelContainer

const EditorContext = preload("res://addons/WAT/ui/editor_context.gd")
const TestRunner: String = "res://addons/WAT/test_runner/TestRunner.tscn"
const RESULTS = preload("res://addons/WAT/cache/Results.tres")
onready var Summary: Label = $GUI/Interact/Summary
onready var Results: TabContainer = $GUI/Results
onready var ViewMenu: PopupMenu = $GUI/Interact/View.get_popup()
onready var QuickStart: Button = $GUI/Interact/QuickStart
onready var Repeater: SpinBox = $GUI/Interact/Repeat
var sceneWasLaunched: bool = false
var filecache
var Context

func _ready() -> void:
	if filecache == null and not Engine.is_editor_hint():
		filecache = preload("res://addons/WAT/cache/test_cache.gd").new()
	filecache.initialize()
	$GUI/Interact/MenuButton.FileCache = filecache
	# QuickStart.connect("pressed", TestRunnerLauncher, "run", [TestRunnerLauncher.RUN.ALL])
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
			var dupe = {"path": test["path"], "script": test["script"]}
			duplicates.append(dupe)
	tests += duplicates
	return tests

func run(tests = [], run_failures = false) -> void:
	if tests == [] and run_failures:
		tests = RESULTS.failed()
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
	var _res = RESULTS.retrieve()
	Summary.summarize(_res)
	Results.clear()
	Results.display(_res)
