extends HBoxContainer
tool

onready var QuickRunAll: Button = $RunAll
onready var QuickRunAllDebug: Button = $DebugAll
onready var TestMenu: Button = $TestMenu

func _ready():
	if not Engine.is_editor_hint():
		QuickRunAllDebug.disabled = true

# Loads scaled assets like icons and fonts
func _setup_editor_assets(assets_registry):
	TestMenu._setup_editor_assets(assets_registry)
	QuickRunAll.icon = assets_registry.load_asset(QuickRunAll.icon)
	QuickRunAllDebug.icon = assets_registry.load_asset(QuickRunAllDebug.icon)
