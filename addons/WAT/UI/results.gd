extends TabContainer
tool

const ResultTree: PackedScene = preload("res://addons/WAT/UI/ResultTree.tscn") # Pass this in?
var directories: Dictionary = {}
var tab: int = 0

func display(cases: Array) -> void:
	_display_directories_as_individual_tabs(cases) if ProjectSettings.get("WAT/Show_subdirectories_as_their_own_tabs") else _add_result_display(cases)

func _display_directories_as_individual_tabs(cases: Array) -> void:
	_add_directories(cases)
	for directory in directories:
		_add_result_display(directories[directory], directory)

func _add_result_display(cases: Array, title: String = "Tests") -> void:
	var results: PanelContainer = ResultTree.instance()
	results.display(cases)
	add_child(results)
	set_tab_title(tab, "%s (%s/%s)" % [title, results.passed, results.total])
	set_tab_icon(tab, results.icon)
	tab += 1

func _add_directories(cases: Array) -> void:
	for case in cases:
		var directory: String = case.path.get_base_dir().replace("res://", "").capitalize().replace(" ", "")
		if not directory in directories:
			directories[directory] = []
		directories[directory].append(case)

func clear() -> void:
	tab = 0
	for child in self.get_children():
		child.free()
	directories.clear()

var collapsed: bool = false

func _collapse_all(button) -> void:
	collapsed = !collapsed
	button.text = "Expand All Results" if collapsed else "Collapse All Results"
	for i in self.get_tab_count():
		get_tab_control(i).collapse_all(collapsed)

