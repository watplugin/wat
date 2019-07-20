extends Reference

static func defaults():
	_test_directory()

static func _test_directory() -> void:
	var title: String = "WAT/Test_Directory"
	if ProjectSettings.has_setting(title) and bool(ProjectSettings.get(title)) != false:
		return
	push_warning("You have not set a test directory. You can set it in Project -> Project Settings -> General -> WAT")
	ProjectSettings.set(title, "")
	var property_info: Dictionary = {"name": title, "type": TYPE_STRING, "hint_string": "Store your WATTests here"}
	ProjectSettings.add_property_info(property_info)

