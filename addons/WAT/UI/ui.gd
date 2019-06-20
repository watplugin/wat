extends PanelContainer
tool




func _ready():
	# Get Nodes
	var Runner = get_node("Runner")
	var Results = get_node("UI/Runner/Results")
	var RunAll = get_node("UI/Runner/Options/VBox/RunAll")
	var Output = get_node("UI/Runner/Output")
	var Expand = get_node("UI/Runner/Options/VBox/Expand")
	# Connect Nodes

	Output.connect("finished", Runner, "_finish")
	RunAll.connect("pressed", Runner, "_run")
	Runner.connect("output", Output, "_output")
	Runner.Yield.connect("resume", Runner, "_post")
	Runner.connect("display_results", Results, "_display_results")
	RunAll.connect("pressed", Output, "_clear")
	RunAll.connect("pressed", Results, "_clear")
	Expand.connect("pressed", Results, "_expand_all", [Expand])
	# PrintStrayNodes
	# ScriptSelects

