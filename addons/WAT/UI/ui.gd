extends PanelContainer
tool

onready var Results = $Layout/Middle/Results
onready var Run = $Layout/Middle/Menu/Buttons/Run
onready var Clear = $Layout/Middle/Menu/Buttons/Clear
onready var Output = $Layout/Output
onready var Runner = $Runner



func _ready():
	Run.connect("pressed", Results, "reset") # be wary of this
	Run.connect("pressed", Runner, "_start")
	Runner.connect("display_results", Results, "_display_results") # May need to change display here?
	Clear.connect("pressed", Results, "reset")
	Clear.connect("pressed", Output, "_clear")
	Runner.connect("output", Output, "_output")