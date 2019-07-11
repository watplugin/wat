extends Reference

const Doubler = preload("doubler.gd")
const FILESYSTEM = preload("res://addons/WAT/utils/filesystem.gd")

var count: int = 0

func double(path, inner: String = "", dependecies = null):
	var doubler = Doubler.new()
	var index = FILESYSTEM.file_list("user://WATemp").size() as String
	index += count as String
	count += 1
	var savepath: String = "user://WATemp/R%s.tres" % index as String
	doubler.base_script = path
	doubler.inner = inner
	doubler.index = index
	ResourceSaver.save(savepath, doubler)
	var double = load(savepath)
	double.instanced_base = load(path).new()
	if inner != "":
		for i in inner.split(".", false):
			double.instanced_base = double.instanced_base.get(i).new()
		assert(double.instanced_base != null)
	double.method_args()
	return double