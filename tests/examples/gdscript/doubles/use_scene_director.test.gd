extends WAT.Test

func test_create_test_double_scene_instance():
	var scene = direct.scene("res://examples/doubles/scenes/Main.tscn")
	var double = scene.double()
	asserts.is_class_instance(double, MySceneRootClass)
	
func test_can_stub_methods_of_scene_double_children():
	var scene = direct.scene("res://examples/doubles/scenes/Main.tscn")
	var nodepath = "ChildA/GrandChildA"
	var grandchild_a = scene.get_node(nodepath)
	grandchild_a.method("get_title").stub("Stub")
	var double = scene.double()
	asserts.is_equal(double.get_node(nodepath).get_title(), "Stub")
