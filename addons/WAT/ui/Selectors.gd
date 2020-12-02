extends HBoxContainer
tool

const NOTHING_SELECTED: int = 0
const FileSystem: Script = preload("res://addons/WAT/system/filesystem.gd")
onready var DirectorySelector: OptionButton = $Directory
onready var ScriptSelector: OptionButton = $Script
onready var TagSelector: OptionButton = $Tag

func selected(selector: OptionButton) -> String:
	if selector.selected == NOTHING_SELECTED:
		push_warning("Nothing Selected")
	return selector.get_item_text(selector.selected)
	
func _ready() -> void:
	DirectorySelector.clear()
	ScriptSelector.clear()
	TagSelector.clear()
	
	DirectorySelector.add_item("Select Directory")
	ScriptSelector.add_item("Select Script")
	TagSelector.add_item("Select Tag")
	
	DirectorySelector.connect("pressed", self, "_on_directory_selector_pressed")
	ScriptSelector.connect("pressed", self, "_on_script_selector_pressed")
	TagSelector.connect("pressed", self, "_on_tag_selector_pressed")

	ScriptSelector.get_popup().hide()
	TagSelector.get_popup().hide()

func _on_directory_selector_pressed() -> void:
	DirectorySelector.clear()
	DirectorySelector.add_item(ProjectSettings.get_setting("WAT/Test_Directory"))
	for directory in FileSystem.directories():
		DirectorySelector.add_item(directory)
		
func _on_script_selector_pressed() -> void:
	ScriptSelector.clear()
	for script in FileSystem.scripts():
		if script.ends_with(".gd"):
			if load(script).get("TEST") != null:
				ScriptSelector.add_item(script)
			if load(script).get("IS_WAT_SUITE"):
				ScriptSelector.add_item(script)
				
func _on_tag_selector_pressed() -> void:
	TagSelector.clear()
	for tag in ProjectSettings.get_setting("WAT/Tags"):
		TagSelector.add_item(tag)
		
func get_all() -> PoolStringArray:
	return FileSystem.scripts(ProjectSettings.get_setting("WAT/Test_Directory"))
		
func get_script() -> PoolStringArray:
	return FileSystem.scripts(selected(ScriptSelector))
	
func get_directory() -> PoolStringArray:
	return FileSystem.scripts(selected(DirectorySelector))
	
func get_tag() -> String:
	return selected(TagSelector)
