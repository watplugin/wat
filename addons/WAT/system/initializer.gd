extends Reference

func _init() -> void:
	_create_test_folder()
	_create_results_folder()
	_add_script_templates()
	_add_window_setting()

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

func _add_script_templates() -> void:
	var data = preload("res://addons/WAT/system/filesystem.gd").templates()
	if data.exists:
		return
	var path = ProjectSettings.get_setting("editor/script_templates_search_path")
	var wat_template = load("res://addons/WAT/test/template.gd")
	var savepath: String = "%s/wat.test.gd" % path
	ResourceSaver.save(savepath, wat_template)
	push_warning("Added WAT Script Template to %s" % path)
	
func _add_window_setting() -> void:
	if not ProjectSettings.has_setting("WAT/Minimize_Window_When_Running_Tests"):
		ProjectSettings.set_setting("WAT/Minimize_Window_When_Running_Tests", false)
		var property = {}
		property.name = "WAT/Minimize_Window_When_Running_Tests"
		property.type = TYPE_BOOL
		ProjectSettings.add_property_info(property)
		ProjectSettings.save()
