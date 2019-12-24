extends Reference

const _SCRIPT_DIRECTOR: Object= preload("res://addons/WAT/double/script_director.gd")
const _SCENE_DIRECTOR: Resource = preload("res://addons/WAT/double/scene_director.gd")
const _INVALID: String = ""
var _cache: Array = []
var _count: int = 0

func script(path, inner_class: String = "", dependecies: Array = []):
	path = path if path is String else path.resource_path
	var script_director: Object = _create_save_and_load_director(path, inner_class, dependecies)
	var base: Object = load(path) if inner_class == _INVALID else _load_nested_class(path, inner_class)
	base = base.callv("new", script_director.dependecies)
	_cache.append(base)
	script_director = _collect_methods(script_director, base)
	return script_director
	# return null
	
func _collect_methods(director, base):
	var params: String = "abcdefghij"
	for m in base.get_method_list():
		var arguments: String = ""
		for i in m.args.size():
			arguments = arguments + params[i] + ", "
		arguments = arguments.rstrip(", ")
		director.base_methods[m.name] = arguments
	return director

func scene(scenepath):
	# Must be String.tscn or PackedScene
	scenepath = scenepath if scenepath is String else scenepath.resource_path
	var nodes: Dictionary = {}
	var instance: Node = load(scenepath).instance()
	# var instance = Node.new()
	var frontier: Array = []
	frontier.append(instance)
	while not frontier.empty():
		var next: Node = frontier.pop_front()
		frontier += next.get_children()
		var path: String = instance.get_path_to(next)
		var new_script = next.get_script()
		if new_script != null:
			nodes[path] = script(new_script.resource_path)
	var scene_director = _SCENE_DIRECTOR.new(nodes)
	# _cache.append(scene_director)
	print("trying to free instance")
	instance.free()
	# return null
	print("freed instance")
	return scene_director

func _create_save_and_load_director(path, inner: String, dependecies: Array) -> Resource:
	var script_director = _SCRIPT_DIRECTOR.new()
	_count += 1
	var index: String = _count as String
#	var savepath: String = "%s/WATemp/R%s.tres" % [OS.get_user_data_dir(), index]
	script_director.base_script = path
	script_director.inner = inner
	script_director.index = index
	script_director.dependecies = dependecies
#	ResourceSaver.save(savepath, script_director)
#	var acting_director = load(savepath)
#	return acting_director
	return script_director
	
func _load_nested_class(path, inner: String) -> Script:
	var expression = Expression.new()
	var script = load(path)
	expression.parse("%s" % [inner])
	return expression.execute([], script, true)

func clear() -> void:
	for item in _cache:
		if item is Object and not item is Reference:
			item.free()
	_cache.clear()
