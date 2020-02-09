extends HBoxContainer
tool

const filesystem = preload("res://addons/WAT/system/filesystem.gd")
onready var DirectorySelector: OptionButton = $Directory
onready var ScriptSelector: OptionButton = $Script
onready var TagSelector: OptionButton = $Tag

func _ready():
	DirectorySelector.clear()
	DirectorySelector.add_item("Select Directory")
	ScriptSelector.add_item("Select Script")
	TagSelector.add_item("Select Tag")
	DirectorySelector.connect("pressed", self, "_on_directory_selector_pressed")
	ScriptSelector.connect("pressed", self, "_on_script_selector_pressed")
	TagSelector.connect("pressed", self, "_on_tag_selector_pressed")

func _on_directory_selector_pressed() -> void:
	DirectorySelector.clear()
	DirectorySelector.add_item(ProjectSettings.get_setting("WAT/Test_Directory"))
	for directory in filesystem.directories():
		DirectorySelector.add_item(directory)
		
func _on_script_selector_pressed() -> void:
	ScriptSelector.clear()
	for script in filesystem.scripts():
		if script.ends_with(".gd"):
			if load(script).get("TEST") != null:
				ScriptSelector.add_item(script)
			if load(script).get("IS_WAT_SUITE"):
				ScriptSelector.add_item(script)
				
func _on_tag_selector_pressed() -> void:
	TagSelector.clear()
	for tag in ProjectSettings.get_setting("WAT/Tags"):
		TagSelector.add_item(tag)
