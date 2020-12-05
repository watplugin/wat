extends Node

const fileCache = preload("cache.tres")

var dock: FileSystemDock

func initialize():
	fileCache.scripts = {}
	var root = ProjectSettings.get_setting("WAT/Test_Directory")
	search(root)
	ResourceSaver.save(fileCache.resource_path, fileCache)
	
func search(root: String):
	var subdirs = []
	var d = Directory.new()
	d.open(root)
	d.list_dir_begin(true) # do not search parent directories
	var name = d.get_next()
	while name != "":
		var title = root + "/" + name
		
		# load script
		if name.ends_with(".gd"):
			var script = load(title)
			if script.get("TEST") != null:
				fileCache.scripts[title] = script
			elif script.get("IS_WAT_SUITE"):
				pass
				
		# add dir
		if d.dir_exists(name):
			subdirs.append(name)
		name = d.get_next()
	d.list_dir_end()
	for dir in subdirs:
		search(root + "/" + dir)
	
func do_action():
	initialize()
