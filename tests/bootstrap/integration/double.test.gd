extends WAT.Test

var director

func title():
	# Script Directors are responsible for setting up Test Double Scripts
	return "Given a Test Double"

func pre():
	director = direct.script("res://OldExamples/Scripts/calculator.gd")

func post():
	director = null

func test_When_we_call_an_add_method_that_we_have_not_directed():
	describe("When we call an add(x, y) method that we haven't directed")

	asserts.is_equal(4, director.double().add(2, 2), "Then we get the correct result")

func test_When_we_call_a_method_that_we_have_dummied():
	describe("When we call a method that we have dummied")

	director.method("add").dummy()

	asserts.is_null(director.double().add(2, 2), "Then we get null")

func test_When_we_call_a_method_that_we_have_stubbed_to_return_true():
	describe("When we call a method that we have stubbed to return true")

	director.method("add").stub(true)

	asserts.is_true(director.double().add(2, 2), "Then it returns true")

func test_When_we_call_a_method_that_we_have_stubbed_to_return_a_node():
	describe("When we call a method that we have stubbed to return a node")

	var node: Node = Node.new()
	director.method("add").stub(node)

	asserts.is_equal(node, director.double().add(2, 2), "Then it returns that same node")
	node.free()

func test_When_we_call_a_method_that_we_are_spying_on():
	# Add a not-called version?
	describe("When we call a method that we are spying on")

	director.method("add").spy()
	director.double().add(2, 2)

	asserts.was_called(director, "add", "Then we can see that it was called at least once")

func test_When_we_pass_arguments_to_a_method_call_that_we_are_spying_on():
	describe("When we pass arguments to a method call that we are spying on")

	director.method("add").spy()
	director.double().add(10, 10)

	asserts.was_called_with_arguments(director, "add", [10, 10], "Then we can see that it was called with those arguments")

func test_When_we_call_a_method_that_was_stubbed_to_return_different_values_based_on_argument_patterns():
	describe("When we call a method that was stubbed to return different values based on argument patterns")

	director.method("add").stub(100).stub(1000, [1, 1])
	var double = director.double()

	asserts.is_equal(100, double.add(2, 2), "Then it returns the default stubbed value when the arguments don't match any pattern")
	asserts.is_equal(1000, double.add(1, 1), "Then it returns the the corresponding value to the pattern the arguments matched")

func test_When_we_call_a_method_that_was_stubbed_with_an_argument_pattern_that_includes_a_non_primitive_object():
	describe("When we call a method that was stubbed with an argument pattern that includes a non-primitive object")

	var non_primitive_object: Node = Node.new()
	director.method("add").stub(9999, [0, non_primitive_object])

	asserts.is_equal(9999, director.double().add(0, non_primitive_object), "Then it returns the corresponding value when the pattern matches")
	non_primitive_object.free()

func test_When_we_call_a_method_that_was_stubbed_with_a_partial_argument_pattern():
	describe("When we call a method that was stubbed with a partial (ie using any()) argument pattern")

	director.method("add").stub(9999, [10, any()])

	asserts.is_equal(9999, director.double().add(10, 42), "Then it returns the corresponding value when the partial pattern matches")

func test_When_we_call_a_method_that_we_stubbed_to_call_its_super_implementation_by_default():
	describe("When we call a method that we stubbed to call its super implementation by default")

	director.method("add").call_super()
	director.method("add").stub(9999, [10, 10])
	var double = director.double()

	asserts.is_equal(4, double.add(2, 2), "Then it calls its super implementation by default")
	asserts.is_equal(9999, double.add(10, 10), \
		"Then it does not call its super implementation when arguments patterns match a different return value")

func test_When_we_add_a_doubled_inner_class_to_it():
	describe("When we add an doubled inner class to it")

	var inner = direct.script("res://OldExamples/Scripts/calculator.gd")
	director.add_inner_class(inner, "Algebra")

	asserts.is_equal(TAU, director.double().Algebra.get_tau(), "Then we can call the static methods of that inner double")

# TODO
func test_When_we_dummy_a_method_of_a_double_inner_class():
	describe("When we dummy a method of a doubled inner class")

	director = direct.script("res://OldExamples/Scripts/calculator.gd", "Algebra")
	director.method("scale").dummy()

	asserts.is_null(director.double().scale(0, 0), "Then we get the dummy value back")

func test_When_we_stub_a_method_of_a_double_inner_class():
	describe("When we stub a method of a doubled inner class")

	director = direct.script("res://OldExamples/Scripts/calculator.gd", "Algebra")
	director.method("scale").stub(null, [0, 0])


	asserts.is_null(director.double().scale(0, 0), "Then we get the stubbed value back")

func test_When_we_double_an_inner_class() -> void:
	describe("When we double an inner class")

	var inner = direct.script("res://OldExamples/Scripts/calculator.gd", "Algebra")
	var double = inner.double()
	asserts.is_Vector2(double.scale(Vector2(1, 1), 1), "Then we can call methods on it")

func test_When_we_double_a_method_with_a_keyword():
	describe("We can double methods with keyword automatically")

	director.method("pi").stub(true, [])

	asserts.is_equal(director.double().pi(), true, "Then it is doubled successfully")

func test_When_we_pass_in_deps_on_double() -> void:
	describe("When we pass in dependecies on double")

	director = direct.script("res://OldExamples/Scripts/user.gd")
	var double = director.double(["Jackie"])

	asserts.is_equal(double.username, "Jackie", "Then we can double the object successfully")

func test_When_we_pass_in_deps_on_direct() -> void:
	describe("When we pass in dependecies on direct")

	director = direct.script("res://OldExamples/Scripts/user.gd", "", ["Jackie"])
	var double = director.double()

	asserts.is_equal(double.username, "Jackie", "Then we can double the object successfully")

func test_When_we_pass_a_funcref_as_a_subcall():
	describe("When we pass a funcref as a subcall")

	director = direct.script(load("res://OldExamples/Scripts/calculator.gd"))
	var callable: FuncRef = funcref(self, "set_sum")
	director.method("add").subcall(callable)
	var double = director.double()
	double.add(10, 5)
	asserts.is_equal(double._sum, 99, "Then it affects the state of the double")

func test_When_we_pass_a_funcref_as_a_subcall_that_returns_a_value():
	describe("When we pass a funcref as a subcall that returns")

	director = direct.script(load("res://OldExamples/Scripts/calculator.gd"))
	var callable: FuncRef = funcref(self, "set_sum")
	var returns_value: bool = true
	director.method("add").subcall(callable, returns_value)
	asserts.is_equal(director.double().add(10, 5), 99, "Then it returns a value")

func test_When_we_pass_an_object_with_callfunc_method_as_a_subcall():
	describe("When we pass an Object with a call_func function")

	director = direct.script(load("res://OldExamples/Scripts/calculator.gd"))
	var callable: Object = Callable.new()
	var returns_value: bool = true
	director.method("add").subcall(callable, returns_value)
	asserts.is_equal([10, 5], director.double().add(10, 5), "Then it returns a value")

class Callable:
	var arguments: Array = []

	func call_func(_object: Object, args: Array):
		arguments = args
		return args

func set_sum(object, _args: Array = []) -> int:
	object._sum = 99
	return object._sum
