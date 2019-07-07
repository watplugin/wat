extends WATTest

# Create a Double Script that extends from Source Script
# Create a Double Controller Resource Manager and save it in the same folder
# Doubles can extend from 0) Script 1) ClassName 2) InnerClass 3) Stored Variable
# Inner Classes can extend from 0) Script 1) ClassName 2) InnerClass 3) Stored Variable
# *TEST DOUBLE EXISTS*
# *TEST DOUBLE MANAGER EXISTS*
# *TEST DOUBLING FROM SCRIPT, CLASSNAME, INNER CLASS AND VARIABLE*
#
# HELPER
const CALCULATOR = "res://Examples/Scripts/calcbase.gd"
func double(path: String, inner_class: Array = []) -> Resource:
	var script: Script = load(path)
	var save_path = "user://WAtemp/S0.gd"
	var blank: Script = GDScript.new()
	blank.source_code = 'extends "%s"' % path
	for inner in inner_class:
		blank.source_code += ".%s" % inner
	ResourceSaver.save(save_path, blank)
	return load(save_path)
###

func test_doubled_script_exists() -> void:
	describe("When doubling a script, it is saved in user://WATemp/")

	clear_temp()
	var double = double(CALCULATOR)
	expect.file_exists("user://WATemp/S0.gd")

func test_doubled_script_extends_from_source_script() -> void:
	describe("When doubling a script, it creates a new script that extends from the source script")

	clear_temp()
	var double = double(CALCULATOR)
	var expected: String = 'extends "res://Examples/Scripts/calcbase.gd"'
	var actual: String = double.source_code
	expect.is_equal(expected, actual)

func test_double_exists_when_doubled_from_inner_class() -> void:
	describe("When doubling a script from an inner class, it is saved in user://WATemp/")

	clear_temp()
	var double = double(CALCULATOR, ["Algebra"])
	expect.file_exists("user://WATemp/S0.gd")

func test_double_script_extends_from_source_inner_class() -> void:
	describe("When doubling a script, it creates a new script that extends from the source script")

	clear_temp()
	var double = double(CALCULATOR, ["Algebra"])
	var expected: String = 'extends "%s".Algebra' % CALCULATOR
	var actual: String = double.source_code

	# load("path.gd".Inner) is wrong, should be load("path.gd").inner
	# Might be time to refactor to a manager class or at least a dictionary?
	var source_class = load(expected)
	expect.is_not_null(source_class, "Can load source script from double script's extension path")
	expect.is_equal(expected, actual)

func test_double_script_that_extends_from_source_inner_class_is_functional() -> void:
	describe("When doubling a script from an inner class, the doubled script should be able to invoke source class methods")

	clear_temp()
	var double = double(CALCULATOR, ["Algebra"])
	var expect_has_method: bool = double.new().has_method("scale")
	var expect_return: Vector2 = Vector2(4, 8)
	var actual_return: Vector2 = double.new().scale(Vector2(2, 4), 2)
	expect.is_true(expect_has_method, "Double instance has source method 'scale'")
	expect.is_equal(expect_return, actual_return, "Double instance has invoked source method 'scale'")













