extends WATTest

const METHOD = preload("res://addons/WAT/constants/expectation_list.gd")
#const BaseExpectation: Script = preload("res://addons/WAT/expectations/base.gd")
#const SCENE: PackedScene = preload("res://Examples/Scene/Main.tscn")
#signal a
#signal b
#var calc
#var scene
#
#func start():
#	watch(self, "a")
#	watch(self, "b")
#	emit_signal("a")
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
	expect.is_true(METHOD.FILE_EXISTS.new("res://tests/BootStrap/expectations.gd", "").success, "file_exists passes when passed: self (res://tests/BootStrap/expectations.gd")
	expect.is_true(METHOD.FILE_DOES_NOT_EXIST.new("res://tests/bad_tests.gd", "").success, "file_does_not_exists passes when passed: 'res://tests/bad_tests.gd'")

#	# Some Double Specific Things
#	expect.was_called(calc, "add", "add was called")
#	expect.was_not_called(calc, "subtract", "subtract was not called")
#	expect.was_called(scene, "C/D", "wowsers", "wowsers was called from Main/C/D")
#	expect.was_not_called(scene, "C", "blow_up_stuff", "blow_up_stuff was not called from C")
#
#	expect.signal_was_emitted(self, "a", "a was emitted")
#	expect.signal_was_not_emitted(self, "b", "b was not emitted")
#	expect.was_called_with_arguments(calc, "add", {"a": 2, "b": 2}, "add was called with 2, 2")
#
#
#
##func was_called_with_arguments(double, method: String, arguments: Dictionary, expected: String) -> void:
##	output(_CALLED_WITH_ARGUMENTS.new(double, method, arguments, expected))
#
#func test_all_should_fail():
#	expect.is_true(false, "false is true")
#	expect.is_false(true, "true is false")
#	expect.is_equal(1, 2, "1 == 2")
#	expect.is_equal(1.0, 2, "1.0 == 2")
#	expect.is_equal("Hello", "World", "'Hello' == 'World'")
#	expect.is_not_equal(1.0, 1, "1.0 != 1")
#	expect.is_not_equal('Hello World', 'Hello World', "'Hello World' != 'Hello World'")
#	expect.is_not_equal(1, 1, "1 == 1")
#	expect.is_null(1, "1 == null")
#	expect.is_not_null(null, "null != null")
#	expect.is_greater_than(1, 2.0, "1 > 2.0")
#	expect.is_greater_than("Bello", "Hello", "Bello > Hello")
#	expect.is_less_than(2.0, 1, "2.0 < 1")
#	expect.is_less_than("Hello", "Bello", "Hello < Bello")
#	expect.is_equal_or_greater_than(1, 2.0, "1 >= 2.0")
#	expect.is_equal_or_less_than(2, 1, "2 > 1")
#	expect.is_built_in_type(1, TYPE_REAL, "1 is type float")
#	expect.is_built_in_type(1.0, TYPE_INT, "1.0 is type int")
#	expect.is_not_built_in_type(1, TYPE_INT, "1 is not type int")
#	expect.is_not_built_in_type(1.0, TYPE_REAL, "1.0 is not type float")
#	expect.is_class_instance(self, BaseExpectation, "self is instance of BaseExpectation")
#	expect.is_not_class_instance(self, WATTest, "self is not instance of WATTest")
#	expect.has(4, [1, 2, 3], "[1, 2, 3] has 4")
#	expect.does_not_have(3, [1, 2, 3], "[1,2,3] does not have 3")
#	expect.is_in_range(0, 1, 10, "0 is in range 1-10")
#	expect.is_not_in_range(5, 1, 10, "5 is not in range 1-10")
#	expect.string_begins_with("World", "Hello World", "Hello World begins with World")
#	expect.string_contains("FooBar", "Hello World", "Hello World contains FooBar")
#	expect.string_ends_with("Hello", "Hello World", "Hello World ends with Hello")
#	expect.string_does_not_begin_with("Hello", "Hello World", "Hello World does not begin with Hello")
#	expect.string_does_not_contain("ello", "Hello World", "Hello World does not contain ello")
#	expect.string_does_not_end_with("World", "Hello World", "Hello World does not end with World")
#	expect.file_exists("res://tests/bad_test.gd", "This test file exists")
#	expect.file_does_not_exist("res://tests/test_things.gd", "This test file does not exist")
#
#	# Some Double Specific things
#	expect.was_called(calc, "subtract", "subtract was called")
#	expect.was_not_called(calc, "add", "add was not called")
#	expect.was_not_called(scene, "C/D", "wowsers", "wowsers was not called from Main/C/D")
#	expect.was_called(scene, "C", "blow_up_stuff", "blow_up_stuff was called from C")
#
#
#	expect.signal_was_emitted(self, "b", "b was emitted")
#	expect.signal_was_not_emitted(self, "a", "a was not emitted")
#	expect.was_called_with_arguments(calc, "add", {"a": 10, "b": 2}, "add was called with 10, 2")
#	expect.was_called_with_arguments(calc, "subtract", {"a": 2, "b": 2}, "subtract was called with 2, 2")
#
