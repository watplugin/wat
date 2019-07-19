extends PanelContainer
tool

# DEFAULTS
const RUNNER: Script = preload("res://addons/WAT/Runner/runner.gd")
const SETTINGS: Resource = preload("res://addons/WAT/Settings/Config.tres")
const FILESYSTEM: Script = preload("res://addons/WAT/utils/filesystem.gd")
const VALIDATE: Script = preload("res://addons/WAT/runner/validator.gd")
var Runner: Node
var TotalTimer: Node

func _ready():
	var Results = get_node("UI/Runner/Results")
	Results.settings = SETTINGS
	Runner = RUNNER.new(VALIDATE, FILESYSTEM, SETTINGS, Results)
	add_child(Runner)

	var RunAll = get_node("UI/Runner/Options/VBox/RunAll")
	var Expand = get_node("UI/Runner/Options/VBox/Expand")
	var Options = get_node("UI/Runner/Options")
	TotalTimer = get_node("UI/Runner/Details/Timer")

	# Connect Nodes
	RunAll.connect("pressed", TotalTimer, "_start") # Doesn't seem to change anything?
	Runner.connect("ended", TotalTimer, "_stop")
	Runner.connect("errored", TotalTimer, "_stop")
	Expand.connect("pressed", Results, "_collapse_all", [Expand])
	Options.connect("START_TIME", TotalTimer, "_start")
	Options.connect("RUN", self, "_run")

func _run(path: String = "res://tests") -> void:
	Runner.run(path) # Our call-deferred may cause issues here