extends PanelContainer
tool

# DEFAULTS
const RUNNER: Script = preload("res://addons/WAT/Runner/runner.gd")
const SETTINGS: Resource = preload("res://addons/WAT/Settings/Config.tres")
const FILESYSTEM: Script = preload("res://addons/WAT/utils/filesystem.gd")
const VALIDATE: Script = preload("res://addons/WAT/runner/validator.gd")
var Runner: Node

func _ready():
	var Results = get_node("UI/Runner/Results")
	Results.settings = SETTINGS
	Runner = RUNNER.new(VALIDATE, FILESYSTEM, SETTINGS, Results)
	add_child(Runner)

	var RunAll = get_node("UI/Runner/Options/VBox/RunAll")
	var Expand = get_node("UI/Runner/Options/VBox/Expand")
	var Options = get_node("UI/Runner/Options")
	Expand.connect("pressed", Results, "_collapse_all", [Expand])
	Options.connect("RUN", self, "_run")

func _run(path: String = "res://tests") -> void:
	Runner.run(path) # Our call-deferred may cause issues here