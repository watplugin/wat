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

func display(tests: Array) -> void:
	clear()
	for test in tests:
		
		if not tabs.has(test["dir"]):
			var tree: ResultTree = ResultTree.new(icons)
			var title: String = test.dir.substr(test.dir.find_last("/") + 1)
			title = title.capitalize()
			var tab: Tab = Tab.new(tree, title)
			tabs[test.dir] = tab
	update()
		
func add_results(results: Array) -> void:
	for result in results:
		var tab: Tab = tabs[result["dir"]]
		tab.tree.add_result(result)
		yield(get_tree(), "idle_frame") # Prevent a very bad freeze
		
func on_test_script_started(data: Dictionary) -> void:
	var tab: Tab = tabs[data["dir"]]
	if not tab.tree.is_inside_tree():
		tab.idx = idx
		add_child(tab.tree, true)
		set_tab_title(tab.idx, "%s ( 0 / %s )" % [tab.title, tab.count])
		idx += 1
	else:
		tab.count += 1
		set_tab_title(tab.idx, "%s ( 0 / %s )" % [tab.title, tab.count])
	current_tab = tab.idx
	tab.tree.add_test(data)
	
func on_test_method_started(data: Dictionary) -> void:
	tabs[data["dir"]].tree.add_method(data)
	
func on_test_method_described(data: Dictionary) -> void:
	tabs[data["dir"]].tree.on_test_method_described(data)
#func _on_method_described(data: Dictionary) -> void:
#	print("described")
#
func on_test_method_finished(data: Dictionary) -> void:
	#	var x = {"dir": _dir, "path": _path, "method": _current_method, "success": success, "count": count, "passed": passed}
	tabs[data["dir"]].tree.change_method_color(data)
	
func on_test_script_finished(data: Dictionary) -> void:
	var tab: Tab = tabs[data["dir"]]
	tab.tree.on_test_script_finished(data)
	if data["success"]:
		set_tab_title(tab.idx, "( %s / %s ) %s" % [tab.title, tab.passed, tab.count])
		
func on_asserted(data: Dictionary):
	tabs[data["dir"]].tree.add_assertion(data)
	
	
# Could just be the tree itself


#


# 1. Sort Tests Into Directories
# 2. 
	
#var PASSED_ICON: Texture
#var FAILED_ICON: Texture
#const ResultTree = preload("res://addons/WAT/ui/result_tree.gd")
#var _results: Array
#signal function_selected
#
## Stores asset_registry so that result_tree can be configured with scaled icons
#var _assets_registry

#
#		result_tree._setup_editor_assets(_assets_registry)
#		result_tree.connect("button_pressed", self, "_on_function_selected")
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
#
#func _setup_editor_assets(assets_registry):
#	_assets_registry = assets_registry
#	PASSED_ICON = assets_registry.load_asset("assets/passed.png")
#	FAILED_ICON = assets_registry.load_asset("assets/failed.png")
