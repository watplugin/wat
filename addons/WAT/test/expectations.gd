extends Reference

signal OUTPUT
const _IS_TRUE = preload("../expectations/is_true.gd")
const _IS_FALSE = preload("../expectations/is_false.gd")
const _IS_EQUAL = preload("../expectations/is_equal.gd")
const _IS_NOT_EQUAL = preload("../expectations/is_not_equal.gd")
const _IS_EQUAL_OR_GREATER_THAN = preload("../expectations/is_equal_or_greater_than.gd")
const _IS_EQUAL_OR_LESS_THAN = preload("../expectations/is_equal_or_less_than.gd")
const _IS_GREATER_THAN = preload("../expectations/is_greater_than.gd")
const _IS_LESS_THAN = preload("../expectations/is_less_than.gd")
const _IS_IN_RANGE = preload("../expectations/is_in_range.gd")
const _IS_NOT_IN_RANGE = preload("../expectations/is_not_in_range.gd")
const _IS_CLASS_INSTANCE = preload("../expectations/is_class_instance.gd")
const _IS_NOT_CLASS_INSTANCE = preload("../expectations/is_not_class_instance.gd")
const _IS_BUILT_IN_TYPE = preload("../expectations/is_built_in_type.gd")
const _IS_NOT_BUILT_IN_TYPE = preload("../expectations/is_not_built_in_type.gd")
const _HAS = preload("../expectations/has.gd")
const _DOES_NOT_HAVE = preload("../expectations/does_not_have.gd")
const _IS_NULL = preload("../expectations/is_null.gd")
const _IS_NOT_NULL = preload("../expectations/is_not_null.gd")
const _STRING_BEGINS_WITH = preload("../expectations/string_begins_with.gd")
const _STRING_CONTAINS = preload("../expectations/string_contains.gd")
const _STRING_ENDS_WITH = preload("../expectations/string_ends_with.gd")
const _STRING_DOES_NOT_BEGIN_WITH = preload("../expectations/string_does_not_begin_with.gd")
const _STRING_DOES_NOT_END_WITH = preload("../expectations/string_does_not_end_with.gd")
const _STRING_DOES_NOT_CONTAIN = preload("../expectations/string_does_not_contain.gd")
const _SCENE_WAS_CALLED = preload("../expectations/scene_was_called.gd")
const _SCENE_WAS_NOT_CALLED = preload("../expectations/scene_was_not_called.gd")
const _SCRIPT_WAS_CALLED = preload("../expectations/script_was_called.gd")
const _SCRIPT_WAS_NOT_CALLED = preload("../expectations/script_was_not_called.gd")
const _SIGNAL_WAS_EMITTED = preload("../expectations/signal_was_emitted.gd")
const _SIGNAL_WAS_NOT_EMITTED = preload("../expectations/signal_was_not_emitted.gd")
const _CALLED_WITH_ARGUMENTS = preload("../expectations/called_with_arguments.gd")

func output(data) -> void:
	data.expected = "Expect:    %s" % data.expected
	emit_signal("OUTPUT", data)

func is_true(condition: bool, expected: String) -> void:
	output(_IS_TRUE.new(condition, expected))

func is_false(condition: bool, expected: String) -> void:
	output(_IS_FALSE.new(condition, expected))

func is_equal(a, b, expected: String) -> void:
	output(_IS_EQUAL.new(a, b, expected))

func is_not_equal(a, b, expected: String) -> void:
	output(_IS_NOT_EQUAL.new(a, b, expected))

func is_greater_than(a, b, expected: String) -> void:
	output(_IS_GREATER_THAN.new(a, b, expected))
	
func is_less_than(a, b, expected: String) -> void:
	output(_IS_LESS_THAN.new(a, b, expected))

func is_equal_or_greater_than(a, b, expected: String) -> void:
	output(_IS_EQUAL_OR_GREATER_THAN.new(a, b, expected))

func is_equal_or_less_than(a, b, expected: String) -> void:
	output(_IS_EQUAL_OR_LESS_THAN.new(a, b, expected))

func is_in_range(value, low, high, expected: String) -> void:
	output(_IS_IN_RANGE.new(value, low, high, expected))

func is_not_in_range(value, low, high, expected: String) -> void:
	output(_IS_NOT_IN_RANGE.new(value, low, high, expected))

func has(value, container, expected: String) -> void:
	output(_HAS.new(value, container, expected))
	
func does_not_have(value, container, expected: String) -> void:
	output(_DOES_NOT_HAVE.new(value, container, expected))
	
func is_class_instance(instance, type, expected: String) -> void:
	output(_IS_CLASS_INSTANCE.new(instance, type, expected)) 

func is_not_class_instance(instance, type, expected: String) -> void:
	output(_IS_NOT_CLASS_INSTANCE.new(instance, type, expected))

func is_built_in_type(value, type, expected: String) -> void:
	output(_IS_BUILT_IN_TYPE.new(value, type, expected))

func is_not_built_in_type(value, type: int, expected: String) -> void:
	output(_IS_NOT_BUILT_IN_TYPE.new(value, type, expected))

func is_null(value, expected: String) -> void:
	output(_IS_NULL.new(value, expected))
	
func is_not_null(value, expected: String) -> void:
	output(_IS_NOT_NULL.new(value, expected))
	
func string_contains(value, string: String, expected: String) -> void:
	output(_STRING_CONTAINS.new(value, string, expected))
	
func string_does_not_contain(value, string: String, expected: String) -> void:
	output(_STRING_DOES_NOT_CONTAIN.new(value, string, expected))
	
func string_begins_with(value, string: String, expected: String) -> void:
	output(_STRING_BEGINS_WITH.new(value, string, expected))
	
func string_does_not_begin_with(value, string: String, expected: String) -> void:
	output(_STRING_DOES_NOT_BEGIN_WITH.new(value, string, expected))
	
func string_ends_with(value, string: String, expected: String) -> void:
	output(_STRING_ENDS_WITH.new(value, string, expected))
	
func string_does_not_end_with(value, string: String, expected: String) -> void:
	output(_STRING_DOES_NOT_END_WITH.new(value, string, expected))

func was_called(double, a: String = "", b: String = "", c: String = "") -> void:
	_scene_was_called(double, a, b, c) if double.is_scene else _script_was_called(double, a, b)

func _scene_was_called(double, nodepath: String, method: String, expected: String) -> void:
	output(_SCENE_WAS_CALLED.new(double, nodepath, method, expected))

func _script_was_called(double, method: String, expected: String) -> void:
	output(_SCRIPT_WAS_CALLED.new(double, method, expected))

func was_not_called(double, a: String = "", b: String = "", c: String = "") -> void:
	_scene_was_not_called(double, a, b, c) if double.is_scene else _script_was_not_called(double, a, b)
#
func _scene_was_not_called(double, nodepath: String, method: String, expected: String) -> void:
	output(_SCENE_WAS_NOT_CALLED.new(double, nodepath, method, expected))
#
func _script_was_not_called(double, method: String, expected: String) -> void:
	output(_SCRIPT_WAS_NOT_CALLED.new(double, method, expected))

func was_called_with_arguments(double, method: String, arguments: Dictionary, expected: String) -> void:
	output(_CALLED_WITH_ARGUMENTS.new(double, method, arguments, expected))

func signal_was_emitted(_signal, expected: String) -> void:
	output(_SIGNAL_WAS_EMITTED.new(self.get_meta("watcher"), _signal, expected))

func signal_was_not_emitted(_signal: String, expected: String) -> void:
	output(_SIGNAL_WAS_NOT_EMITTED.new(self.get_meta("watcher"), _signal, expected))