extends TabContainer
tool

var directories: Dictionary = {"tests": []}
const ResultTree = preload("res://addons/WAT/UI/ResultTree.tscn")
const CONFIG = preload("res://addons/WAT/Settings/Config.tres")
onready var default = $Tests

func _display_results(cases):
	if CONFIG.show_subdirectories_in_their_own_tabs:
		for case in cases:
			var directory = _extract_directory(case.title)
			if not directory in directories:
				directories[directory] = []
			directories[directory].append(case)
		remove_child(default)
		for dir in directories:
			var result_tree = ResultTree.instance()
			result_tree.name = dir
			add_child(result_tree)
			result_tree._display_results(directories[dir])
	else:
		if not default.is_inside_tree():
			add_child(default)
		default._display_results(cases)

func _extract_directory(path: String) -> String:
	var file = path.substr(path.find_last("/"), path.find(".gd" ) + 1)
	var absolute_path = path.replace(file, "")
	if absolute_path == "res://tests":
		return "Tests"
	else:
		return absolute_path.replace("res://tests/", "").capitalize()