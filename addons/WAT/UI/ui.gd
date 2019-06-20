extends PanelContainer
tool

onready var Runner = $Runner
onready var Results = $"UI/Runner/Results/"
onready var RunAll = $UI/Runner/Options/VBox/RunAll
onready var Output = $UI/Runner/Output

func _ready():
	Output.connect("finished", Runner, "_finish")
	RunAll.connect("pressed", Runner, "_run")
	Runner.connect("output", Output, "_output")
	Runner.Yield.connect("resume", Runner, "_post")
	Runner.connect("display_results", Results, "_display_results")
	RunAll.connect("pressed", Output, "_clear")
	RunAll.connect("pressed", Results, "_clear")

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