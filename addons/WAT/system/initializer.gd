extends Reference

func _init() -> void:
	_create_test_folder()
	_create_results_folder()
	_add_window_setting()
	_add_test_strategy_setting()
	_add_test_metadata_folder()
	_add_tag_setting()
	_add_window_sizing()
	_add_port_setting()
	
func _add_port_setting() -> void:
	if ProjectSettings.has_setting("WAT/Port"):
		return
	var prop: Dictionary = {"name": "WAT/Tags", "type": TYPE_INT}
	ProjectSettings.set("WAT/Port", 6000)
	ProjectSettings.add_property_info(prop)
	push_warning("Set WAT Port To 6000. You can change this in Project -> Project Settings -> General -> WAT")
	
func _add_tag_setting() -> void:
	if ProjectSettings.has_setting("WAT/Tags"):
		return
	var property_info: Dictionary = {"name": "WAT/Tags",
	"type": TYPE_STRING_ARRAY, "hint_string": "Defines Tags to group Tests"}
	ProjectSettings.set("WAT/Tags", PoolStringArray())
	ProjectSettings.add_property_info(property_info)
	
func _add_test_metadata_folder() -> void:
	if Directory.new().dir_exists("res://.test/"):
		return
	Directory.new().make_dir("res://.test/")
	push_warning("Created hidden metadata folder at res://.test/")

func _create_test_folder() -> void:
	var title: String = "WAT/Test_Directory"
	if not ProjectSettings.has_setting(title):
		var property_info: Dictionary = {"name": title, "type": TYPE_STRING, 
		"hint_string": "Store your WATTests here"}
		ProjectSettings.set(title, "res://tests")
		ProjectSettings.add_property_info(property_info)
		push_warning("Set Test Directory to 'res://tests'. You can change this in Project -> Project Settings -> General -> WAT")
	
func _add_window_sizing() -> void:
	if not ProjectSettings.has_setting("WAT/Window_Size"):
		ProjectSettings.set_setting("WAT/Window_Size", Vector2(1280, 720))
		var property = {}
		property.name = "WAT/Window_Size"
		property.type = TYPE_VECTOR2
		ProjectSettings.add_property_info(property)
		ProjectSettings.save()
	
func _create_results_folder() -> void:
	var title: String = "WAT/Results_Directory"
	if not ProjectSettings.has_setting(title):
		var property_info: Dictionary = {"name": title, "type": TYPE_STRING, 
		"hint_string": "You can save JUnit XML Results Here"}
		ProjectSettings.set(title, "res://tests/results/WAT")
		ProjectSettings.add_property_info(property_info)
		push_warning("Set Result Directory to 'res://tests/results/WAT'. You can change this in Project -> Project Settings -> General -> WAT")
	
func _add_window_setting() -> void:
	if not ProjectSettings.has_setting("WAT/Minimize_Window_When_Running_Tests"):
		ProjectSettings.set_setting("WAT/Minimize_Window_When_Running_Tests", false)
		var property = {}
		property.name = "WAT/Minimize_Window_When_Running_Tests"
		property.type = TYPE_BOOL
		ProjectSettings.add_property_info(property)
		ProjectSettings.save()

func _add_test_strategy_setting() -> void:
	if not ProjectSettings.has_setting("WAT/TestStrategy"):
		var property_info: Dictionary = {"name": "WAT/TestStrategy", "type": TYPE_DICTIONARY, 
		"hint_string": "Used by WAT internally to determine how to run tests"}
		ProjectSettings.set("WAT/TestStrategy", {})
		ProjectSettings.add_property_info(property_info)
		ProjectSettings.save()
