tool
extends EditorPlugin

const UI: PackedScene = preload("WAT.tscn")
var interface: PanelContainer

func _enter_tree() -> void:
	_create_test_folder()
	_create_temp_folder()
	interface = UI.instance()
	add_control_to_bottom_panel(interface, "Tests")

func _exit_tree() -> void:
	remove_control_from_bottom_panel(interface)

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
		push_warning("Set Test Directory to 'res://tests'. You can change this in Project -> Project Settings -> General -> WAT")
		return