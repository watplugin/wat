extends WAT.Test

# Developers may call .double() on a Scene Director to double every node in..
# ..the Scene. Developers may only call double() once, any successive calls..
# ..will fail. Scene Doubles use their base implementation unless any of..
# ..their children were instructed otherwise.
func test_create_test_double_scene_instance():
	var scene = direct.scene("res://examples/doubles/scenes/Main.tscn")
	var double = scene.double()
	asserts.is_class_instance(double, MySceneRootClass)
	
# Developers can use .get_node(nodepath: String) on a Scene Director to get..
# ..the Script Director for the corresponding node in the Scene and instruct..
# ..it how to act as a Test Double. 
func test_can_stub_methods_of_scene_double_children():
	var scene = direct.scene("res://examples/doubles/scenes/Main.tscn")
	var nodepath = "ChildA/GrandChildA"
	var grandchild_a = scene.get_node(nodepath)
	grandchild_a.method("get_title").stub("Stub")
	var double = scene.double()
	asserts.is_equal(double.get_node(nodepath).get_title(), "Stub")
