extends PanelContainer
tool

func _ready():
	$Layout/MainMenu/Run.connect("pressed", $Layout/Middle/Results, "reset") # might cause timing issues
	$Layout/MainMenu/Run.connect("pressed", $Runner, "_start")
	$Runner.connect("display_results", $Layout/Middle/Results, "_display_results")
	$Layout/MainMenu/Clear.connect("pressed", $Layout/Middle/Results, "reset")
	$Layout/MainMenu/Clear.connect("pressed", $Layout/Output, "_clear")
	$Runner.connect("output", $Layout/Output, "_output")