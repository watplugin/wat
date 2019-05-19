extends WATTest

const scene = preload("res://Examples/Scene/Main.tscn")

# This causes issues 

#func test_double_scene():
##	var scene_double = DOUBLE.scene(scene)
#	var scene_double = double_scene(scene)
#	add_child(scene_double.instance)
#	scene_double.execute("A", "execute")
#	scene_double.instance.get_node("A").execute()
#	expect.was_called(scene_double, ".", "test", "test was called (should fail)")
#	expect.was_called(scene_double, "A", "execute", "executed was called (should pass)")
