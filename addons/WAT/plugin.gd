tool
extends EditorPlugin

const UI: PackedScene = preload("WAT.tscn")
var interface: PanelContainer

func _enter_tree() -> void:
	create_tests_if_it_does_not_exist()
	interface = UI.instance()
	get_editor_interface().get_editor_viewport().add_child(interface)
	make_visible(false)

func _exit_tree() -> void:
	get_editor_interface().get_editor_viewport().remove_child(interface)
	interface.free()

func create_tests_if_it_does_not_exist():
	# Bit too silent for my liking
	var d = Directory.new()
	if not d.dir_exists("res://tests"):
		d.make_dir("res://tests")
		OS.alert("Made Folder tests in your main folder")

func has_main_screen() -> bool:
   return true

func make_visible(visible: bool) -> void:
	interface.show() if visible else interface.hide()

func get_plugin_name() -> String:
   return "WAT"