extends WATTest

func pre():
	clear_temp()

func test_when_doubling_a_script_we_get_a_text_resource_file_back():
	describe("When doubling, we get a text resource (.tres) file back")

	var doubler = double("res://Examples/Scripts/calculator.gd")
	var expected: String = ".tres"
	expect.string_ends_with(expected, doubler.resource_path)

func test_when_doubling_a_script_the_doubler_saves_the_base_script():
	# Misleading?
	describe("When doubling a script, the doubler saves the base scripts path")

	var doubler = double("res://Examples/Scripts/calculator.gd")
	expect.is_not_null(doubler.base_script, "A string was saved")
	expect.is_equal(doubler.base_script, "res://Examples/Scripts/calculator.gd", "Saved string is equal to base scripts path")

func test_when_doubling_two_scripts_they_do_not_share_resources():
	describe("When doubling two scripts, they do not share the same resources")

	var doubler_a = double("res://Examples/Scripts/calculator.gd")
	# When first saving a script, we reload it via its path (in the double method)
	# If for some reason we cleared out our temp too early, we'd end up loading
	# an older script (or having an older script change when we're trying to refer
	# to a newer script)
	clear_temp()
	var doubler_b = double("res://Examples/Scripts/calculator.gd")
	doubler_b.base_methods["SuperFakeMethod"] = "FakeArgs"
	expect.does_not_have("SuperFakeMethod", doubler_a.methods)

func test_when_doubling_a_script_we_can_invoke_the_base_script_method():
	describe("When doubling a script, we can invoke the base methods of the script")

	var calculator_double = double("res://Examples/Scripts/calculator.gd")
	var expected = 4
	var actual = calculator_double.object().add(2, 2)
	expect.is_equal(expected, actual, "Called base implementation of add with arguments(2, 2)")

func test_when_creating_a_doubled_object_it_is_saved_in_user_watemp():
	describe("When we create a doubled object, its script is saved in user://WATemp")

	var doubler = double("res://Examples/Scripts/calculator.gd")

	var expected: String = "user://WATemp"
	var actual = doubler.object().get_script().resource_path
	expect.string_begins_with(expected, actual, "Doubled Object's script was saved in user://WATemp")

func test_when_invoking_a_dummy_method_in_a_double_we_get_null():
	describe("When we dummy a method in a double we receive null")

	var SUT_double = double("res://Examples/Scripts/calculator.gd")
	SUT_double.dummy("add")

	var SUT = SUT_double.object()

	var SUT_expected = null
	var SUT_actual = SUT.add(2, 2)

	expect.is_equal(SUT_expected, SUT_actual, "System Under Test's dummied add returns null")

func test_when_stubbing_a_method_with_a_return_value_of_true_that_method_will_return_true_when_called():
	describe("When stubbing a method with a return value of true that method will return true when called")

	var doubler = double("res://Examples/Scripts/calculator.gd")
	doubler.stub("add", true)

	var expected = true
	var actual = doubler.object().add(2, 2)
	expect.is_equal(expected, actual, "Stubbed method returned true when called")

func test_when_we_stub_a_method_with_a_return_value_of_an_instantiated_node_we_get_that_exact_same_node_back():
	describe("When we stub a method with a return value of an instantiated Node that method will return that exact Node when called")

	var doubler = double("res://Examples/Scripts/calculator.gd")
	var node = Node.new()
	doubler.stub("add", node)

	var expected = node
	var actual = doubler.object().add(2, 2)
	expect.is_equal(expected, actual, "Stubbed method return the exact same Node that we stubbed it with")
	
	node.free()

func test_when_we_try_to_create_a_doubled_object_for_a_second_time_from_the_same_doubler_we_get_null_back():
	describe("When we try to created a doubled object for a second time from the same doubler we get null back")

	var doubler = double("res://Examples/Scripts/calculator.gd")
	var obj1 = doubler.object()
	var obj2 = doubler.object()
	expect.is_null(obj2, "We got null when we tried to re-create an object from the Doubler for a second time")

func test_when_we_spy_we_can_check_it_was_spied_on():
	describe("When we call spy on a method, it")
	describe("When we spy on method add, its call count array will be of size 1") # Implementation Detail?
	describe("When we spy on add and then call it, the fact it was called was recorded")

	# Requires refactoring
	var doubler = double("res://Examples/Scripts/calculator.gd")
	doubler.spy("add")
	var obj1 = doubler.object()
	obj1.add(5, 5)
	expect.was_called(doubler, "add", "add was called")

func test_when_we_stub_a_method_based_on_what_args_it_receives_and_then_we_call_it_with_those_argss_it_returns_the_corresponding_return_value():
	describe("When we stub a method based on what args it receives and then we call it with those args, it returns the corresponding return value")

	var doubler = double("res://Examples/Scripts/calculator.gd")

	# We require two to check if retvals differentiate
	doubler.stub("add", 9999, [5000, 5000])
	doubler.stub("add", 777, [0, 10])
	var object = doubler.object()
	var expect_a = 9999
	var expect_b = 777

	var actual_a = object.add(5000, 5000)
	var actual_b = object.add(0, 10)
	expect.is_equal(expect_a, actual_a, "stubbed method add returned 9999 when passed args(5000, 5000)")
	expect.is_equal(expect_b, actual_b, "stubbed method add returned 777 when passed args(0, 10)")

func test_when_we_stub_a_method_with_args_that_include_non_primitive_object_we_get_the_corresponding_return_values_back():
	describe("When we stub a method with args that include non primitive object we get the corresponding return values back")

	var complex_object = Node.new()
	var doubler = double("res://Examples/Scripts/calculator.gd")
	doubler.stub("add", 9999, [0, complex_object])

	var expected = 9999
	var actual = doubler.object().add(0, complex_object)

	expect.is_equal(expected, actual, "Stubbed method add returned 9999 when passed args (0, Node)")
	
	complex_object.free()

func test_when_we_stub_a_method_with_args_that_include_any_we_get_the_corresponding_return_values_back_provided_all_args_except_arg_any_matches():
	describe("When we stub a method that with args that include a call to any(), we get the corresponding return values back provided all args expect any() match")

	var doubler = double("res://Examples/Scripts/calculator.gd")
	doubler.stub("add", 9999, [10, any()])
	var object = doubler.object()

	var expected = 9999
	var actual = object.add(10, 25)

	expect.is_equal(expected, actual, "Stubbed add returned 9999 when called with arg(10, 25)")

###################################################################
func test_we_can_check_a_method_was_called_with_arguments():
	describe("When we spy on a method, we can check which arguments it was called with")

	# Fix Naming
	var doubler = double("res://Examples/Scripts/calculator.gd")
	doubler.spy("add")
	var expected_arguments = [10, 10]

	doubler.object().add(10, 10)
	expect.was_called_with_arguments(doubler, "add", expected_arguments, "Double was called with a(10) & b(10)")

func test_when_we_stub_a_method_to_call_its_parent_implementation_as_the_default_it_will_call_its_parents_implementation_unless_a_specific_arg_pattern_was_passed_in():
	describe("When we stub a method to call its parent implementation as the default it will call its parent implementation unless a specific argument pattern was passed in")

	var doubler = double("res://Examples/Scripts/calculator.gd")
	doubler.call_super("add")
	doubler.stub("add", 9999, [10, 10])
	var object = doubler.object()
	var expected_sut = 10
	var expected_control = 9999

	var actual_sut = object.add(5, 5)
	var actual_control = object.add(10, 10)

	expect.is_equal(expected_sut, actual_sut, "Parent's implementation of .add(a, b) was called")
	expect.is_equal(expected_control, actual_control, "add(10, 10) matches a special case args stub pattern so the parent's implementation was not called")

func test_when_we_spy_methods_it_rewrites_with_the_correct_amount_of_arguments():
	describe("When we add a method to our doubler, it writes the correct number of arguments")

	# Awful misleading test
	var doubler = double("res://Examples/Scripts/calculator.gd")
	doubler.stub("sum", 111)
	var object = doubler.object()
	var expected = 111
	var actual = object.sum([10, 4, 9, 2])
	expect.is_equal(expected, actual, "Sum was stubbed successfully")

func test_we_can_stub_methods_that_include_keywords_given_we_pass_in_the_correct_keyword_the_first_time_we_stub_that_method():
	describe("We can stub methods with keywords given we pass in the correct keyword the first time we stub that method")

	var doubler = double("res://Examples/Scripts/calculator.gd")
	doubler.stub("pi", 3, [], doubler.STATIC)
	var expected = 3

	var result = doubler.object().pi()

	expect.is_equal(3, result, "stubbed static method")

func test_when_we_double_an_inner_class_then_call_object_on_the_doubler_we_get_the_doubled_inner_class_back():
	describe("When we double an inner class then call object() on the doubler we get the doubled inner class back")

	var Algebra = load("res://Examples/Scripts/calculator.gd").Algebra
	var doubler = double("res://Examples/Scripts/calculator.gd", "Algebra")
	var object = doubler.object()

	expect.is_class_instance(object, Algebra, "doubled inner class is an instance of Algebra")

func test_when_we_consume_other_doubles_as_inner_classes_we_can_access_their_stubbed_static_methods():
	describe("When we consume other doubles as inner classes we can access their stubbed static methods")

	var primary = double("res://Examples/Scripts/calculator.gd")
	var inner = double("res://Examples/Scripts/calculator.gd", "Algebra")
	primary.add_inner_class(inner, "Algebra")
	inner.stub("create_vector", 10, [], inner.STATIC)

	var object = primary.object()

	var expected = 10
	var result = object.Algebra.create_vector()

	expect.is_equal(expected, result, "We invoked stubbed static method create_vector of our inner class doubled Algebra from our doubled Calculator")








