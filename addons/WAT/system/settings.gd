extends Reference

const AUTO_QUIT: String = "WAT/AutoQuit"

static func set_run_path(path: String) -> void:
	ProjectSettings.set("WAT/ActiveRunPath", path)

static func clear(primary: bool = false):
	if ProjectSettings.has_setting("WAT/TestDouble"):
		ProjectSettings.get_setting("WAT/TestDouble").clear()
		ProjectSettings.get_setting("WAT/TestDouble").free()
