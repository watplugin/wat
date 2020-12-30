extends Reference
tool

func _init() -> void:
	_add_setting("Test_Directory", TYPE_STRING, "res://tests")
	_add_setting("Results_Directory", TYPE_STRING, OS.get_user_data_dir())
	_add_setting("Tags", TYPE_STRING_ARRAY, PoolStringArray())
	_add_setting("Window_Size", TYPE_VECTOR2, Vector2(1280, 720))
	_add_setting("Minimize_Window_When_Running_Tests", TYPE_BOOL, false)
	ProjectSettings.save()
	
func _add_setting(title: String, type: int, value) -> void:
	title = title.insert(0, "WAT/")
	if ProjectSettings.has_setting(title):
		return
	ProjectSettings.set(title, value)
	var prop: Dictionary = {}
	prop["name"] = title
	prop["type"] = type
	ProjectSettings.add_property_info(prop)

func test_directory() -> String:
	return ProjectSettings.get_setting("WAT/Test_Directory")
	
func results() -> Resource:
	# Add toggle for compiled/exported vs non-compiled/exported
	var path = ProjectSettings.get_setting("WAT/Results_Directory") + "/Results.tres"
	return ResourceLoader.load(path, "", true)
	
func window_size() -> Vector2:
	return ProjectSettings.get_setting("WAT/Window_Size")
	
func tags() -> PoolStringArray:
	return ProjectSettings.get_setting("WAT/Tags")
	
func minimize_window_when_running_tests() -> bool:
	return ProjectSettings.get_setting("WAT/Minimize_Window_When_Running_Tests")
