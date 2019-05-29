extends Reference

const SCENE = preload("res://addons/WAT/double/objects/scene_data.gd")
const SCRIPT = preload("res://addons/WAT/double/objects/script_data.gd")
const BUILT_INS = preload("res://addons/WAT/constants/type_library.gd")
const OP = preload("res://addons/WAT/constants/operators.gd")
### TO ADD ###
# dict keys are equal
# dicts values are equal
# dict k/v are equal
# hash is equal
# Others for double: WATDoubles (call, call count, called by signal, object emitted signal, called with parameters, signal w parameters)

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

##### SLIGHTLY MORE COMPLICATED #####
#func was_called(double, a: String = "", b: String = "", c: String = "") -> void:
#	_scene_was_called(double, a, b, c) if double.is_scene else _script_was_called(double, a, b)
#
#func _scene_was_called(double: SCENE, nodepath: String, method: String, expected: String) -> void:
#	var success = double.call_count(nodepath, method) > 0
#	var operator = OP.BLANK if success else OP.NOT
#	var result: String = "method: %s was %s called from node: %s" % [method, operator, nodepath]
#	output(success, expected, result)
#
#func _script_was_called(double: SCRIPT, method: String, expected: String) -> void:
#	var success = double.call_count(method) > 0
#	var result: String = "method: %s was %s called" % [method, (OP.BLANK if success else OP.NOT)]
#	output(success, expected, result)
#
#func was_not_called(double, a: String = "", b: String = "", c: String = "") -> void:
#	_scene_was_not_called(double, a, b, c) if double.is_scene else _script_was_not_called(double, a, b)
#
#func _scene_was_not_called(double: SCENE, nodepath: String, method: String, expected: String) -> void:
#	var success = double.call_count(nodepath, method) == 0
#	var operator = OP.NOT if success else OP.BLANK
#	var result: String = "method: %s was %s called from node: %s" % [method, operator, nodepath]
#	output(success, expected, result)
#
#func _script_was_not_called(double: SCRIPT, method: String, expected: String) -> void:
#	var success = double.call_count(method) == 0
#	var result: String = "method %s was %s called" % [method, (OP.NOT if success else OP.BLANK)]
#	output(success, expected, result)
#
#func was_called_with_arguments(double, method: String, arguments: Dictionary, expected: String) -> void:
#	var success: bool
#	if double.call_count(method) == 0:
#		var result: String = "method was not called at all"
#		output(success, expected, result)
#		return
#	else:
#		for call in double.calls(method):
#			if key_value_match(arguments, call):
#				var result: String = "method: %s was called with arguments: %s" % [method, arguments]
#				output(true, expected, result)
#				return
#	var result: String = "method: %s was not called with arguments %s" % [method, arguments]
#	output(success, expected, result)
#
#func key_value_match(a: Dictionary, b: Dictionary) -> bool:
#	for key in a:
#		if a[key] != b[key]:
#			return false
#	return true
#
#func signal_was_emitted(_signal, expected: String) -> void:
#	var success: bool = self.get_meta("watcher").watching[_signal].emit_count > 0
#	var operator: String = OP.BLANK if success else OP.NOT
#	var result: String = "Signal: %s was %s emitted" % [_signal, operator]
#	output(success, expected, result)
#
#func signal_was_not_emitted(_signal: String, expected: String) -> void:
#	var success: bool = self.get_meta("watcher").watching[_signal].emit_count == 0
#	var operator: String = OP.NOT if success else OP.BLANK
#	var result: String = "Signal: %s was %s emitted" % [_signal, operator]
#	output(success, expected, result)
#
#func string_contains(value, string: String, expected: String) -> void:
#	var success: bool = value in string
#	var operator: String = OP.BLANK if success else OP.NOT
#	var result: String = "%s is %s in %s" % [value, operator, string]
#	output(success, expected, result)
#
#func string_does_not_contain(value, string: String, expected: String) -> void:
#	var success: bool = not value in string
#	var operator: String = OP.NOT if success else OP.BLANK
#	var result: String = "%s is %s in %s" % [value, operator, string]
#	output(success, expected, result)
#
#func string_begins_with(value, string: String, expected: String) -> void:
#	var success: bool = string.begins_with(value)
#	var operator: String = OP.BLANK if success else OP.NOT
#	var result: String = "%s does %s begins with %s" % [string, operator, value]
#	output(success, expected, result)
#
#func string_does_not_begin_with(value, string: String, expected: String) -> void:
#	var success: bool = not string.begins_with(value)
#	var operator: String = OP.NOT if success else OP.BLANK
#	var result: String = "%s does %s begins with %s" % [string, operator, value]
#	output(success, expected, result)
#
#func string_ends_with(value, string: String, expected: String) -> void:
#	var success: bool = string.ends_with(value)
#	var operator: String = OP.BLANK if success else OP.NOT
#	var result: String = "%s does %s end with %s" % [string, operator, value]
#	output(success, expected, result)
#
#func string_does_not_end_with(value, string: String, expected: String) -> void:
#	var success: bool = not string.ends_with(value)
#	var operator: String = OP.NOT if success else OP.BLANK
#	var result: String = "%s does %s ends with %s" % [string, operator, value]
#	output(success, expected, result)
#
#func _stringify(variable) -> String:
#	var type = typeof(variable)
#	return "| %s | %s |" % [BUILT_INS.to_string(type).to_upper(), str(variable)]