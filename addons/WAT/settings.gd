extends Reference

const AUTO_QUIT: String = "WAT/AutoQuit"

static func enable_autoquit() -> void:
	ProjectSettings.set_setting(AUTO_QUIT, true)
	
static func disable_autoquit() -> void:
	ProjectSettings.set_setting(AUTO_QUIT, false)
	
static func autoquit_is_enabled() -> bool:
	return ProjectSettings.get_setting(AUTO_QUIT)

static func set_run_path(path: String) -> void:
	ProjectSettings.set("WAT/ActiveRunPath", path)
	
static func test_directory() -> String:
	return ProjectSettings.get_setting("WAT/Test_Directory")

static func clear():
	if ProjectSettings.has_setting("WAT/TestDouble"):
		print(ProjectSettings.get_setting("WAT/TestDouble"))
		print(is_instance_valid(ProjectSettings.get_setting("WAT/TestDouble")))
		ProjectSettings.get_setting("WAT/TestDouble").queue_free()
