extends PanelContainer
tool

onready var Results = $Layout/Middle/Results
onready var Run = $Layout/Middle/Menu/Buttons/Run
onready var Clear = $Layout/Middle/Menu/Buttons/Clear
onready var Output = $Layout/Output
onready var Runner = $Runner

### SETTINGS
onready var parameters = $Layout/Middle/Menu/Typing/Parameters
onready var retvals = $Layout/Middle/Menu/Typing/ReturnValue
onready var excludevoid = $Layout/Middle/Menu/Typing/ExcludeVoid
onready var scriptprefixes = $Layout/Middle/Menu/Prefix/Script
onready var methodprefixes = $Layout/Middle/Menu/Prefix/Method
onready var default = $Layout/Middle/Menu/DefaultSettings

func _ready():
	_default(false)
	update_settings_display()
	connect_buttons()
	connect_settings()
	
func connect_buttons():
	Run.connect("pressed", Results, "reset") # be wary of this
	Run.connect("pressed", Runner, "_start")
	Run.connect("pressed", Output, "_clear")
	Runner.connect("display_results", Results, "_display_results") # May need to change display here?
	Clear.connect("pressed", Results, "reset")
	Clear.connect("pressed", Output, "_clear")
	Runner.connect("output", Output, "_output")
	
func connect_settings():
	parameters.connect("pressed", WATConfig, "_set_parameters", [parameters])
	retvals.connect("pressed", WATConfig, "_set_return_value", [retvals])
	excludevoid.connect("pressed", WATConfig, "_set_exclude_void", [excludevoid])
	scriptprefixes.connect("text_changed", WATConfig, "_set_script_prefixes")
	methodprefixes.connect("text_changed", WATConfig, "_set_method_prefixes")
	default.connect("pressed", self, "_default", [true])
	
func _default(force: bool):
	print("resetting defaults")
	parameters.pressed = true
	retvals.pressed = true
	excludevoid.pressed = true
	scriptprefixes.text = ""
	methodprefixes.text = ""
	WATConfig.defaults(force)
	
func update_settings_display():
	parameters.pressed = WATConfig.parameters()
	retvals.pressed = WATConfig.return_value()
	excludevoid.pressed = WATConfig.void_excluded()
	scriptprefixes.text = WATConfig.script_prefixes()
	methodprefixes.text = WATConfig.method_prefixes()