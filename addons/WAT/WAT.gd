extends PanelContainer
tool

# DEFAULTS
const RUNNER: Script = preload("res://addons/WAT/Runner/runner.gd")
const FILESYSTEM: Script = preload("res://addons/WAT/filesystem.gd")
var Runner: Node
var Results: Node

func _ready() -> void:
	Results = get_node("Runner/Results")
	Runner = RUNNER.new(FILESYSTEM)
	Runner.connect("ended", Results, "display")
	add_child(Runner)
#	Runner.output = $Runner/Details/TextEdit
	Runner.name = Runner.MAIN
	get_node("Runner/Options").connect("RUN", self, "_run")
	Runner.connect("ended", $Runner/Details/Timer, "_stop")

	# Need to refactor this to be a lot less odd?
	var Expand = get_node("Runner/Options/VBox/Expand")
	Expand.connect("pressed", Results, "_collapse_all", [Expand])

func _run(path: String) -> void:
	Results.clear()
	$Runner/Details/Timer.start()
	Runner.run(path) # Our call-deferred may cause issues here