const EXPECT = preload("res://addons/WAT/constants/expectation_list.gd")
signal OUTPUT

func output(data) -> void:
	data.expected = "Expect:    %s" % data.expected
	emit_signal("OUTPUT", data)

func is_true(condition: bool, expected: String) -> void:
	output(EXPECT.IS_TRUE.new(condition, expected))

func is_false(condition: bool, expected: String) -> void:
	output(EXPECT.IS_FALSE.new(condition, expected))

func is_equal(a, b, expected: String) -> void:
	output(EXPECT.IS_EQUAL.new(a, b, expected))

func is_not_equal(a, b, expected: String) -> void:
	output(EXPECT.IS_NOT_EQUAL.new(a, b, expected))

func is_greater_than(a, b, expected: String) -> void:
	output(EXPECT.IS_GREATER_THAN.new(a, b, expected))

func is_less_than(a, b, expected: String) -> void:
	output(EXPECT.IS_LESS_THAN.new(a, b, expected))

func is_equal_or_greater_than(a, b, expected: String) -> void:
	output(EXPECT.IS_EQUAL_OR_GREATER_THAN.new(a, b, expected))

func is_equal_or_less_than(a, b, expected: String) -> void:
	output(EXPECT.IS_EQUAL_OR_LESS_THAN.new(a, b, expected))

func is_in_range(value, low, high, expected: String) -> void:
	output(EXPECT.IS_IN_RANGE.new(value, low, high, expected))

func is_not_in_range(value, low, high, expected: String) -> void:
	output(EXPECT.IS_NOT_IN_RANGE.new(value, low, high, expected))

func has(value, container, expected: String) -> void:
	output(EXPECT.HAS.new(value, container, expected))

func does_not_have(value, container, expected: String) -> void:
	output(EXPECT.DOES_NOT_HAVE.new(value, container, expected))

func is_class_instance(instance, type, expected: String) -> void:
	output(EXPECT.IS_CLASS_INSTANCE.new(instance, type, expected))

func is_not_class_instance(instance, type, expected: String) -> void:
	output(EXPECT.IS_NOT_CLASS_INSTANCE.new(instance, type, expected))

func is_built_in_type(value, type, expected: String) -> void:
	output(EXPECT.IS_BUILT_IN_TYPE.new(value, type, expected))

func is_not_built_in_type(value, type: int, expected: String) -> void:
	output(EXPECT.IS_NOT_BUILT_IN_TYPE.new(value, type, expected))

func is_null(value, expected: String) -> void:
	output(EXPECT.IS_NULL.new(value, expected))

func is_not_null(value, expected: String) -> void:
	output(EXPECT.IS_NOT_NULL.new(value, expected))

func string_contains(value, string: String, expected: String) -> void:
	output(EXPECT.STRING_CONTAINS.new(value, string, expected))

func string_does_not_contain(value, string: String, expected: String) -> void:
	output(EXPECT.STRING_DOES_NOT_CONTAIN.new(value, string, expected))

func string_begins_with(value, string: String, expected: String) -> void:
	output(EXPECT.STRING_BEGINS_WITH.new(value, string, expected))

func string_does_not_begin_with(value, string: String, expected: String) -> void:
	output(EXPECT.STRING_DOES_NOT_BEGIN_WITH.new(value, string, expected))

func string_ends_with(value, string: String, expected: String) -> void:
	output(EXPECT.STRING_ENDS_WITH.new(value, string, expected))

func string_does_not_end_with(value, string: String, expected: String) -> void:
	output(EXPECT.STRING_DOES_NOT_END_WITH.new(value, string, expected))

func was_called(double, a: String = "", b: String = "", c: String = "") -> void:
	_scene_was_called(double, a, b, c) if double.is_scene else _script_was_called(double, a, b)

func _scene_was_called(double, nodepath: String, method: String, expected: String) -> void:
	output(EXPECT.SCENE_WAS_CALLED.new(double, nodepath, method, expected))

func _script_was_called(double, method: String, expected: String) -> void:
	output(EXPECT.SCRIPT_WAS_CALLED.new(double, method, expected))

func was_not_called(double, a: String = "", b: String = "", c: String = "") -> void:\
	_scene_was_not_called(double, a, b, c) if double.is_scene else _script_was_not_called(double, a, b)
#
func _scene_was_not_called(double, nodepath: String, method: String, expected: String) -> void:
	output(EXPECT.SCENE_WAS_NOT_CALLED.new(double, nodepath, method, expected))
#
func _script_was_not_called(double, method: String, expected: String) -> void:
	output(EXPECT.SCRIPT_WAS_NOT_CALLED.new(double, method, expected))

func was_called_with_arguments(double, method: String, arguments: Dictionary, expected: String) -> void:
	output(EXPECT.CALLED_WITH_ARGUMENTS.new(double, method, arguments, expected))

func signal_was_emitted(emitter, _signal, expected: String) -> void:
	output(EXPECT.SIGNAL_WAS_EMITTED.new(emitter, _signal, expected))

func signal_was_not_emitted(emitter, _signal: String, expected: String) -> void:
	output(EXPECT.SIGNAL_WAS_NOT_EMITTED.new(emitter, _signal, expected))

func signal_was_emitted_with_arguments(emitter, _signal, arguments: Array, expected: String) -> void:
	output(EXPECT.SIGNAL_WAS_EMITTED_WITH_ARGUMENTS.new(emitter, _signal, arguments, expected))

func file_exists(path: String, expected: String) -> void:
	output(EXPECT.FILE_EXISTS.new(path, expected))

func file_does_not_exist(path: String, expected: String) -> void:
	output(EXPECT.FILE_DOES_NOT_EXIST.new(path, expected))

func is_freed(obj, expected: String) -> void:
	output(EXPECT.IS_FREED.new(obj, expected))

func is_not_freed(obj, expected: String) -> void:
	output(EXPECT.IS_NOT_FREED.new(obj, expected))