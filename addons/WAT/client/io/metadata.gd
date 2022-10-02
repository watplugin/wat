extends Reference

static func load_metadata(filesystem: Reference) -> void:
	var path: String
	if not filesystem.Settings.metadata_directory():
		path = filesystem.Settings.test_directory()
	else:
		path = filesystem.Settings.metadata_directory()
	path += "/metadata.json"
	if not Directory.new().file_exists(path):
		return

	var file = File.new()
	file.open(path, File.READ)
	var content: Dictionary = JSON.parse(file.get_as_text()).result
	file.close()
	
	for key in content:
		if key == "failed":
			filesystem.failed.paths = content[key]
		else:
			filesystem.tagged.tagged[key] = content[key]
		
static func save_metadata(filesystem: Reference) -> void:
	var path: String
	if not filesystem.Settings.metadata_directory():
		push_warning("WAT: Cannot find metadata directory. Defaulting to test directory to save metadata")
		path = filesystem.Settings.test_directory()
	else:
		path = filesystem.Settings.metadata_directory()
	if not Directory.new().dir_exists(path):
		Directory.new().make_dir_recursive(path)
		
	path += "/metadata.json"
	var data = {"failed": filesystem.failed.paths}
	for tag in filesystem.tagged.tagged:
		var paths: Array = filesystem.tagged.tagged[tag]
		if not paths.empty():
			data[tag] = paths
	
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(JSON.print(data, "\t", true))
	file.close()
