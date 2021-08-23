tool
extends Reference

const PluginAssetsRegistry: GDScript = preload("res://addons/WAT/ui/scaling/plugin_assets_registry.gd")

static func adjust(runner: PanelContainer, icons: Reference, plugin = null) -> void:
	var registry: PluginAssetsRegistry = PluginAssetsRegistry.new(plugin)
	
	# Scale Icons
	icons.debug_failed = registry.load_asset("assets/debug_failed.png")
	icons.docs = registry.load_asset("assets/docs.svg")
	icons.failed = registry.load_asset("assets/failed.png")
	icons.folder = registry.load_asset("assets/folder.png")
	icons.function = registry.load_asset("assets/function.png")
	icons.issue = registry.load_asset("assets/issue.svg")
	icons.kofi = registry.load_asset("assets/kofi.png")
	icons.label = registry.load_asset("assets/label.png")
	icons.passed = registry.load_asset("assets/passed.png")
	icons.play = registry.load_asset("assets/play.png")
	icons.play_debug = registry.load_asset("assets/play_debug.png")
	icons.play_failed = registry.load_asset("assets/play_failed.png")
	icons.request_docs = registry.load_asset("assets/request_docs.svg")
	icons.scriptx = registry.load_asset("assets/script.png")
	icons.timer = registry.load_asset("assets/timer.png")
	
	# Scale Icons already in the editor
	runner.RunAll.icon = registry.load_asset(runner.RunAll.icon)
	runner.DebugAll.icon = registry.load_asset(runner.DebugAll.icon)

	# Scale summary icons
	runner.Summary.Time.icon = registry.load_asset(runner.Summary.Time.icon)
	runner.Summary.Tests.icon = registry.load_asset(runner.Summary.Tests.icon)
	runner.Summary.Passing.icon = registry.load_asset(runner.Summary.Passing.icon)
	runner.Summary.Failing.icon = registry.load_asset(runner.Summary.Failing.icon)
	runner.Summary.Runs.icon = registry.load_asset(runner.Summary.Runs.icon)
