tool
extends EditorPlugin

const UI: PackedScene = preload("WAT.tscn")
const SETTINGS: Reference = preload("res://addons/WAT/settings.gd")
var interface: PanelContainer

func _enter_tree() -> void:
	interface = UI.instance()
	get_editor_interface().get_editor_viewport().add_child(interface)
	make_visible(false)
	SETTINGS.defaults()

func _exit_tree() -> void:
	get_editor_interface().get_editor_viewport().remove_child(interface)
	interface.free()

func has_main_screen() -> bool:
   return true

func make_visible(visible: bool) -> void:
	interface.show() if visible else interface.hide()

func get_plugin_name() -> String:
   return "WAT"