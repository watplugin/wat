extends WAT.Test

var director

func title():
	return "Given a Scene Director"

func pre():
	director = direct.scene("res://Examples/Scene/Main.tscn")

func test_When_we_create_two_of_it_for_the_same_scene():
	describe("When we create two of it for the same scene")

	var director_b = direct.scene("res://Examples/Scene/Main.tscn")

	asserts.is_not_equal(director.nodes, director_b.nodes, "Then they do not share resources")

func test_When_we_call_a_method_from_the_root_node_that_we_stubbed():
	describe("When we call a method from the root node that we stubbed")

	director.get_node(".").method("test").stub(9999)
	var double = director.double()
	asserts.is_equal(9999, double.get_node(".").test(), "Then we get the stubbed return value")
#
func test_When_we_call_a_method_from_a_child_node_that_we_stubbed():
	describe("When we call a method from a child node that we stubbed")

	director.get_node("A").method("execute").stub(999)

	asserts.is_equal(999, director.double().get_node("A").execute(), "Then we get the stubbed return value")

func test_When_we_call_a_method_from_a_grandchild_node_that_we_stubbed():
	describe("When we call a method from a grandchild node that we stubbed")

	director.get_node("C/D").method("wowsers").stub(99)

	asserts.is_equal(99, director.double().get_node("C/D").wowsers(), "Then we get the stubbed return value")

func test_When_we_add_it_to_the_tree_it_runs():
	describe("When we add it to the tree it runs")

	var double = director.double()
	asserts.is_equal(double.path, @"A", "We have the correct NodePath Set")
	add_child(double)
