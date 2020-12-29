extends MenuButton
tool

var FileCache
var dirs = get_popup()
var tags = PopupMenu.new()
var scripts = PopupMenu.new()
var methods = PopupMenu.new()
var run_method = PopupMenu.new()
var run_tag = PopupMenu.new()
signal _test_path_selected
# Updated Continously
var dir: String
var scriptname: String
var method: String
var tag: String

func _ready() -> void:
	scripts.name = "Scripts"
	methods.name = "Methods"
	run_method.name = "RunMethod"
	tags.name = "Tags"
	run_tag.name = "RunTag"
	dirs.add_child(scripts, true)
	dirs.add_child(tags, true)
	scripts.add_child(methods, true)
	methods.add_child(run_method, true)
	tags.add_child(run_tag, true)
	dirs.connect("about_to_show", self, "_on_about_to_show_directories")
	tags.connect("about_to_show", self, "_on_about_to_show_tags")
	scripts.connect("about_to_show", self, "_on_about_to_show_scripts")
	methods.connect("about_to_show", self, "_on_about_to_show_methods")
	run_method.connect("about_to_show", self, "_on_about_to_show_run")
	run_tag.connect("about_to_show", self, "_on_about_to_show_run_tag")
	dirs.connect("index_pressed", self, "_on_run_option_pressed", [dirs])
	scripts.connect("index_pressed", self, "_on_run_option_pressed", [scripts])
	methods.connect("index_pressed", self, "_on_run_option_pressed", [methods])
	run_method.connect("index_pressed", self, "_on_run_option_pressed", [run_method])
	run_tag.connect("index_pressed", self, "_on_run_option_pressed", [run_tag])
	
func _on_run_option_pressed(idx: int, option: PopupMenu) -> void:
	var tests = []
	var run_failures: bool = false # Failed Tests should be accessible via filecache (they will be in globals?)
	tests = option.get_item_metadata(idx)
	if tests is bool:
		run_failures = tests
		tests = []
	emit_signal("_test_path_selected", tests, run_failures)
	
func _on_about_to_show_directories():
	# We'll have to preload everything here
	dir = ProjectSettings.get_setting("WAT/Test_Directory")
	dirs.clear()
	dirs.set_as_minsize()
	var dirlist = FileCache.directories
	if dirlist.empty():
		return
	# Runs All Tests In All Directories
	dirs.add_item("Run All Tests")
	dirs.add_item("Rerun Failures")
	dirs.add_submenu_item("Tags", "Tags")
	dirs.set_item_metadata(0, FileCache.scripts(ProjectSettings.get_setting("WAT/Test_Directory")))
	dirs.set_item_metadata(1, true) # run failures
	for item in dirlist:
		# We want to hide empty directories
		var tests = FileCache.scripts(item)
		if not tests.empty():
			dirs.add_submenu_item(item, "Scripts")
			
func _on_about_to_show_tags():
	var taglist = ProjectSettings.get("WAT/Tags")
	tags.clear()
	tags.set_as_minsize()
	for tag in taglist:
		if not FileCache.tagged(tag).empty():
			tags.add_submenu_item(tag, "RunTag")
		
		
func _on_about_to_show_scripts():
	dir = dirs.get_item_text(dirs.get_current_index())
	scripts.clear()
	scripts.set_as_minsize()
	var scriptlist = FileCache.scripts(dir)
	if scriptlist.empty():
		return
	# Runs All Tests In Current Directory
	scripts.add_item("Run All Tests In This Directory")
	scripts.set_item_metadata(0, scriptlist)
	for item in scriptlist:
#		if Directory.new().file_exists(item):
		scripts.add_submenu_item(item.path, "Methods")
#
func _on_about_to_show_methods():
	scriptname = scripts.get_item_text(scripts.get_current_index())
	methods.clear()
	methods.set_as_minsize()
	# Runs This Test
	methods.add_item("Run Test")

	var methodlist = []
	# Are we sure this is always a test script?
	var script = FileCache.scripts(scriptname)[0].test
	methods.set_item_metadata(0, FileCache.scripts(scriptname))
	for method in script.get_script_method_list():
		if method.name.begins_with("test"):
			methods.add_submenu_item(method.name, "RunMethod")

func _on_about_to_show_run() -> void:
	method = methods.get_item_text(methods.get_current_index())
	run_method.clear()
	run_method.add_item("Run Method")
	var tests = FileCache.scripts(scripts.get_item_text(scripts.get_current_index()))
	tests[0].test.set_meta("method", methods.get_item_text(methods.get_current_index()))
	run_method.set_item_metadata(0, tests)
	
func _on_about_to_show_run_tag() -> void:
	tag = tags.get_item_text(tags.get_current_index())
	run_tag.clear()
	var tests = FileCache.tagged(tag)
	run_tag.add_item("Run Tagged")
	run_tag.set_item_metadata(0, tests)

func _input(event):
	if get_parent().get_node("QuickStart").shortcut.is_shortcut(event):
		_on_QuickStart_pressed()

func _on_QuickStart_pressed():
	pass
#	_on_run_option_pressed(RUN.ALL)
