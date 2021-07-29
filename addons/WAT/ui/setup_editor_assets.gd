extends Reference


func setup(runner, assets_registry) -> void:

	runner.RunAll.icon = assets_registry.load_asset(runner.RunAll.icon)
	runner.DebugAll.icon = assets_registry.load_asset(runner.DebugAll.icon)
	runner.RunFailed.icon = assets_registry.load_asset(runner.RunFailed.icon)
	runner.DebugFailed.icon = assets_registry.load_asset(runner.DebugFailed.icon)


	# Setup Summary
	runner.Summary.Time.icon = assets_registry.load_asset(runner.Summary.Time.icon)
	runner.Summary.Tests.icon = assets_registry.load_asset(runner.Summary.Tests.icon)
	runner.Summary.Passing.icon = assets_registry.load_asset(runner.Summary.Passing.icon)
	runner.Summary.Failing.icon = assets_registry.load_asset(runner.Summary.Failing.icon)
	runner.Summary.Runs.icon = assets_registry.load_asset(runner.Summary.Runs.icon)

	# SetUp Results
	runner.Results.FUNCTION = assets_registry.load_asset("assets/function.png")
	runner.Results.PASSED_ICON = assets_registry.load_asset("assets/passed.png")
	runner.Results.FAILED_ICON = assets_registry.load_asset("assets/failed.png")
	
	# Setup Test Menu
	runner.TestMenu.FOLDER = assets_registry.load_asset("assets/folder.png")
	runner.TestMenu.FAILED = assets_registry.load_asset("assets/failed.png")
	runner.TestMenu.SCRIPT = assets_registry.load_asset("assets/script.png")
	runner.TestMenu.PLAY = assets_registry.load_asset("assets/play.png")
	runner.TestMenu.DEBUG = assets_registry.load_asset("assets/play_debug.png")
	runner.TestMenu.TAG = assets_registry.load_asset("assets/label.png")
	runner.TestMenu.FUNCTION = assets_registry.load_asset("assets/function.png")
	
