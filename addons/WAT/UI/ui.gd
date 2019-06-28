extends PanelContainer
tool

# DEFAULTS
const RUNNER: Script = preload("res://addons/WAT/Runner/runner.gd")
const YIELDER: Script = preload("res://addons/WAT/Runner/Yielder.gd")
const SETTINGS: Resource = preload("res://addons/WAT/Settings/Config.tres")
const FILESYSTEM: Script = preload("res://addons/WAT/utils/filesystem.gd")
const VALIDATE: Script = preload("res://addons/WAT/runner/validator.gd")

func _ready():
	var Results = get_node("UI/Runner/Results")
	Results.settings = SETTINGS
	var Runner: Node = RUNNER.new(VALIDATE, FILESYSTEM, SETTINGS, YIELDER.new(), Results)
	add_child(Runner)

	var RunAll = get_node("UI/Runner/Options/VBox/RunAll")
	var Expand = get_node("UI/Runner/Options/VBox/Expand")
	var Options = get_node("UI/Runner/Options")
	var TotalTimer = get_node("UI/Runner/Details/Timer")

	# Connect Nodes
	RunAll.connect("pressed", TotalTimer, "_start")
	RunAll.connect("pressed", Runner, "_run")
	Runner.connect("ended", TotalTimer, "_stop")
	Expand.connect("pressed", Results, "_collapse_all", [Expand])
	Options.connect("START_TIME", TotalTimer, "_start")
	Options.connect("RUN", Runner, "_run")