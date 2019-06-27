extends TabContainer
tool

var directories: Dictionary = {}
const ResultTree: PackedScene = preload("res://addons/WAT/UI/ResultTree.tscn")
const SUCCESS: Texture = preload("res://addons/WAT/UI/icons/success.png")
const FAILED: Texture = preload("res://addons/WAT/UI/icons/failed.png")
const CRASH: Texture = preload("res://addons/WAT/UI/icons/warning.png")
var tab: int = 0
var settings: Resource

func display(cases: Array) -> void:
	_clear()
	if settings.show_subdirectories_in_their_own_tabs:
		for case in cases:
			_add_test_directories(case)
		for directory in directories:
			_show_directory_as_a_tab(directory)
	else:
		_show_all_tests_together(cases)

func _add_test_directories(case: Object) -> void:
	var directory: String = case.title.get_base_dir().replace("res://", "")
	_add_test_to_correct_directory(directory, case)
#
func _show_directory_as_a_tab(directory: String) -> void:
	var cases: Array = directories[directory]
	var results: PanelContainer = ResultTree.instance()
	print(directory)
	results.name = directory
	print(results.name)
	add_child(results)
	results.display(cases)
	if results.includes_crash:
		set_tab_icon(tab, CRASH)
	else:
		set_tab_icon(tab, SUCCESS) if results.success() else set_tab_icon(tab, FAILED)
	set_tab_title(tab, directory)
	tab += 1

func _show_all_tests_together(cases: Array) -> void:
	var results: PanelContainer = ResultTree.instance()
	results.name = "Tests"
	add_child(results)
	results.display(cases)

func _add_test_to_correct_directory(directory: String, case: Object) -> void:
	if not directory in directories:
		directories[directory] = []
	print(directory)
	directories[directory].append(case)

func _clear() -> void:
	tab = 0
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

