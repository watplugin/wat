tool
extends TabContainer

const ResultTree: GDScript = preload("result_tree.gd")
var dirs: Dictionary = {}
var idx: int = 0

func clear() -> void:
	for child in get_children():
		child.queue_free()
	dirs.clear()

func display(tests: Array) -> void:
	clear()
	for test in tests:
		
		if not dirs.has(test["dir"]):
			var tree: ResultTree = ResultTree.new()
			var title: String = test.dir.substr(test.dir.find_last("/") + 1)
			title = title.capitalize()
			var tab: Dictionary = {"tree": tree, "title": title, "idx": idx, "count": 0}
			dirs[test.dir] = tab
			add_child(tree)
			idx += 1
		
			
		var tab: Dictionary = dirs[test["dir"]]
		tab["tree"].add_test(test)
		tab["count"] += 1
		set_tab_title(tab["idx"], "%s (0 / %s)" % [tab["title"], tab["count"]])
			
# 1. Sort Tests Into Directories
# 2. 
	
#var PASSED_ICON: Texture
#var FAILED_ICON: Texture
#const ResultTree = preload("res://addons/WAT/ui/result_tree.gd")
#var _results: Array
#var _tabs = {}
#signal function_selected
#
## Stores asset_registry so that result_tree can be configured with scaled icons
#var _assets_registry
#
#func display(results: Array) -> void:
#	clear()
#	_results = results
#	_add_result_tree(results)
#
#func _add_result_tree(results: Array) -> void:
#	_tabs = {}
#	var tab_count: int = 0
#	var sorted = sort(results)
#	for path in sorted:
#		var result_tree = ResultTree.new(self)
#		result_tree._setup_editor_assets(_assets_registry)
#		result_tree.connect("button_pressed", self, "_on_function_selected")
#		result_tree.name = path
#		add_child(result_tree)
#		set_tab_title(tab_count, path)
#		_tabs[result_tree] = tab_count
#		result_tree.display(sorted[path])
#		tab_count += 1
#
#func _on_function_selected(item, column, id) -> void:
#	emit_signal("function_selected", item.get_meta("path"), item.get_meta("fullname"))
#
#func sort(results: Array) -> Dictionary:
#	var sorted: Dictionary = {}
#	for result in results:
#		# Note to self: If we're already sorting by directory, maybe we should..
#		# ..do it earlier in the first place?
#		if sorted.has(result.directory):
#			sorted[result.directory].append(result)
#		else:
#			sorted[result.directory] = [result]
#	return sorted
#
#func clear() -> void:
#	var children: Array = get_children()
#	while not children.empty():
#		var child: Tree = children.pop_back()
#		child.free()
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
