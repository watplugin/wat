extends TabContainer
tool

var directories: Dictionary = {}
const ResultTree: PackedScene = preload("res://addons/WAT/UI/ResultTree.tscn")
const CONFIG: Resource = preload("res://addons/WAT/Settings/Config.tres")

func _display_results(cases: Array) -> void:
	_clear()
	if CONFIG.show_subdirectories_in_their_own_tabs:
		for case in cases:
			_add_test_directories(case)
		for directory in directories:
			_show_directory_as_a_tab(directory)
	else:
		_show_all_tests_together(cases)

func _add_test_directories(case: Object) -> void:
	var directory: String = _extract_directory(case.title)
	_add_test_to_correct_directory(directory, case)

func _show_directory_as_a_tab(directory: String) -> void:
	var cases: Array = directories[directory]
	var results: PanelContainer = ResultTree.instance()
	results.name = directory
	add_child(results)
	results.display(cases)


func _show_all_tests_together(cases: Array) -> void:
	var results: PanelContainer = ResultTree.instance()
	results.name = "Tests"
	add_child(results)
	results.display(cases)

func _extract_directory(path: String) -> String:
	var file = path.substr(path.find_last("/"), path.find(".gd" ) + 1)
	var absolute_path = path.replace(file, "")
	if absolute_path == "res://tests":
		return "Tests"
	else:
		return absolute_path.replace("res://tests/", "").capitalize()

func _add_test_to_correct_directory(directory: String, case: Object) -> void:
	if not directory in directories:
		directories[directory] = []
	directories[directory].append(case)

func _clear() -> void:
	for child in self.get_children():
		child.free()
	directories.clear()

func _expand_all(button: Button) -> void:
	var should_expand: bool
	var expand: String = "Expand All Results"
	var collapse: String = "Collapse All Results"
	should_expand = true if button.text == expand else false
	button.text = collapse if should_expand else expand
	for i in self.get_tab_count():
		get_tab_control(i).expand_all(should_expand)

