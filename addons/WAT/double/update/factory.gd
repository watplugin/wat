extends Node

const BLANK = preload("res://addons/WAT/double/objects/blank.gd")
const FILESYSTEM = preload("res://addons/WAT/utils/filesystem.gd")
const DATA = preload("res://addons/WAT/double/update/data.gd")
	
static func create(path: String) -> DATA:
	print("calling create")
	var script: Script = load(path)
	print(script != null)
	var double: Script = BLANK.duplicate()
#	double.source_code = 'extends "%s"' % script.resource_path
	var count: String = FILESYSTEM.file_list("user://WATemp").size() as String
	var datapath: String = "user://WATemp/R%s.tres" % count
	var doubled_path: String = "user://WATemp/S%s.gd" % count
	double.source_code = 'extends "%s"' % script.resource_path
	print("past source code")
	var data = DATA.new()
	data.doubled_path = doubled_path
	for method in script.new().get_method_list():
		data.methods[method.name] = {argcount = method.args.size(), retval = null}
	print("past method loops")
	ResourceSaver.save(datapath, data)
	var err = ResourceSaver.save(doubled_path, double)
	print(err, " is err")
	return data
