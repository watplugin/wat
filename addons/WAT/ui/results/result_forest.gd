tool
extends TabContainer

const ResultTree: PackedScene = preload("res://addons/WAT/ui/results/ResultTree.tscn")
var _results: Array
var _tabs: Dictionary
signal function_sought

func get_last_run_failures() -> Array:
	var failures = []
	for result in _results:
		if not result.success:
			failures.append(result.path)
	return failures

func display(results: Array):
	_results = results
	_add_result_tree(results)
		
func _add_result_tree(results: Array) -> void:
	_tabs = {}
	var tab_count: int = 0
	var sorted = sort(results)
	for path in sorted:
		var result_tree = ResultTree.instance()
		result_tree.connect("function_sought", self, "_on_function_sought")
		result_tree.connect("calculated", self, "_on_tree_results_calculated")
		result_tree.name = path
		add_child(result_tree)
		_tabs[result_tree] = tab_count
		result_tree.display(sorted[path])
		tab_count += 1
		
func _on_function_sought(path: String, function: String) -> void:
	emit_signal("function_sought", path, function)
	
func sort(results: Array) -> Dictionary:
	var sorted: Dictionary = {}
	for result in results:
		var end: int = result.path.find_last("/")
		# Need to consider ProjectSettings Here
		var path: String = result.path.substr(0, end).replace(ProjectSettings.get_setting("WAT/Test_Directory"), "").replace("/", " ").capitalize()
		if sorted.has(path):
			sorted[path].append(result)
		else:
			sorted[path] = [result]
	return sorted
	
func _on_tree_results_calculated(tree: Tree, passed: int, total: int, success: bool) -> void:
	tree.name += " (%s|%s)" % [passed, total]
	set_tab_icon(_tabs[tree], WAT.Icon.SUCCESS if success else WAT.Icon.FAILED)

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
