extends Reference

# TODO
# We'll probably handle dependecies here
# Something like double(path, inner, depedency array), then using Class.callv("new", dependecy array)
# Depedencies are only to satisfy constructors that lack defaults, we can probably use the constructor size

const Doubler = preload("res://addons/WAT/double/doubler.gd")
const SCENEDIRECTOR = preload("res://addons/WAT/double/scene.gd")
const FILESYSTEM = preload("res://addons/WAT/filesystem.gd")
var cache: Array = []
var count: int = 0

func script(path, inner: String = "", dependecies: Array = [], container: Reference = null, use_container: bool = false):
	var double = _create_save_and_load_doubler(path, inner, dependecies)
	var base: Object = _load_nested_class(path, inner) if inner != "" else load(path)
	if use_container:
		double.dependecies = container.get_constructor(base)
	base = base.callv("new", double.dependecies)
	cache.append(base)
	for m in base.get_method_list():
		double.base_methods[m.name] = "a,b,c,d,e,f,g,h,i,j,".substr(0, m.args.size() * 2 - 1)
	return double

func scene(scenepath: String):
	var nodes: Dictionary = {}
	var instance: Node = load(scenepath).instance()
	var frontier: Array = [instance]
	while not frontier.empty():
		var next: Node = frontier.pop_front()
		frontier += next.get_children()
		var path: String = instance.get_path_to(next)
		nodes[path] = script(next.get_script().resource_path, "", [], null, false)
	var double = SCENEDIRECTOR.new(nodes)
	cache.append(double)
	instance.queue_free()
	return double

func _create_save_and_load_doubler(path, inner, dependecies):
	var doubler = Doubler.new()
	var index = FILESYSTEM.file_list("user://WATemp").size() as String
	index += count as String
	count += 1
	var savepath: String = "user://WATemp/R%s.tres" % index as String
	doubler.base_script = path
	doubler.inner = inner
	doubler.index = index
	doubler.dependecies = dependecies
	ResourceSaver.save(savepath, doubler)
	var double = load(savepath)
	return double

func _load_nested_class(path, inner) -> Script:
	var expression = Expression.new()
	var script = load(path)
	expression.parse("%s" % [inner])
	return expression.execute([], script, true)

func clear():
	for item in cache:
		if item is Object and not item is Reference:
			item.free()
	cache.clear()