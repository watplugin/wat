extends Object

const ScriptDirector = preload("script_director.gd")
const SceneDirector = preload("scene_director.gd")
var registry

func script(path, inner: String = "", deps: Array = []) -> ScriptDirector:
	if path is GDScript: path = path.resource_path
	return ScriptDirector.new(registry, path, inner, deps)

func scene(tscn) -> SceneDirector:
	# Must be String.tscn or PackedScene
	var scene: PackedScene = load(tscn) if tscn is String else tscn
	var instance: Node = scene.instance()
	var nodes: Dictionary = {}
	var frontier: Array = []
	frontier.append(instance)
	while not frontier.empty():
		var next: Node = frontier.pop_front()
		if next.name.begins_with("@@"):
			# Don't double engine-generated classes (usually begin with @@)
			continue
		frontier += next.get_children()
		var path: String = instance.get_path_to(next)
		if next.get_script() != null:
			nodes[path] = script(next.get_script().resource_path)
		elif ClassDB.class_exists(next.get_class()):
			nodes[path] = script(next.get_class())
	_set_nodepath_variables(instance, nodes)
	instance.queue_free()
	return SceneDirector.new(nodes)
	
func _set_nodepath_variables(instance, nodes: Dictionary):
	# Nodepath Variables Are Exported
	# Which means they are typically not shared by instances
	# Therefore we got to do it manually
	for path in nodes:
		var source = instance.get_node(path)
		var copy = nodes[path]
		for prop in source.get_property_list():
			if(prop.type == TYPE_NODE_PATH and prop.name != "_import_path"):
				var exported_value = source.get(prop.name) as NodePath
				copy.nodepaths[prop.name] = exported_value as NodePath
