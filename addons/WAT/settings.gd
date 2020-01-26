extends Reference

#static func test_directory() -> String:
#	return ProjectSettings.get_setting("WAT/Test_Directory")
#
#static func set_default_directory() -> void:
#	var title: String = "WAT/Test_Directory"
#	if not ProjectSettings.has_setting(title):
#		var property_info: Dictionary = {"name": title, "type": TYPE_STRING, "hint_string": "Store your WATTests here"}
#		ProjectSettings.set(title, "res://tests")
#		ProjectSettings.add_property_info(property_info)
#		push_warning("Set Test Directory to 'res://tests'. You can change this in Project -> Project Settings -> General -> WAT")
const AUTO_QUIT: String = "WAT/AutoQuit"

static func enable_autoquit() -> void:
	ProjectSettings.set_setting(AUTO_QUIT, true)
	
static func disable_autoquit() -> void:
	print("disabling autoquit")
	ProjectSettings.set_setting(AUTO_QUIT, false)
	
static func autoquit_is_enabled() -> bool:
	return ProjectSettings.get_setting(AUTO_QUIT)

#static func set_run_path(path: String) -> void:
#	ProjectSettings.set("WAT/ActiveRunPath", path)
#	print(ProjectSettings.get_setting("WAT/ActiveRunPath") + " is path")
