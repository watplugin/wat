extends WATTest


const scenepath = "res://Examples/Scene/Main.tscn"

func title():
	return "SceneDirector"

func test_when_we_call_double():
	clear_temp()
	describe("Doubles Scene")
	
	var scene = direct.scene(scenepath)
	scene.get_node(".").method("test").stub(9999)
	scene.get_node("A").method("execute").stub(1111)
	scene.get_node("C/D").method("wowsers").stub(9999)
	
	var inst = scene.double()
	asserts.is_equal(1111, inst.get_node("A").execute(), "We can call method on child of root")
	asserts.is_not_null(scene, "We get a non-null value back")
	asserts.is_Object(scene, "We get an Object back")
	asserts.is_not_null(scene.get_node("A"), "We can call custom get node method")
	asserts.string_ends_with(".tres", scene.get_node("A").resource_path, "We get a .tres file back from get_node()")
	asserts.is_not_null(inst, "We can call .double()")
	asserts.is_equal(9999, inst.test(), "Called a stubbed test on root")
	asserts.is_equal(9999, inst.get_node("C/D").wowsers(), "Called a stubbed method on a nested child")

func test_doubling_two_scenes():
	describe("Doubles two identical scenes")
	var d1 = direct.scene(scenepath)
	var d2 = direct.scene(scenepath)
	asserts.is_not_equal(d1.nodes["."], d2.nodes["."], "Doubles do not share resources")

	d1.get_node(".").method("test").stub(9999)
	d2.get_node(".").method("test").stub(777)

	var o1 = d1.double()
	var o2 = d2.double()

	asserts.is_not_equal(o1.test(), o2.test(), "Doubles do not share stubs")