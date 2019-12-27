tool
extends PanelContainer

# DEFAULTS
const RUNNER: Script = preload("res://addons/WAT/runner/runner.gd")
const FILESYSTEM: Script = preload("res://addons/WAT/filesystem.gd")
var Runner: Node
var Results: Node
var Options: Node
var run_count: int = 0
var options_view_popup: Node

func _ready() -> void:
	Options = $Runner/Options
	Results = get_node("Runner/Results")
	Runner = RUNNER.new(FILESYSTEM)
	Runner.connect("ended", Results, "display")
	add_child(Runner)
	Runner.name = Runner.MAIN
	Options.connect("RUN", self, "_run")
	Runner.connect("ended", $Runner/Details/Timer, "_stop")
	options_view_popup = $Runner/Options/View.get_popup()
	options_view_popup.connect("id_pressed", self, "set_up_expand_and_collapse")

func set_up_expand_and_collapse(option_id):
	match option_id:
		0:
			Results._expand_all()
		1:
			Results._collapse_all()

func _run(path: String) -> void:
	Results.clear()
	$Runner/Details/Timer.start()
	run_count += 1
	$Runner/Details/RunCount.text = "Ran Tests: %s Times" % run_count as String
	Runner.run(path) # Our call-deferred may cause issues here