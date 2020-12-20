extends MenuButton
tool

enum RUN { ALL, DIRECTORY, SCRIPT, METHOD, TAG, FAILED }

var FileCache
var dirs = get_popup()
var scripts = PopupMenu.new()
var methods = PopupMenu.new()
var run_method = PopupMenu.new()
signal _test_path_selected
# Updated Continously
var dir: String
var scriptname: String
var method: String

func _ready() -> void:
	scripts.name = "Scripts"
	methods.name = "Methods"
	run_method.name = "RunMethod"
	dirs.add_child(scripts, true)
	scripts.add_child(methods, true)
	methods.add_child(run_method, true)
	dirs.connect("about_to_show", self, "_on_about_to_show_directories")
	scripts.connect("about_to_show", self, "_on_about_to_show_scripts")
	methods.connect("about_to_show", self, "_on_about_to_show_methods")
	run_method.connect("about_to_show", self, "_on_about_to_show_run")
	dirs.connect("id_pressed", self, "_on_run_option_pressed")
	scripts.connect("id_pressed", self, "_on_run_option_pressed")
	methods.connect("id_pressed", self, "_on_run_option_pressed")
	run_method.connect("id_pressed", self, "_on_run_option_pressed")
	
func _on_run_option_pressed(option: int, strategy = {"paths": null}) -> void:
	var tests: Array = []
	var run_failures: bool = false
	match option:
		RUN.ALL:
			tests = FileCache.scripts(ProjectSettings.get("WAT/Test_Directory"))
		RUN.DIRECTORY:
			tests = FileCache.scripts(dir)
		RUN.SCRIPT:
			tests = FileCache.scripts(scriptname)
		RUN.METHOD:
			tests = FileCache.scripts(scriptname)
			tests[0].set_meta("method", method)
		RUN.TAG:
			push_warning("Tag Needs To Be Reimplemented")
		RUN.FAILED:
			run_failures = true
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
	dirs.add_item("Run All Tests", RUN.ALL)
	dirs.add_item("Rerun Failures", RUN.FAILED)
	for item in dirlist:
		# We want to hide empty directories
		if not FileCache.paths(item).empty():
			dirs.add_submenu_item(item, "Scripts")
		
func _on_about_to_show_scripts():
	dir = dirs.get_item_text(dirs.get_current_index())
	scripts.clear()
	scripts.set_as_minsize()
	var scriptlist = FileCache.paths(dir)
	if scriptlist.empty():
		return
	# Runs All Tests In Current Directory
	scripts.add_item("Run All Tests In This Directory", RUN.DIRECTORY)
	for item in scriptlist:
		if Directory.new().file_exists(item):
			scripts.add_submenu_item(item, "Methods")
#
func _on_about_to_show_methods():
	scriptname = scripts.get_item_text(scripts.get_current_index())
	methods.clear()
	methods.set_as_minsize()
	# Runs This Test
	methods.add_item("Run Test", RUN.SCRIPT)
	var methodlist = []
	# Are we sure this is always a test script?
	var script
	if scriptname.ends_with(".gd"):
		script = load(scriptname)
	else:
		# Display SuiteOfSuites
		var sourcename = scriptname.substr(0, scriptname.find(".gd") + 3)
		var nestedname = scriptname.substr(scriptname.find(".gd") + 4, scriptname.length())
		var source = load(sourcename)
		var expr: Expression = Expression.new()
		expr.parse(nestedname)
		script = expr.execute([], source)
	for method in script.get_script_method_list():
		if method.name.begins_with("test"):
			methods.add_submenu_item(method.name, "RunMethod")

func _on_about_to_show_run() -> void:
	method = methods.get_item_text(methods.get_current_index())
	run_method.clear()
	run_method.add_item("Run Method", RUN.METHOD)
