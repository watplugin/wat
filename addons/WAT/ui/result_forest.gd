tool
extends TabContainer

const ResultTree: GDScript = preload("result_tree.gd")
var tabs: Dictionary = {} # of Tabs
var idx: int = 0

func clear() -> void:
	tabs = {}
	idx = 0
	for child in get_children():
		child.free()

func display(tests: Array) -> void:
	clear()
	for test in tests:
		
		if not tabs.has(test["dir"]):
			var tree: ResultTree = ResultTree.new()
			var title: String = test.dir.substr(test.dir.find_last("/") + 1)
			title = title.capitalize()
			var tab: Tab = Tab.new(tree, title, idx, 0)
			tabs[test.dir] = tab
			add_child(tree)
			idx += 1
		
		var tab: Tab = tabs[test.dir]
		tab.tree.add_test(test)
		tab.count += 1
		set_tab_title(tab.idx, "%s ( 0 / %s )" % [tab.title, tab.count])
		
	update()
		
func add_results(results: Array) -> void:
	for result in results:
		var tab: Tab = tabs[result["directory"]]
		tab.tree.add_result(result)
		yield(get_tree(), "idle_frame") # Prevent a very bad freeze
		
func _on_assertion(assertion):
	tabs[assertion["dir"]].tree.add_assertion(assertion)
# Could just be the tree itself
class Tab:
	var tree: Tree
	var title: String
	var idx: int
	var count: int = 0
	
	func _init(_tree: Tree, _title: String, _idx: int, _count: int) -> void:
		tree = _tree
		title = _title
		idx = _idx
		count = _count

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
