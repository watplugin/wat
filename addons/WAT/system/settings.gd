extends Reference

const AUTO_QUIT: String = "WAT/AutoQuit"
const displays: Dictionary = {
	0: "Left.UL Dock",
	1: "Left.BL Dock",
	2: "Left.UR Dock",
	3: "Left.BR Dock",
	4: "Right.UL Dock",
	5: "Right.BL Dock",
	6: "Right.UR Dock",
	7: "Right.BR Dock",
	8: "Bottom Panel",
}

enum {
	LEFT_UPPER_LEFT,
	LEFT_BOTTOM_LEFT,
	LEFT_UPPER_RIGHT,
	LEFT_BOTTOM_RIGHT,
	RIGHT_UPPER_LEFT,
	RIGHT_BOTTOM_LEFT,
	RIGHT_UPPER_RIGHT,
	RIGHT_BOTTOM_RIGHT,
	BOTTOM_PANEL,
	# MainWindow Option Here
	OUT_OF_BOUNDS
}

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

#static func

static func initialize_window(plugin, scene):
	if plugin.state == BOTTOM_PANEL:
		plugin.add_control_to_bottom_panel(scene, "Tests")
	elif plugin.state < BOTTOM_PANEL:
		plugin.add_control_to_dock(plugin.state, scene)
	else:
		push_warning("Display Option Is Out Of Bounds")
		
static func destroy_window(plugin, scene):
	if plugin.state == BOTTOM_PANEL:
		plugin.remove_control_from_bottom_panel(scene)
	elif plugin.state < BOTTOM_PANEL:
		plugin.remove_control_from_docks(scene)
