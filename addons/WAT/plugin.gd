tool
extends EditorPlugin

const UI: PackedScene = preload("WAT.tscn")
var interface: PanelContainer

func _enter_tree() -> void:
	_create_test_folder()
	_create_temp_folder()
	interface = UI.instance()
	get_editor_interface().get_editor_viewport().add_child(interface)
	make_visible(false)



func _exit_tree() -> void:
	get_editor_interface().get_editor_viewport().remove_child(interface)
	interface.free()

func has_main_screen() -> bool:
   return true

func make_visible(visible: bool) -> void:
	interface.show() if visible else interface.hide()

func get_plugin_name() -> String:
   return "WAT"

func _create_temp_folder() -> void:
	Directory.new().make_dir("user://WATemp")
	
func _create_test_folder() -> void:
	var title: String = "WAT/Test_Directory"
	if not ProjectSettings.has_setting(title):
		var property_info: Dictionary = {"name": title, "type": TYPE_STRING, "hint_string": "Store your WATTests here"}
		ProjectSettings.set(title, "res://tests")
		ProjectSettings.add_property_info(property_info)
		push_warning("Set Test Directory to 'res://'. You can change this in Project -> Project Settings -> General -> WAT")
		return