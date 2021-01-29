extends Button
tool

enum { RUN_ALL, RUN_DIR, RUN_SCRIPT, RUN_TAG, RUN_METHOD, RUN_FAILURES }
const TestGatherer: Script = preload("res://addons/WAT/editor/test_gatherer.gd")
const ABOUT_TO_SHOW: String = "about_to_show"
const IDX_PRESSED: String = "index_pressed"
const ON_IDX_PRESSED: String = "_on_idx_pressed"
onready var Directories: PopupMenu = $Directories
onready var Scripts: PopupMenu = $Directories/Scripts
onready var Methods: PopupMenu = $Directories/Scripts/Methods
onready var Tags: PopupMenu = $Directories/Tags
onready var TagEditor: PopupMenu = $Directories/Scripts/Methods/TagEditor
var test: Dictionary
signal _tests_selected
var pool: Array = []

func _init() -> void:
	test = TestGatherer.new().discover()
	
func _exit_tree() -> void:
	TestGatherer.new().save(test)
	for item in range(pool.size(), -1, 0):
		pool.pop_back().free()
	
func refresh() -> void:
	if ProjectSettings.get_setting("WAT/Auto_Refresh_Tests"):
		var test_gatherer = TestGatherer.new()
		test_gatherer.save(test)
		test = test_gatherer.discover()
		
func save_metadata() -> void:
	TestGatherer.new().save(test)
	
func _ready() -> void:
	Directories.connect(ABOUT_TO_SHOW, self, "_on_dirs_about_to_show")
#	Scripts.connect(ABOUT_TO_SHOW, self, "_on_scripts_about_to_show")
#	Methods.connect(ABOUT_TO_SHOW, self, "_on_methods_about_to_show")
#	Tags.connect(ABOUT_TO_SHOW, self, "_on_tags_about_to_show")
#	TagEditor.connect(ABOUT_TO_SHOW, self, "_on_tag_editor_about_to_show")
	Directories.connect(IDX_PRESSED, self, ON_IDX_PRESSED, [Directories])
#	Scripts.connect(IDX_PRESSED, self, ON_IDX_PRESSED, [Scripts])
#	Methods.connect(IDX_PRESSED, self, ON_IDX_PRESSED, [Methods])
#	Tags.connect(IDX_PRESSED, self, ON_IDX_PRESSED, [Tags])
#	TagEditor.connect(IDX_PRESSED, self, "_on_tag_editor_idx_pressed")
	
func _on_idx_pressed(idx: int, menu: PopupMenu) -> void:
	var metadata: Dictionary = menu.get_item_metadata(idx)
	select_tests(metadata)
	
func select_tests(metadata: Dictionary) -> void:
	var tests: Array = []
	match metadata.command:
		RUN_ALL:
			tests = test.all
		RUN_DIR:
			tests = test[metadata.path]
		RUN_SCRIPT:
			tests.append(test.scripts[metadata.path])
		RUN_METHOD:
			var path: String = metadata["path"]
			var method: String = metadata["method"]
			var container: Dictionary = test.scripts[path].duplicate()
			container["method"] = method
			tests.append(container)
		RUN_TAG:
			var tag: String = metadata.tag
			for t in test.scripts:
				var container = test.scripts[t]
				if container["tags"].has(tag as String):
					tests.append(container)
		RUN_FAILURES:
			for path in test.scripts:
				var container: Dictionary = test.scripts[path]
				if container.has("passing") and not container["passing"]:
					tests.append(container)
			push_warning("RUN FAILURES NOT IMPLEMENTED")
	emit_signal("_tests_selected", tests)
	
func set_last_run_success(results) -> void:
	for result in results:
		test.scripts[result["path"]]["passing"] = result.success
	
func _on_tag_editor_idx_pressed(idx) -> void:
	var container: Dictionary = test.scripts[TagEditor.get_item_metadata(idx)]
	var tag: String = TagEditor.get_item_text(idx)
	if TagEditor.is_item_checked(idx):
		container["tags"].erase(tag)
		TagEditor.set_item_checked(idx, false)
	else:
		container["tags"].append(tag as String)
		TagEditor.set_item_checked(idx, true)
	
func _on_dirs_about_to_show() -> void:
	refresh()
	Directories.clear()
	Directories.set_as_minsize()
	Directories.add_item("Run All")
	Directories.set_item_icon(0, load("res://addons/WAT/assets/play.png"))
	Directories.add_item("Rerun Failures")
	Directories.set_item_icon(1, load("res://addons/WAT/assets/failed.png"))
	Directories.add_submenu_item("Tags", "Tags")
	Directories.set_item_icon(2, load("res://addons/WAT/assets/label.png"))
	Directories.set_item_metadata(0, {command = RUN_ALL})
	Directories.set_item_metadata(1, {command = RUN_FAILURES})
	var dirs: Array = test.dirs
	if dirs.empty():
		return
	var idx: int = Directories.get_item_count()
	for dir in dirs:
		if not test[dir].empty():
			var script = Scripts.duplicate()
			pool.append(script)
			script.name = idx as String
			Directories.add_child(script)
			Directories.add_submenu_item(dir, idx as String)
			Directories.set_item_icon(idx, load("res://addons/WAT/assets/folder.png"))
			script.connect(ABOUT_TO_SHOW, self, "_on_scripts_about_to_show", [script], CONNECT_ONESHOT)
			idx += 1
	
func _on_scripts_about_to_show(scripts) -> void:
	refresh()
	scripts.clear()
	scripts.set_as_minsize()
	scripts.add_item("Run All")
	var currentdir: String = Directories.get_item_text(scripts.name as int)
	scripts.set_item_metadata(0, {command = RUN_DIR, path = currentdir})
	scripts.set_item_icon(0,load("res://addons/WAT/assets/folder.png"))
	var scriptlist: Array = test[currentdir]
	if scriptlist.empty():
		return
	var idx: int = scripts.get_item_count()
	for script in scriptlist:
		scripts.add_submenu_item(script["path"], "Methods")
		scripts.set_item_icon(idx, load("res://addons/WAT/assets/script.png"))
		idx += 1
	
func _on_methods_about_to_show() -> void:
	refresh()
#	Methods.clear()
#	Methods.set_as_minsize()
#	Methods.add_item("Run All")
#	#Methods.add_item("Edit Tags")
#	Methods.add_submenu_item("Edit Tags", "TagEditor")
#	var currentScript: String = Scripts.get_item_text(Scripts.get_current_index())
#	Methods.set_item_metadata(0, {command = RUN_SCRIPT, path = currentScript})
#	Methods.set_item_metadata(1, {command = RUN_TAG, tag = "?"})
#	Methods.set_item_icon(0, load("res://addons/WAT/assets/script.png"))
#	Methods.set_item_icon(1, load("res://addons/WAT/assets/label.png"))
#	var script: GDScript = test.scripts[currentScript]["script"]
#	var methods = script.get_script_method_list()
#	var idx: int = Methods.get_item_count()
#	for method in methods:
#		if method.name.begins_with("test"):
#			Methods.add_item(method.name)
#			Methods.set_item_metadata(idx, {command = RUN_METHOD, path = script.get_path(), method = method.name})
#			Methods.set_item_icon(idx, load("res://addons/WAT/assets/function.png"))
#			idx += 1
	
func _on_tags_about_to_show() -> void:
	refresh()
	var tags: PoolStringArray = ProjectSettings.get_setting("WAT/Tags")
	Tags.clear()
	Tags.set_as_minsize()
	var idx: int = Tags.get_item_count()
	for taglabel in tags:
		Tags.add_item(taglabel)
		Tags.set_item_metadata(idx, {command = RUN_TAG, tag = taglabel})
		idx += 1
		
func _on_tag_editor_about_to_show() -> void:
	refresh()
	TagEditor.clear()
	TagEditor.set_as_minsize()
	var currentScript: String = Scripts.get_item_text(Scripts.get_current_index())
	var container = test.scripts[currentScript]
	var tags: PoolStringArray = ProjectSettings.get_setting("WAT/Tags")
	var idx: int = TagEditor.get_item_count()
	for tag in tags:
		TagEditor.add_check_item(tag)
		TagEditor.set_item_checked(idx, container["tags"].has(tag))
		TagEditor.set_item_metadata(idx, currentScript)
		TagEditor.set_item_as_checkable(idx, true)
		idx += 1
		
func _pressed() -> void:
	var position = rect_global_position
	position.y += rect_size.y
	Directories.rect_global_position = position
	Directories.rect_size = Vector2(rect_size.x, 0)
	Directories.grab_focus()
	Directories.popup()

# All of this could be a seperate script (like a test.script())
func _on_file_moved(source: String, destination: String) -> void:
	var testdir: String = ProjectSettings.get_setting("WAT/Test_Directory")
	if not source.ends_with(".gd") and not destination.ends_with(".gd"):
		# File isn't a valid test file so we don't care
		return

	if testdir in source and not testdir in destination:
		# Moving outside of testdir
		var src: String = source.substr(0, source.find_last("/"))
		var container: Dictionary = test.scripts[source]
		test[src].erase(container)
		test.scripts.erase(source)
		test.all.erase(container)
	elif not testdir in source and testdir in destination:
		# Moving into testdir
		var dest: String = destination.substr(0, destination.find_last("/"))
		var script = ResourceLoader.load(destination, "", true)
		var container = {"script": script, "path": destination, "tags": []}
		test.scripts[destination] = container
		if not test.has(dest):
			test[dest] = []
		test[dest].append(container)
		test.all.append(container)
	elif testdir in source and testdir in destination:
		# Moving between subdirs of testdir
		var dest: String = destination.substr(0, destination.find_last("/"))
		var src: String = source.substr(0, source.find_last("/"))
		var container: Dictionary = test.scripts[source]
		container["path"] = destination
		test.scripts.erase(source)
		test.scripts[destination] = container
		test[src].erase(container)
		test[dest].append(container)
	
func _on_folder_moved(source: String, destination: String) -> void:
	var testdir: String = ProjectSettings.get_setting("WAT/Test_Directory")
	if testdir in source and not testdir in destination:
		var tests: Array = test[source.substr(0, source.length() - 1)]
		for container in tests:
			test.scripts.erase(container.path)
			test.all.erase(container)
		test.erase(source)
		tests.clear()
	elif not testdir in source and testdir in destination:
		_add_test_dirs_recursively(destination)
	elif testdir in source and testdir in destination:
		var tests: Array = test[source]
		for container in tests:
			test.scripts.erase(container.path)
			container.path.replace(source, destination)
			test.scripts[container.path] = container
		test[destination] = tests
		test.erase(source)
		
func _on_file_removed(source: String) -> void:
	var testdir: String = ProjectSettings.get_setting("WAT/Test_Directory")
	if not testdir in source:
		# We don't care because it isn't in the test dir
		return
	if not test.scripts.has(source):
		# We don't care because it isn't a test file 
		return
	var container: Dictionary = test.scripts[source]
	test.scripts.erase(container)
	test.all.erase(container)
	test[source.substr(0, source.find_last("/"))].erase(container)
#
func _on_folder_removed(source: String) -> void:
	var testdir: String = ProjectSettings.get_setting("WAT/Test_Directory")
	if not testdir in source:
		# We don't care because it isn't in the test dir
		return
	# Removing last slash
	var src: String = source.substr(0, source.length() - 1)
	var dir: Array = test[src]
	for container in dir:
		test.scripts.erase(container.path)
		test.all.erase(container)
	test.erase(src)
	test.dirs.erase(src)
	
func _on_resource_saved(resource: Resource) -> void:
	if not resource is GDScript or not resource.get("TEST") == true:
		# Not a valid test
		return
	var dir: String = resource.resource_path.substr(0, resource.resource_path.find_last("/"))
	var testdir: String = ProjectSettings.get_setting("WAT/Test_Directory")
	if not testdir in dir:
		# Not in testdir
		return
	if test.scripts.has(resource.get_path()):
		# Already stored
		return
	var container: Dictionary = {"script": resource, "path": resource.get_path(), "tags": []}
	if not test.dirs.has(dir):
		test.dirs.append(dir)
		test[dir] = []
	test[dir].append(container)
	test.scripts[container.path] = container
	test.all.append(container)

func _add_test_dirs_recursively(path: String) -> void:
	var subdirs: Array = []
	test.dirs.append(path)
	test[path] = []
	var dir: Directory = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)
	var current_name: String = dir.get_next()
	var title: String = path + "/" + current_name
	if title.ends_with(".gd") and load(title).get("TEST"):
		var script = load(title)
		var t = {"script": script, "path": title, "tags": []}
		test.scripts[title] = t
		test[path].append(t)
		test.all.append(t)
	elif dir.dir_exists(title):
		subdirs.append(title)
	for subdir in subdirs:
		_add_test_dirs_recursively(subdir)
