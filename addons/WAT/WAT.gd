extends PanelContainer
tool

# DEFAULTS
const RUNNER: Script = preload("res://addons/WAT/Runner/runner.gd")
const FILESYSTEM: Script = preload("res://addons/WAT/filesystem.gd")
var Runner: Node
var Results: Node
var run_count: int = 0

func _ready() -> void:
	Results = get_node("Runner/Results")
	Runner = RUNNER.new(FILESYSTEM)
	Runner.connect("ended", Results, "display")
	add_child(Runner)
	Runner.name = Runner.MAIN
	get_node("Runner/Options").connect("RUN", self, "_run")
	Runner.connect("ended", $Runner/Details/Timer, "_stop")
	set_up_expand_and_collapse()
	
func set_up_expand_and_collapse():
	var expand = get_node("Runner/Options/FormatResults/Expand")
	var collapse = get_node("Runner/Options/FormatResults/Collapse")
	expand.connect("pressed", Results, "_expand_all")
	collapse.connect("pressed", Results, "_collapse_all")

func _run(path: String) -> void:
	Results.clear()
	$Runner/Details/Timer.start()
	run_count += 1
	$Runner/Details/RunCount.text = "Ran Tests: %s Times" % run_count as String
	Runner.run(path) # Our call-deferred may cause issues here