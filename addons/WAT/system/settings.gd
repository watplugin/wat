extends Reference

const AUTO_QUIT: String = "WAT/AutoQuit"

static func set_run_path(path: String) -> void:
	ProjectSettings.set("WAT/ActiveRunPath", path)
	
static func test_directory() -> String:
	return ProjectSettings.get_setting("WAT/Test_Directory")

static func clear(primary: bool = false):
	if ProjectSettings.has_setting("WAT/TestDouble"):
		ProjectSettings.get_setting("WAT/TestDouble").clear()
		ProjectSettings.get_setting("WAT/TestDouble").free()

static func create():
	if not ProjectSettings.has_setting("WAT/TestDouble"):
		var registry = load("res://addons/WAT/double/registry.gd")
		ProjectSettings.set_setting("WAT/TestDouble", registry.new())
		
static func handle_window():
	if ProjectSettings.get_setting("WAT/Minimize_Window_When_Running_Tests"):
		OS.window_minimized = true

static func create_test_folder() -> void:
	var title: String = "WAT/Test_Directory"
	if not ProjectSettings.has_setting(title):
		var property_info: Dictionary = {"name": title, "type": TYPE_STRING, "hint_string": "Store your WATTests here"}
		ProjectSettings.set(title, "res://tests")
		ProjectSettings.add_property_info(property_info)
		push_warning("Set Test Directory to 'res://tests'. You can change this in Project -> Project Settings -> General -> WAT")
		return
		
static func create_results_folder() -> void:
	var title: String = "WAT/Results_Directory"
	if not ProjectSettings.has_setting(title):
		var property_info: Dictionary = {"name": title, "type": TYPE_STRING, "hint_string": "You can save JUnit XML Results Here"}
		ProjectSettings.set(title, "res://tests/results/WAT")
		ProjectSettings.add_property_info(property_info)
		push_warning("Set Result Directory to 'res://tests/results/WAT'. You can change this in Project -> Project Settings -> General -> WAT")
		return

static func set_minimize_on_load() -> void:
	if not ProjectSettings.has_setting("WAT/Minimize_Window_When_Running_Tests"):
		ProjectSettings.set_setting("WAT/Minimize_Window_When_Running_Tests", false)
		var property = {}
		property.name = "WAT/Minimize_Window_When_Running_Tests"
		property.type = TYPE_BOOL
		ProjectSettings.add_property_info(property)
		ProjectSettings.save()
