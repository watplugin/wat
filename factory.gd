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
	var instanced_base
	double.dependecies = dependecies
	if use_container:
		instanced_base = container.resolve(load(path)) # We're doubling an inner so this doesn't exist?
		double.dependecies = container.get_constructor(load(path))
		cache.append(instanced_base)
		if inner != "":
			for i in inner.split(".", false):
				double.dependecies = container.get_constructor(instanced_base.get(i))
				instanced_base = container.resolve(instanced_base.get(i))
				cache.append(instanced_base)
	elif not use_container:
		instanced_base = load(path).new()
		#### This causes a test to fail
		#### When we comment it out, run the tests, then comment it back in..
		#### it starts to work, so this is likely a load from memory issue
		#### Maybe the identifiers aren't unique?

		######### This causes a test to fail (if we also clear the cache)
		######### It might be because it's owner script is cleared
		cache.append(instanced_base)

		if inner != "":
			for i in inner.split(".", false):
				instanced_base = instanced_base.get(i).new()
				cache.append(instanced_base)
				if i == "Algebra":
					# We're loading two different instances of the inner class so we
					# are running into issues here where one loaded script is not the other loaded script
					# despite both being loaded from the same instance
					print(instanced_base.get_script(), " is Algebra from Factory")
	for m in instanced_base.get_method_list():
		double.base_methods[m.name] = "a,b,c,d,e,f,g,h,i,j,".substr(0, m.args.size() * 2 - 1)
	return double

func clear():
	for item in cache:
		if item is Object and not item is Reference:
			item.free()
	cache.clear()