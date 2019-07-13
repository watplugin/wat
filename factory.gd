extends Reference

# TODO
# We'll probably handle dependecies here
# Something like double(path, inner, depedency array), then using Class.callv("new", dependecy array)
# Depedencies are only to satisfy constructors that lack defaults, we can probably use the constructor size

const Doubler = preload("doubler.gd")
const FILESYSTEM = preload("res://addons/WAT/utils/filesystem.gd")
var cache: Array = []

var count: int = 0

func double(path, inner: String, dependecies: Array, container: Reference, use_container: bool):
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
	var base
	double.dependecies = dependecies
	if use_container:
		base = load_using_container(path, inner, container, double)
	elif not use_container:
		base = load_not_using_container(path, inner)
	for m in base.get_method_list():
		double.base_methods[m.name] = "a,b,c,d,e,f,g,h,i,j,".substr(0, m.args.size() * 2 - 1)
	return double

func load_using_container(path, inner, container, double):
	var base = container.resolve(load(path)) # We're doubling an inner so this doesn't exist?
	double.dependecies = container.get_constructor(load(path))
	cache.append(base)
	if inner != "":
		for i in inner.split(".", false):
			double.dependecies = container.get_constructor(base.get(i))
			base = container.resolve(base.get(i))
			cache.append(base)
	return base

func load_not_using_container(path, inner):
	var base = load(path).new()
	cache.append(base)
	if inner != "":
		print(inner, "x")
		return load_inner(path, inner)
	return base

func load_inner(path, inner_classes) -> Object:
	var expression = Expression.new()
	var script = load(path)
	expression.parse("%s.new()" % [inner_classes])
	return expression.execute([], script, true)

func clear():
	for item in cache:
		if item is Object and not item is Reference:
			item.free()
	cache.clear()