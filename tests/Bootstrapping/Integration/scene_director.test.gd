extends WAT.Test

var director

func title():
	print("Title() called")
	return "Given a Scene Director"
	
func pre():
	print("pre() of scene_director.test.gd called")
	director = direct.scene("res://Examples/Scene/Main.tscn")
	
func test_When_we_create_a_test_double_from_it():
	describe("When we create a test double from it")
	
	print("Testing When we create a test double from it")
	var actual: String = director.double().get_script().resource_path
	var expected: String = "%s/WATemp" % OS.get_user_data_dir()
	asserts.string_begins_with(expected, actual, \
		"Then the doubled object's script is saved in the %s/WATemp" % OS.get_user_data_dir())

func test_When_we_create_two_of_it_for_the_same_scene():
	describe("When we create two of it for the same scene")
	
	print("Testing When we create two of it for the same scene")
	var director_b = direct.scene("res://Examples/Scene/Main.tscn")
	
	asserts.is_not_equal(director.nodes, director_b.nodes, "Then they do not share resources")
	
func test_When_we_call_a_method_from_the_root_node_that_we_stubbed():
	describe("When we call a method from the root node that we stubbed")
	
	print("Testing When we call a method from the root node that we stubbed")
	director.get_node(".").method("test").stub(9999)
	
	asserts.is_equal(9999, director.double().get_node(".").test(), "Then we get the stubbed return value")
	
func test_When_we_call_a_method_from_a_child_node_that_we_stubbed():
	describe("When we call a method from a child node that we stubbed")
	
	print("Testing When we call a method from a chidl node that we stubbed")
	director.get_node("A").method("execute").stub(999)
	
	asserts.is_equal(999, director.double().get_node("A").execute(), "Then we get the stubbed return value")

#func test_When_we_call_a_method_from_a_grandchild_node_that_we_stubbed():
#	describe("When we call a method from a grandchildchild node that we stubbed")
#
#	print("Testing When we call a method from a grandchild node that we stubbed")
#	director.get_node("C/D").method("wowsers").stub(99)
#
#	asserts.is_equal(99, director.double().get_node("C/D").wowsers(), "Then we get the stubbed return value")

