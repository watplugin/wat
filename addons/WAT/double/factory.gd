extends Reference

const _SCRIPT_DIRECTOR: Object= preload("res://addons/WAT/double/script_director.gd")
const _SCENE_DIRECTOR: Resource = preload("res://addons/WAT/double/scene_director.gd")
const _INVALID: String = ""
var _count: int = 0

func script(path, inner_class: String = "", dependecies: Array = []):
	var builtin = false
	if path is GDScript:
		path = path.resource_path
	if ClassDB.class_exists(path):
		builtin = true
	_count += 1
	var index: String = _count as String
	var script_director = _SCRIPT_DIRECTOR.new(index, path, inner_class, dependecies, builtin)
#	script_director = _collect_methods(script_director)
	script_director.set_methods()
	return script_director


#	return director

func scene(scenepath):
	# Must be String.tscn or PackedScene
	scenepath = scenepath if scenepath is String else scenepath.resource_path
	var nodes: Dictionary = {}
	var instance: Node = load(scenepath).instance()
	var frontier: Array = []
	frontier.append(instance)
	while not frontier.empty():
		var next: Node = frontier.pop_front()
		if next.name.begins_with("@@"):
			# Don't double engine-generated classes (usually begin with @@)
			continue
		frontier += next.get_children()
		var path: String = instance.get_path_to(next)
		var new_script = next.get_script()
		if new_script != null:
			nodes[path] = script(new_script.resource_path)
		elif ClassDB.class_exists(next.get_class()):
			nodes[path] = script(next.get_class())
	var scene_director = _SCENE_DIRECTOR.new(nodes)
	instance.free()
	return scene_director
