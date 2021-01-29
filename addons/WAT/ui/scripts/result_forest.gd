extends TabContainer
tool

const PASSED_ICON: Texture = preload("res://addons/WAT/assets/passed.png")
const FAILED_ICON: Texture = preload("res://addons/WAT/assets/failed.png")
const ResultTree = preload("res://addons/WAT/ui/scripts/result_tree.gd")
var _results: Array
var _tabs = {}
signal function_selected

func display(results: Array) -> void:
	clear()
	_results = results
	_add_result_tree(results)
		
func _add_result_tree(results: Array) -> void:
	_tabs = {}
	var tab_count: int = 0
	var sorted = sort(results)
	for path in sorted:
		var result_tree = ResultTree.new()
		result_tree.connect("function_selected", self, "_on_function_selected")
		result_tree.connect("calculated", self, "_on_tree_results_calculated")
		result_tree.name = path
		add_child(result_tree)
		set_tab_title(tab_count, path)
		_tabs[result_tree] = tab_count
		result_tree.display(sorted[path])
		tab_count += 1

func _on_function_selected(path: String, function: String) -> void:
	emit_signal("function_selected", path, function)
	
func sort(results: Array) -> Dictionary:
	var sorted: Dictionary = {}
	for result in results:
		# We're searching for dirs, not path names
		var path: String = result.path
		path = path.replace(ProjectSettings.get_setting("WAT/Test_Directory"), "")
		path = path.replace(".gd", "")
		var end: int = path.find_last("/")
		
		if end > 0:
			path = path.substr(0, end).replace("/", " ")
		else:
			# Our test is in root so we'll just give it the root dir
			path = ProjectSettings.get_setting("WAT/Test_Directory").replace("res://", "")
			if path.empty():
				# For the dangerous people who want to run tests in project root
				path = "res://"
		
		path = path.replace(".", " ")
		path = path.capitalize()
		path = path.replace(" ", "/")
		if sorted.has(path):
			sorted[path].append(result)
		else:
			sorted[path] = [result]
	return sorted
	
func _on_tree_results_calculated(tree: Tree, passed: int, total: int, success: bool) -> void:
	tree.name += " (%s|%s)" % [passed, total]
	set_tab_icon(_tabs[tree], PASSED_ICON if success else FAILED_ICON)

func clear() -> void:
	var children: Array = get_children()
	while not children.empty():
		var child: Tree = children.pop_back()
		child.free()
		
enum { EXPAND_ALL, COLLAPSE_ALL, EXPAND_FAILURES }
func _on_view_pressed(option: int) -> void:
	match option:
		EXPAND_ALL:
			expand_all()
		COLLAPSE_ALL:
			collapse_all()
		EXPAND_FAILURES:
			expand_failures()
		
func expand_all():
	for results in get_children():
		results.expand_all()
		
func collapse_all():
	for results in get_children():
		results.collapse_all()
		
func expand_failures():
	for results in get_children():
		results.expand_failures()
