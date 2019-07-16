extends WATTest

# Scenes don't hold any static state; only references to other resources
# (We might need to load these resources each access but probably not?)
# We want to prevent dictionary errors on unreference...\
# We could probably handle this memory manually?
# We don't want to be calling object more than once on each resource

# I don't think we need to save the scene since we're creating
# the tree on the fly but it might end up necessary for Godot
# to read the scene contents
const SCENEDIRECTOR = preload("res://scene.gd")
const scenepath = "res://Examples/Scene/Main.tscn"

func double_scene(scenepath: String):
	var nodes: Dictionary = {}
	var instance: Node = load(scenepath).instance()
	var frontier: Array = [instance]
	while not frontier.empty():
		var next: Node = frontier.pop_front()
		frontier += next.get_children()
		var path: String = instance.get_path_to(next)
		nodes[path] = double(next.get_script().resource_path)
	return SCENEDIRECTOR.new(nodes)

func test_when_we_call_double():
	clear_temp()
	describe("When we call double")
	# !!! Everytime we reload the SCENEDIRECTOR script, we get a new instance
	# However if we don't reload, then we run into repeating objects
	var scene = double_scene(scenepath)
	scene.get_node(".").method("test").stub(9999)
	var inst = scene.object()
	expect.is_not_null(scene, "We get a non-null value back")
	expect.is_Object(scene, "We get an Object back")
	expect.is_not_null(scene.get_node("A"), "We can call custom get node method")
	expect.string_ends_with(".tres", scene.get_node("A").resource_path, "We get a .tres file back from get_node()")
	expect.is_not_null(inst, "We can call .object()")
	expect.is_greater_than(FILESYSTEM.file_list("user://WATemp/").size(), 0, "Temp is not empty")
	expect.is_equal(9999, inst.test(), "Called a stubbed test on root")
	inst.free()
	scene.free()

# testGivenASceneDoubler
	# When we call double
		# We get a non-null value back
		# We get an object back
		# We can call (custom) get_node()
		# We can call .object()
	# When we stub a child resource
		# We 
	# We get a non-null value back
	# We get an Object back
	# When calling Object
		# We get a node back with children
	# We can call get_node
		# Which gives us a resource
		# That we can stub