extends WAT.Test

# Developers may create a Scene Director from the string path of the Scene..
# ..and then call .double() on it to create a Scene Test Double, this will
# ..double every node in the Scene as well. Developers may only call double
# ..once, any successive calls will fail.
func test_create_a_test_scene_director_from_string_path() -> void:
	var scene = direct.scene("res://examples/doubles/scenes/Main.tscn")
	var double = scene.double()
	asserts.is_class_instance(double, MySceneRootClass)

# Developers may create a Scene Director from a packed sceneand then call.. 
# ..double() on it to create a Scene Test Double, this will double every.. 
# ..node in the Scene as well. Developers may only call double once.. 
# ..any successive calls will fail.
func test_create_a_test_scene_director_from_packed_scene() -> void:
	var packed_scene = load("res://examples/doubles/scenes/Main.tscn")
	var scene = direct.scene(packed_scene)
	var double = scene.double()
	asserts.is_class_instance(double, MySceneRootClass)
