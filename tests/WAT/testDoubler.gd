extends WATTest

# Move this into /WAT/Unit
# 0) We get a tres file
# 1) We get two different tres files back if we're doubling 2 scripts
# 2) We can invoke methods via instance
# 3) Invoke dummy methods via instance

const Doubler = preload("res://doubler.gd")

func double(path):
	var doubler = Doubler.new()
	var index = FILESYSTEM.file_list("user://WATemp").size()
	var savepath: String = "user://WATemp/R%s.tres" % index as String
	doubler.base_script = path
	doubler.index = index
	ResourceSaver.save(savepath, doubler)
	return load(savepath)

func test_when_doubling_a_script_we_get_a_text_resource_file_back():
	describe("double(arg) returns a text resource (.tres) file")

	clear_temp()
	var doubler = double("res://Examples/Scripts/calculator.gd")
	expect.is_not_null(doubler, "We got something back")
	expect.is_equal(doubler.resource_path, "user://WATemp/R0.tres", "Which was saved in user://WATemp")

func test_when_doubling_a_script_the_doubler_saves_the_base_script():
	describe("When doubling a script, the doubler saves the base scripts path")

	clear_temp()
	var doubler = double("res://Examples/Scripts/calculator.gd")
	expect.is_not_null(doubler.base_script, "A string was saved")
	expect.is_equal(doubler.base_script, "res://Examples/Scripts/calculator.gd", "Saved string is equal to base scripts path")

func test_when_doubling_two_scripts_they_do_not_share_resources():
	describe("When doubling two scripts, they do not share the same resources")

	clear_temp()
	var doubler1 = double("res://Examples/Scripts/calculator.gd")
	var doubler2 = double("res://Examples/Scripts/calculator.gd")
	# This expect came out null?
	expect.is_equal(doubler1.base_script, doubler2.base_script, "Doubler 1 & 2 have the same base script")
	doubler2.base_script = "Whatever.gd"
	expect.is_equal(doubler1.base_script, "res://Examples/Scripts/calculator.gd", "Doubler 1 base script did not change")
	expect.is_not_equal(doubler2.base_script, "res://Examples/Scripts/calculator.gd", "Doubler 2 base script did change")
	expect.is_not_equal(doubler1.base_script, doubler2.base_script, "Doubler 2 Base Path changed while Doubler 1 did not")

func test_when_doubling_a_script_it_can_access_its_top_level_methods():
	describe("When doubling a script, it can access its top level methods")

	clear_temp()
	var doubler = double("res://Examples/Scripts/calculator.gd")
	expect.is_true(doubler.has_method("object"), "Doubler has method 'object'")

func test_when_doubling_a_script_we_can_invoke_the_base_script_method():
	describe("When doubling a script, we can invoke the base methods of the script")

	clear_temp()
	var doubler = double("res://Examples/Scripts/calculator.gd")
	expect.is_true(doubler.has_method("object"), "Doubler has method 'object'")
	var calculator = doubler.object()
	var expected = 4
	var actual = calculator.add(2, 2)
	expect.is_equal(expected, actual, "successfully invoked add from extended calculator")

func test_when_creating_a_doubled_object_we_receive_the_doubled_script():
	describe("When we invoke object() on doubler, we receive an object whose script is saved in user://WATemp")
	clear_temp()

	var doubler = double("res://Examples/Scripts/calculator.gd")
	var object = doubler.object()
	var expected = "user://WATemp/S10.gd" # 1 for the doubler in temp, 0 for the first unique counter
	var actual = object.get_script().resource_path
	expect.is_equal(expected, actual, "script path of doubled object from doubler.object() is stored in user://WATemp")

func test_when_invoking_a_dummy_method_in_a_double_we_get_null():
	describe("When we dummy a method in a double we receive null")

	clear_temp()
	var doubler = double("res://Examples/Scripts/calculator.gd")
	var expected = 4
	var actual = doubler.object().add(2, 2)
	expect.is_equal(expected, actual, "We get 4 when we invoke add(2, 2) before dummying it")
	doubler.dummy("add")
	var obj = doubler.object()
	var expect_again = null
	# Are we eliminating changes when adding them to source?
#	var actual_again = doubler.object().add(2, 2)
	var actual_again = obj.add(2, 2) as String
	expect.is_equal('Hello World', actual_again, "dummied add returned Hello World")

	# This is a failing test because we have actually stubbed it, not dummied it
	# I'll be confident in keep this here once we implement a partner stub method
	expect.is_equal(expect_again, actual_again, "Dummied add returned null")

func test_when_calling_object_consecutively_there_still_only_exists_two_scripts_in_temp():
	describe("When we instanced a doubled script, the new doubled script replaces the old one")

	clear_temp()
	var doubler = double("res://Examples/Scripts/calculator.gd")
	var obj = doubler.object()
	var obj2 = doubler.object()

	var expected = 2
	var actual = FILESYSTEM.file_list("user://WATemp").size()
	expect.is_equal(expected, actual, "Only two files exist in user://WATemp (the doubler and doubled script)")

func test_when_instancing_two_copies_from_one_doubler_they_have_different_RIDs():
	describe("When we instance a double twice from the same doubler, each instance has a unique RID")

	clear_temp()
	var doubler = double("res://Examples/Scripts/calculator.gd")
	var obj1 = doubler.object()
	var obj2 = doubler.object()
	# Need to fix EXPECT on this.
	expect.is_not_equal(obj1.get_instance_id(), obj2.get_instance_id(), "instance ids are unique")










