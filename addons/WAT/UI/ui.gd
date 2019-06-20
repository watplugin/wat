extends PanelContainer
tool

onready var Runner = $Runner
onready var Results = $"UI/Runner/Results/All Tests/Display"
onready var RunAll = $UI/Runner/Options/RunAll
onready var Output = $UI/Runner/Output

func _ready():
	Output.connect("finished", Runner, "_finish")
	RunAll.connect("pressed", Runner, "_run")
	Runner.connect("output", Output, "_output")
	Runner.Yield.connect("resume", Runner, "_post")
	Runner.connect("display_results", Results, "_display_results")

#onready var Results = $UI/Middle/Results
#onready var Run = $UI/Middle/Menu/Buttons/Run
#onready var Clear = $UI/Middle/Menu/Buttons/Clear
#onready var Output = $UI/Output
#onready var Runner = $Runner
#
#onready var printstraynodes = $UI/Middle/Menu/Buttons/PrintStrayNodes
#
#### SETTINGS
#onready var parameters = $UI/Middle/Menu/Typing/Parameters
#onready var retvals = $UI/Middle/Menu/Typing/ReturnValue
#onready var excludevoid = $UI/Middle/Menu/Typing/ExcludeVoid
#onready var scriptprefixes = $UI/Middle/Menu/Prefix/Script
#onready var methodprefixes = $UI/Middle/Menu/Prefix/Method
#onready var default = $UI/Middle/Menu/DefaultSettings
#onready var RunScript = $UI/MainMenu/RunScript
#onready var ScriptSelect = $UI/MainMenu/ScriptSelect
#onready var ExpandAll = $UI/Middle/Menu/Buttons/ExpandAll
#
#func _ready():
#	RunScript.connect("pressed", ScriptSelect, "_run_test")
#	ScriptSelect.connect("RUN_SINGLE", Runner, "_run")
#	ExpandAll.connect("pressed", Results, "_expand_all", [ExpandAll])

#	_default(false)
##	update_settings_display()
#	connect_buttons()
#	connect_settings()
#
#func connect_buttons():
#	printstraynodes.connect("pressed", self, "print_stray_nodes")
#	Run.connect("pressed", Runner, "_run")
#	Runner.connect("CLEARED", Results, "reset")
#	Runner.connect("CLEARED", Output, "_clear")
#	Runner.connect("display_results", Results, "_display_results") # May need to change display here?
#	Clear.connect("pressed", Results, "reset")
#	Clear.connect("pressed", Output, "_clear")
#	Runner.connect("output", Output, "_output")

#
#func connect_settings():
#	parameters.connect("pressed", WATConfig, "_set_parameters", [parameters])
#	retvals.connect("pressed", WATConfig, "_set_return_value", [retvals])
#	excludevoid.connect("pressed", WATConfig, "_set_exclude_void", [excludevoid])
#	scriptprefixes.connect("text_changed", WATConfig, "_set_script_prefixes")
#	methodprefixes.connect("text_changed", WATConfig, "_set_method_prefixes")
#	default.connect("pressed", self, "_default", [true])
#
#func _default(force: bool):
#	parameters.pressed = true
#	retvals.pressed = true
#	excludevoid.pressed = true
#	scriptprefixes.text = ""
#	methodprefixes.text = ""
#	WATConfig.defaults(force)
#	update_settings_display()
#
#func update_settings_display():
#	parameters.pressed = WATConfig.parameters()
#	retvals.pressed = WATConfig.return_value()
#	excludevoid.pressed = WATConfig.void_excluded()
#	scriptprefixes.text = WATConfig.script_prefixes()
#	methodprefixes.text = WATConfig.method_prefixes()