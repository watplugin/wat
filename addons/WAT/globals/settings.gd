extends Reference
tool

static func initialize() -> void:
	push_warning("You may change any setting for WAT in Project -> ProjectSettings -> General -> WAT")
	_add_setting("Test_Directory", TYPE_STRING, "res://tests")
	_add_setting("Results_Directory", TYPE_STRING, OS.get_user_data_dir())
	_add_setting("Tags", TYPE_STRING_ARRAY, PoolStringArray())
	_add_setting("Window_Size", TYPE_VECTOR2, Vector2(1280, 720))
	_add_setting("Minimize_Window_When_Running_Tests", TYPE_BOOL, false)
	ProjectSettings.save()
	
static func _add_setting(title: String, type: int, value) -> void:
	title = title.insert(0, "WAT/")
	if ProjectSettings.has_setting(title):
		return
	ProjectSettings.set(title, value)
	var prop: Dictionary = {}
	prop["name"] = title
	prop["type"] = type
	ProjectSettings.add_property_info(prop)

static func test_directory() -> String:
	return ProjectSettings.get_setting("WAT/Test_Directory")
	
static func window_size() -> Vector2:
	return ProjectSettings.get_setting("WAT/Window_Size")
	
static func tags() -> PoolStringArray:
	return ProjectSettings.get_setting("WAT/Tags")
	
static func minimize_window_when_running_tests() -> bool:
	return ProjectSettings.get_setting("WAT/Minimize_Window_When_Running_Tests")
