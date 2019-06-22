extends WATTest

const METHOD = preload("res://addons/WAT/constants/expectation_list.gd")
#const BaseExpectation: Script = preload("res://addons/WAT/expectations/base.gd")
#const SCENE: PackedScene = preload("res://Examples/Scene/Main.tscn")
#signal a
#signal b
#var calc
#var scene

#	self.calc = DOUBLE.script(Calculator)
#	self.calc.instance.add(2, 2)
#	self.scene = DOUBLE.scene(SCENE)
#	self.scene.instance.get_node("C/D").wowsers()
#
#func end():
#	calc.instance.free()
#	scene.instance.free()

func test_expectation_methods_pass_when_passed_correct_values():
	expect.is_true(METHOD.IS_TRUE.new(true, "").success, "is_true passes when bool true is passed")
	expect.is_true(METHOD.IS_FALSE.new(false, "").success, "is_false passes when bool false is passed")
	expect.is_true(METHOD.IS_EQUAL.new(1, 1, "").success, "is_equal passes when passed: int 1, int 1")
	expect.is_true(METHOD.IS_EQUAL.new("Hello World", "Hello World", "").success, "is_equal passes when passed: String 'Hello World', String 'Hello World'")
	expect.is_true(METHOD.IS_EQUAL.new(1.0, 1, "").success, "is_equal passes when passed: float 1.0, int 1")
	expect.is_true(METHOD.IS_NOT_EQUAL.new(1, 2, "").success, "is_not_equal passes when passed: int 1, int 2")
	expect.is_true(METHOD.IS_NOT_EQUAL.new(1.0, 2, "").success, "is_not_equal passes when passed: float 1, int 2")
	expect.is_true(METHOD.IS_NOT_EQUAL.new('Hello', 'World', "").success, "is_not_equal passes when passed: String 'Hello', String 'World'")
	expect.is_true(METHOD.IS_NULL.new(null, "").success, "is_null passes when passed: null")
	expect.is_true(METHOD.IS_NOT_NULL.new(1, "").success, "is_not_null passes when passed: int 1")
	expect.is_true(METHOD.IS_GREATER_THAN.new(2.0, 1, "").success, "is_greater_than passes when passed: float 2.0, int 1")
	expect.is_true(METHOD.IS_GREATER_THAN.new("Hello", "Bello", "").success, "is_greater_than passes when passed: 'Hello', 'Bello' (note: AlphaNumeric Index, Not Size)")
	expect.is_true(METHOD.IS_LESS_THAN.new(1, 2.0, "").success, "is_less_than passes when passed: int 1, float 2.0")
	expect.is_true(METHOD.IS_LESS_THAN.new('Bello', 'Hello', "").success, "is_less_than passes when passed: String 'Bello', String 'Hello'")
	expect.is_true(METHOD.IS_EQUAL_OR_GREATER_THAN.new(2.0, 2, "").success, "is_equal_or_greater_than passes when passed: float 2.0, int 2")
	expect.is_true(METHOD.IS_EQUAL_OR_GREATER_THAN.new(2.0, 1, "").success, "is_equal_or_greater_than passes when passed: float 2.0, int 1")
	expect.is_true(METHOD.IS_EQUAL_OR_LESS_THAN.new(2, 2.0, "").success, "is_equal_or_less_than passes when passed: int 2, float 2.0")
	expect.is_true(METHOD.IS_EQUAL_OR_LESS_THAN.new(1, 2.0, "").success, "is_equal_or_less_than passes when passed: int 1, float 2.0")
	expect.is_true(METHOD.IS_BUILT_IN_TYPE.new(1, TYPE_INT, "").success, "is_built_in_type passes when passed: int 1, TYPE_INT")
	expect.is_true(METHOD.IS_BUILT_IN_TYPE.new(1.0, TYPE_REAL, "").success, "is_built_in_type passes when passed: float 1.0, TYPE_REAL")
	expect.is_true(METHOD.IS_NOT_BUILT_IN_TYPE.new(1, TYPE_REAL, "").success, "is_not_built_in_type passes when passed: int 1, TYPE_REAL")
	expect.is_true(METHOD.IS_NOT_BUILT_IN_TYPE.new(1.0, TYPE_INT, "").success, "is_not_built_in_type passes when passed: float 1.0, TYPE_INT")
	expect.is_true(METHOD.IS_CLASS_INSTANCE.new(self, WATTest, "").success, "is_class_instance passes when passed: WATTest self, Script WATTest")
	expect.is_true(METHOD.IS_NOT_CLASS_INSTANCE.new(self, METHOD, "").success, "is_not_class_instances passes when passed: WATTest self, const Script METHOD")
	expect.is_true(METHOD.HAS.new(3, [1, 2, 3], "").success, "has passes when passed: int 3, Array [1, 2, 3]")
	expect.is_true(METHOD.DOES_NOT_HAVE.new(4, [1, 2, 3], "").success, "does_not_have passes when passed: int 4, Array [1, 2, 3]")
	expect.is_true(METHOD.IS_IN_RANGE.new(5, 1, 10, "").success, "is_in_range passes when passed: int 5, low int 1, high int 10")
	expect.is_true(METHOD.IS_NOT_IN_RANGE.new(0, 1, 10, "").success, "is_not_in_range passes when passed: int 0, low int 1, high int 10")
	expect.is_true(METHOD.STRING_BEGINS_WITH.new("Hell", "Hello World", "").success, "string_begins_with passes when passed: String 'Hell', String 'Hello World'")
	expect.is_true(METHOD.STRING_CONTAINS.new("ello", "Hello World", "").success, "string_contains passes when passed: String 'ello', Stirng 'Hello World'")
	expect.is_true(METHOD.STRING_ENDS_WITH.new("World", "Hello World", "").success, "string_ends_with passes when passed: String 'World', String 'Hello World'")
	expect.is_true(METHOD.STRING_DOES_NOT_BEGIN_WITH.new("World", "Hello World", "").success, "string_does_not_begin_with_passes when passed: String 'World', String 'Hello World'")
	expect.is_true(METHOD.STRING_DOES_NOT_CONTAIN.new("FooBar", "Hello World", "").success, "string_does_not_contain passes when passed: String 'FooBar', String 'Hello World'")
	expect.is_true(METHOD.STRING_DOES_NOT_END_WITH.new("Hello", "Hello World", "").success, "string_does_not_end_with passes when passed: String 'Hello', String 'Hello World'")
	expect.is_true(METHOD.FILE_EXISTS.new("res://tests/BootStrap/test_expectations.gd", "").success, "file_exists passes when passed: self (res://tests/BootStrap/test_expectations.gd")
	expect.is_true(METHOD.FILE_DOES_NOT_EXIST.new("res://tests/bad_tests.gd", "").success, "file_does_not_exists passes when passed: 'res://tests/bad_tests.gd'")
	var obj = Node.new()
	expect.is_true(METHOD.IS_NOT_FREED.new(obj, "").success, "is_not_freed passes when passed: Node in memory")
	obj.free()
	expect.is_true(METHOD.IS_FREED.new(obj, "").success, "is_freed passes when passed: Node deleted from memory")
#	# Some Double Specific Things
#	expect.was_called(calc, "add", "add was called")
#	expect.was_not_called(calc, "subtract", "subtract was not called")
#	expect.was_called(scene, "C/D", "wowsers", "wowsers was called from Main/C/D")
#	expect.was_not_called(scene, "C", "blow_up_stuff", "blow_up_stuff was not called from C")
#

#	expect.was_called_with_arguments(calc, "add", {"a": 2, "b": 2}, "add was called with 2, 2")
#
#
#
##func was_called_with_arguments(double, method: String, arguments: Dictionary, expected: String) -> void:
##	output(_CALLED_WITH_ARGUMENTS.new(double, method, arguments, expected))

#func test_expectation_methods_pass_when_passed_correct_values():
#	expect.is_true(METHOD.IS_TRUE.new(true, "").success, "is_true passes when bool true is passed")
#	expect.is_true(METHOD.IS_FALSE.new(false, "").success, "is_false passes when bool false is passed")
#	expect.is_true(METHOD.IS_EQUAL.new(1, 1, "").success, "is_equal passes when passed: int 1, int 1")
#
#func test_all_should_fail():
func test_expectation_methods_fail_when_passed_incorrect_values():
	expect.is_false(METHOD.IS_TRUE.new(false, "").success, "is_true fails when passed: false")
	expect.is_false(METHOD.IS_FALSE.new(true, "").success, "is_false fails when passed: true")
	expect.is_false(METHOD.IS_EQUAL.new(1, 2, "").success, "is_equal fails when passed: int 1, int 2")
	expect.is_false(METHOD.IS_EQUAL.new(1.0, 2, "").success, "is_equal fails when passed: float 1.0, int 2")
	expect.is_false(METHOD.IS_NOT_EQUAL.new(1.0, 1, "").success, "is_not_equal fails when passed: float 1.0, int 1")
	expect.is_false(METHOD.IS_NOT_EQUAL.new("Hello World", "Hello World", "").success, "is_not_equal fails when passed: String 'Hello World', String 'Hello World'")
	expect.is_false(METHOD.IS_NOT_EQUAL.new(1, 1, "").success, "is_not_equal fails when passed: int 1, int 1")
	expect.is_false(METHOD.IS_NULL.new(1, "").success, "is_null fails when passed: int 1")
	expect.is_false(METHOD.IS_NOT_NULL.new(null, "").success, "is_not_null fails when passed: null")
	expect.is_false(METHOD.IS_GREATER_THAN.new(1, 2.0, "").success, "is_greater_than_fails when passed: int 1, float 2.0")
	expect.is_false(METHOD.IS_GREATER_THAN.new("Bello", "Hello", "").success, "is_greater_than fails when passed: String 'Bello', String 'Hello'")
	expect.is_false(METHOD.IS_LESS_THAN.new(2.0, 1, "").success, "is_less_than fails when passed: float 2.0, int 1")
	expect.is_false(METHOD.IS_LESS_THAN.new("Hello", "Bello", "").success, "is_less_than fails when passed: String 'Hello', String 'Bello'")
	expect.is_false(METHOD.IS_EQUAL_OR_GREATER_THAN.new(1, 2.0, "").success, "is_equal_or_greater_than fails when passed: int 1, float 2.0")
	expect.is_false(METHOD.IS_EQUAL_OR_LESS_THAN.new(2, 1, "").success, "is_equal_or_less_than_fails when passed: int 2, int 1")
	expect.is_false(METHOD.IS_BUILT_IN_TYPE.new(1, TYPE_REAL, "").success, "is_built_in_type fails when passed: int 1, TYPE_REAL")
	expect.is_false(METHOD.IS_BUILT_IN_TYPE.new(1.0, TYPE_INT, "").success, "is_built_in_type fails when passed: float 1.0, TYPE_INT")
	expect.is_false(METHOD.IS_NOT_BUILT_IN_TYPE.new(1, TYPE_INT, "").success, "is_not_built_in_type fails when passed: int 1, TYPE_INT")
	expect.is_false(METHOD.IS_NOT_BUILT_IN_TYPE.new(1.0, TYPE_REAL, "").success, "is_not_built_in_type fails when passed: float 1.0, TYPE_REAL")
	expect.is_false(METHOD.IS_CLASS_INSTANCE.new(self, METHOD, "").success, "is_class_instance fails when passed: WATTest self, const Script METHOD")
	expect.is_false(METHOD.IS_NOT_CLASS_INSTANCE.new(self, WATTest, "").success, "is_not_class_instance fails when passed: WATTest self, Script WATTest")
	expect.is_false(METHOD.HAS.new(4, [1, 2, 3], "").success, "has fails when passed: int 4, Array [1, 2, 3]")
	expect.is_false(METHOD.DOES_NOT_HAVE.new(3, [1, 2, 3], "").success, "does_not_have fails when passed: int 3, Array [1, 2, 3]")
	expect.is_false(METHOD.IS_IN_RANGE.new(0, 1, 10, "").success, "is_in_range fails when passed: int 0, int low 1, int high 10")
	expect.is_false(METHOD.IS_NOT_IN_RANGE.new(5, 1, 10, "").success, "is_not_in_range fails when passed: int 5, int low 1, int high 10")
	expect.is_false(METHOD.STRING_BEGINS_WITH.new("World", "Hello World", "").success, "string_begins_with fails when passed: String 'World', String 'Hello World'")
	expect.is_false(METHOD.STRING_CONTAINS.new("FoorBar", "Hello World", "").success, "string_contains fails when passed: String 'FooBar', String 'Hello World'")
	expect.is_false(METHOD.STRING_ENDS_WITH.new("Hello", "Hello World", "").success, "string_ends_with fails when passed: String 'Hello', String 'Hello World'")
	expect.is_false(METHOD.STRING_DOES_NOT_BEGIN_WITH.new("Hello", "Hello World", "").success, "string_does_not_begin_with fails when passed: String 'Hello', String 'Hello World'")
	expect.is_false(METHOD.STRING_DOES_NOT_CONTAIN.new("ello", "Hello World", "").success, "string_does_not_contain fails when passed: String 'ello', String 'Hello World'")
	expect.is_false(METHOD.STRING_DOES_NOT_END_WITH.new("World", "Hello World", "").success, "string_does_not_end_with fails when passed: String 'World', String 'Hello World'")
	expect.is_false(METHOD.FILE_EXISTS.new("res://tests/bad_tests.gd", "").success, "file_exists fails when passed: 'res://tests/bad_tests.gd'")
	expect.is_false(METHOD.FILE_DOES_NOT_EXIST.new("res://tests/BootStrap/test_expectations.gd", "").success, "file_does_not_exist fails when passed: 'res://tests/BootStrap/test_expectations.gd'")

	var obj = Node.new()
	expect.is_false(METHOD.IS_FREED.new(obj, "").success, "is_freed fails when passed: Node in memory")
	obj.free()
	expect.is_false(METHOD.IS_NOT_FREED.new(obj, "").success, "is_not_freed fails when passed: Node deleted from memory")

#	# Some Double Specific things
#	expect.was_called(calc, "subtract", "subtract was called")
#	expect.was_not_called(calc, "add", "add was not called")
#	expect.was_not_called(scene, "C/D", "wowsers", "wowsers was not called from Main/C/D")
#	expect.was_called(scene, "C", "blow_up_stuff", "blow_up_stuff was called from C")
#
#

#	expect.was_called_with_arguments(calc, "add", {"a": 10, "b": 2}, "add was called with 10, 2")
#	expect.was_called_with_arguments(calc, "subtract", {"a": 2, "b": 2}, "subtract was called with 2, 2")
#
