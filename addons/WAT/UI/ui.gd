extends PanelContainer
tool

onready var Results = $UI/Middle/Results
onready var Run = $UI/Middle/Menu/Buttons/Run
onready var Clear = $UI/Middle/Menu/Buttons/Clear
onready var Output = $UI/Output
onready var Runner = $Runner

onready var printstraynodes = $UI/Middle/Menu/Buttons/PrintStrayNodes

### SETTINGS
onready var parameters = $UI/Middle/Menu/Typing/Parameters
onready var retvals = $UI/Middle/Menu/Typing/ReturnValue
onready var excludevoid = $UI/Middle/Menu/Typing/ExcludeVoid
onready var scriptprefixes = $UI/Middle/Menu/Prefix/Script
onready var methodprefixes = $UI/Middle/Menu/Prefix/Method
onready var default = $UI/Middle/Menu/DefaultSettings

func _ready():
	_default(false)
	update_settings_display()
	connect_buttons()
	connect_settings()
	
func connect_buttons():
	printstraynodes.connect("pressed", self, "print_stray_nodes")
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