extends Node

const BOTTOM_PANEL: int = 8
const displays: Dictionary = {
	0: "Left.UL Dock", 1: "Left.BL Dock", 2: "Left.UR Dock",
	3: "Left.BR Dock", 4: "Right.UL Dock", 5: "Right.BL Dock",
	6: "Right.UR Dock", 7: "Right.BR Dock", 8: "Bottom Panel",
}

var _plugin: EditorPlugin
var _scene: Control
var _state: int 

func _init(plugin: EditorPlugin, scene: Control) -> void:
	_plugin = plugin
	_scene = scene
	add_setting()
	_state = ProjectSettings.get_setting("WAT/Display")
	construct()
	
func _process(delta: float) -> void:
	var state = ProjectSettings.get_setting("WAT/Display")
	if state != _state:
		deconstruct()
		_state = state
		construct()
	
func construct() -> void:
	if _state == BOTTOM_PANEL:
		_plugin.add_control_to_bottom_panel(_scene, "Tests")
	else:
		_plugin.add_control_to_dock(_state, _scene)
	
func deconstruct() -> void:
	if _state == BOTTOM_PANEL and is_instance_valid(_scene):
		_plugin.remove_control_from_bottom_panel(_scene)
	elif is_instance_valid(_scene):
		_plugin.remove_control_from_docks(_scene)

func _notification(what) -> void:
	if what == NOTIFICATION_PREDELETE:
		ProjectSettings.set_setting("WAT/Display", _state)
		ProjectSettings.save()
		deconstruct()

func add_setting() -> void:
	if not ProjectSettings.has_setting("WAT/Display"):
		ProjectSettings.set_setting("WAT/Display", BOTTOM_PANEL)
		ProjectSettings.save()
	var property = {}
	property.name = "WAT/Display"
	property.type = TYPE_INT
	property.hint = PROPERTY_HINT_ENUM
	property.hint_string = PoolStringArray(displays.values()).join(",")
	ProjectSettings.add_property_info(property)
	ProjectSettings.save()
