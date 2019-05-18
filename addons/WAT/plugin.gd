tool
extends EditorPlugin

const UI: PackedScene = preload("UI/UI.tscn")
var interface: PanelContainer

func _enter_tree() -> void:
	connect("main_screen_changed", self, "_hide_output")
	interface = UI.instance()
	get_editor_interface().get_editor_viewport().add_child(interface)
	make_visible(false)

func _exit_tree() -> void:
	print_stray_nodes()
	get_editor_interface().get_editor_viewport().remove_child(interface)
	interface.free()

func has_main_screen() -> bool:
   return true

func make_visible(visible: bool) -> void:
	interface.show() if visible else interface.hide()

func get_plugin_name() -> String:
   return "WAT"

func _hide_output(title: String) -> void:
	if title == "WAT":
		hide_bottom_panel()