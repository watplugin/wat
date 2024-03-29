extends WAT.Test

var director

func title():
	return "Given a Script Director"
	
func pre():
	director = direct.script("res://OldExamples/Scripts/calculator.gd")
	
func test_When_we_create_two_of_it_for_the_same_script():
	describe("When we create two of it for the same script")

	var director_b = direct.script("res://OldExamples/Scripts/calculator.gd")

	asserts.is_not_equal(director.base_methods, director_b.base_methods, "Then they do not share resources")

func test_When_we_call_double_a_second_time_on():
	describe("When we call the double the second time")

	var silence_error: bool = false
	var double = director.double()
	var double_again = director.double([], silence_error)
	asserts.is_equal(double, double_again, "Then we get the same double back")

func test_from_name() -> void:
	var d = direct.script(MyClass)
	var dbl = d.double()
	asserts.is_class_instance(dbl, MyClass)

func test_When_we_double_an_inner_class():
	describe("When we double an inner class")

	var Algebra = load("res://OldExamples/Scripts/calculator.gd").Algebra
	director = direct.script("res://OldExamples/Scripts/calculator.gd", "Algebra")

	asserts.is_class_instance(director.double(), Algebra, "Then we get that inner class back")


