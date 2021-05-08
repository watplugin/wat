extends Control
tool

onready var QuickRunAll: Button = $QuickRunAll
onready var QuickRunAllDebug: Button = $QuickRunAllDebug

# Loads scaled assets like icons and fonts
func _setup_editor_assets(assets_registry):
	QuickRunAll.icon = assets_registry.load_asset(QuickRunAll.icon)
	QuickRunAllDebug.icon = assets_registry.load_asset(QuickRunAllDebug.icon)
