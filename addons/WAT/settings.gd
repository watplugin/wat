extends Reference

static func defaults():
	_test_directory()
	_display_directories_in_their_own_tabs()

static func _test_directory() -> void:
	var title: String = "WAT/Test_Directory"
	if ProjectSettings.has_setting(title) and bool(ProjectSettings.get(title)) != false:
		return
	push_warning("You have not set a test directory. You can set it in Project -> Project Settings -> General -> WAT")
	ProjectSettings.set(title, "")
	var property_info: Dictionary = {"name": title, "type": TYPE_STRING, "hint_string": "Store your WATTests here"}
	ProjectSettings.add_property_info(property_info)

static func _display_directories_in_their_own_tabs() -> void:
	var title: String = "WAT/Show_subdirectories_as_their_own_tabs"
	if ProjectSettings.has_setting(title):
		return
	ProjectSettings.set(title, true)
	var hint_string: String = "Tests will be shown in tabs based on which test subdirectory they were ran from"
	var property_info: Dictionary = {"name": title, "type": TYPE_BOOL, "hint_string": hint_string}
	ProjectSettings.add_property_info(property_info)

