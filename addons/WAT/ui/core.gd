extends VBoxContainer
tool

func _setup_editor_assets(assets_registry):
	$Summary._setup_editor_assets(assets_registry)
	$Menu._setup_editor_assets(assets_registry)
	$Results._setup_editor_assets(assets_registry)
