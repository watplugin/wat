tool
extends TabContainer

const Tab: GDScript = preload("res://addons/WAT/ui/results/tab.gd")
const ResultTree: GDScript = preload("res://addons/WAT/ui/results/tree.gd")
var tabs: Dictionary = {} # of Tabs
var idx: int = 0
var icons: Reference

func clear() -> void:
	tabs = {}
	idx = 0
	for child in get_children():
		child.free()

func display(tests: Array, multiplier: int) -> void:
	clear()
	for test in tests:
		
		if not tabs.has(test["dir"]):
			var tree: ResultTree = ResultTree.new(icons)
			var tab: Tab = Tab.new(tree, test.dir, multiplier)
			tabs[test.dir] = tab
		tabs[test.dir].increment_expected_total()
	update()
		
#func add_results(results: Array) -> void:
#	for result in results:
#		var tab: Tab = tabs[result["dir"]]
##		tab.tree.add_result(result)
#		yield(get_tree(), "idle_frame")

		
func on_test_script_started(data: Dictionary) -> void:
	var tab: Tab = tabs[data["dir"]]
	tab.count += 1
	if not tab.tree.is_inside_tree():
		tab.idx = idx
		add_child(tab.tree, true)
		set_tab_title(tab.idx, "( %s / %s ) %s" % [tab.passed, tab.expected, tab.title])
		idx += 1
	else:
		set_tab_title(tab.idx, "( %s / %s ) %s" % [tab.passed, tab.expected, tab.title])
	current_tab = tab.idx
	tab.tree.add_test(data)
	
func on_test_method_started(data: Dictionary) -> void:
	tabs[data["dir"]].tree.add_method(data)
	
func on_test_method_described(data: Dictionary) -> void:
	tabs[data["dir"]].tree.on_test_method_described(data)

func on_test_method_finished(data: Dictionary) -> void:
	var tab: Tab = tabs[data["dir"]]
	tab.tree.on_test_method_finished(data)
	if tab.tree.failed:
		set_tab_icon(tab.idx, icons.failed)
	
func on_test_script_finished(data: Dictionary) -> void:
	var tab: Tab = tabs[data["dir"]]
	tab.tree.on_test_script_finished(data)
	tab.on_test_script_finished(data["success"])
	if data["success"]:
		set_tab_title(tab.idx, "( %s / %s ) %s" % [tab.passed, tab.expected, tab.title])
	else:
		set_tab_icon(tab.idx, icons.failed)
	if tab.success:
		set_tab_icon(tab.idx, icons.passed)
		
func on_asserted(data: Dictionary):
	var tab: Tab = tabs[data["dir"]]
	tab.tree.add_assertion(data)
	if tab.tree.failed:
		set_tab_icon(tab.idx, icons.failed)
	
	
#signal function_selected

#
#func _on_function_selected(item, column, id) -> void:
#	emit_signal("function_selected", item.get_meta("path"), item.get_meta("fullname"))
#

#enum { EXPAND_ALL, COLLAPSE_ALL, EXPAND_FAILURES }
#func _on_view_pressed(option: int) -> void:
#	match option:
#		EXPAND_ALL:
#			expand_all()
#		COLLAPSE_ALL:
#			collapse_all()
#		EXPAND_FAILURES:
#			expand_failures()
#
## We could add another option to make non-failures invisible?
#func expand_all():
#	for child in get_children():
#		child.expand_all()
#
#func collapse_all():
#	for child in get_children():
#		child.collapse_all()
#
#func expand_failures():
#	collapse_all()
#	for child in get_children():
#		child.expand_failures()
