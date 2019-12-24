extends WAT.Test

var director

func title():
	return "Given a Script Director"
	
func pre():
	director = direct.script("res://Examples/Scripts/calculator.gd")
	
func test_When_we_create_it():
	describe("When we create it")

		# We changed it to object so no tres file
	# asserts.string_ends_with(".tres", director.resource_path, "Then we get a text resource (.tres) file back") 
	asserts.is_equal(director.base_script, "res://Examples/Scripts/calculator.gd", \
		"Then it stores filepath of the script to be doubled as a String")

func test_When_we_create_a_test_double_from_it():
	describe("When we create a Test Double from it")

	var actual: String = director.double().get_script().resource_path
	var expected: String = "%s/WATemp" % OS.get_user_data_dir()
	asserts.string_begins_with(expected, actual, \
		"Then the doubled object's script is saved in the <user data directory>/WATemp")
#
func test_When_we_create_two_of_it_for_the_same_script():
	describe("When we create two of it for the same script")

	var director_b = direct.script("res://Examples/Scripts/calculator.gd")

	asserts.is_not_equal(director.base_methods, director_b.base_methods, "Then they do not share resources")

func test_When_we_call_double_a_second_time_on():
	describe("When we call the double the second time")

	var silence_error: bool = false
	director.double()
	asserts.is_null(director.double(silence_error), "Then we get null back")

func test_When_we_double_an_inner_class():
	describe("When we double an inner class")

	var Algebra = load("res://Examples/Scripts/calculator.gd").Algebra
	var director = direct.script("res://Examples/Scripts/calculator.gd", "Algebra")

	asserts.is_class_instance(director.double(), Algebra, "Then we get that inner class back")
