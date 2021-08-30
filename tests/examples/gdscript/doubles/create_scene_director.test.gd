extends WAT.Test

func test_create_a_test_scene_director_from_string_path() -> void:
	var scene = direct.scene("res://examples/doubles/scenes/Main.tscn")
	var double = scene.double()
	asserts.is_class_instance(double, MySceneRootClass)
	
func test_create_a_test_scene_director_from_packed_scene() -> void:
	var packed_scene = load("res://examples/doubles/scenes/Main.tscn")
	var scene = direct.scene(packed_scene)
	var double = scene.double()
	asserts.is_class_instance(double, MySceneRootClass)
