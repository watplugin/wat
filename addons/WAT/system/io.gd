extends Reference

func _init() -> void:
	_create_test_folder()
	_create_results_folder()

func _create_test_folder() -> void:
	var title: String = "WAT/Test_Directory"
	if not ProjectSettings.has_setting(title):
		var property_info: Dictionary = {"name": title, "type": TYPE_STRING, 
		"hint_string": "Store your WATTests here"}
		ProjectSettings.set(title, "res://tests")
		ProjectSettings.add_property_info(property_info)
		push_warning("Set Test Directory to 'res://tests'. You can change this in Project -> Project Settings -> General -> WAT")
	
func _create_results_folder() -> void:
	var title: String = "WAT/Results_Directory"
	if not ProjectSettings.has_setting(title):
		var property_info: Dictionary = {"name": title, "type": TYPE_STRING, 
		"hint_string": "You can save JUnit XML Results Here"}
		ProjectSettings.set(title, "res://tests/results/WAT")
		ProjectSettings.add_property_info(property_info)
		push_warning("Set Result Directory to 'res://tests/results/WAT'. You can change this in Project -> Project Settings -> General -> WAT")

static func test_directory() -> String:
	return ProjectSettings.get_setting("WAT/Test_Directory")
