extends PanelContainer
tool



func _ready():
	# Get Nodes
	var Runner = get_node("Runner")
	var Results = get_node("UI/Runner/Results")
	var RunAll = get_node("UI/Runner/Options/VBox/RunAll")
	var Output = get_node("UI/Runner/Output")
	var Expand = get_node("UI/Runner/Options/VBox/Expand")
	var Options = get_node("UI/Runner/Options")
	var TotalTimer = get_node("UI/Runner/Details/Timer")
	# Connect Nodes

	Output.connect("finished", Runner, "_finish")
	RunAll.connect("pressed", TotalTimer, "_start")
	RunAll.connect("pressed", Runner, "_run")
	Runner.connect("output", Output, "_output")
	Runner.Yield.connect("resume", Runner, "_post")
	Runner.connect("display_results", Results, "_display_results")
	Runner.connect("clear", Output, "_clear")
	Runner.connect("clear", Results, "_clear")
	Runner.connect("end_time", TotalTimer, "_stop")
	Expand.connect("pressed", Results, "_expand_all", [Expand])
	Options.connect("START_TIME", TotalTimer, "_start")
	Options.connect("RUN", Runner, "_run")
	# PrintStrayNodes
	# ScriptSelects

