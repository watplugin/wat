extends WATTest

const scene = preload("res://Examples/Scene/Main.tscn")

func test_double_scene():
	var scene_double = WATDouble.scene(scene)
	add_child(scene_double.instance)
	scene_double.instance.get_node("A").execute()
	expect.was_called(scene_double.instance.get_node("A").get_meta("double"), "execute", "execute was called")
	expect.was_called(scene_double.instance.get_meta("double"), "test", "test was called")