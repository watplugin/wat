extends Reference

const Doubler = preload("doubler.gd")
const FILESYSTEM = preload("res://addons/WAT/utils/filesystem.gd")

static func double(path, inner: String = "", dependecies = null):
	var doubler = Doubler.new()
	var index = FILESYSTEM.file_list("user://WATemp").size()
	var savepath: String = "user://WATemp/R%s.tres" % index as String
	doubler.base_script = path
	doubler.inner = inner
	doubler.index = index as String
	ResourceSaver.save(savepath, doubler)
	var double = load(savepath)
	return double