extends Reference
class_name WATExpectations

const SCENE = preload("res://addons/WAT/double/scene_data.gd")
const SCRIPT = preload("res://addons/WAT/double/script_data.gd")
### TO ADD ###
# dict keys are equal
# dicts values are equal
# dict k/v are equal
# hash is equal
# Others for double: WATDoubles (call, call count, called by signal, object emitted signal, called with parameters, signal w parameters)


class OP:
	const EQUAL = "=="
	const INEQUAL = "!="
	const GREATER = ">"
	const LESSER = "<"
	const GREATER_THAN_OR_EQUAL = "=>"
	const LESS_THAN_OR_EQUAL = "<="
	const IS = "is"
	const IN = "in"
	const NOT = "not "
	const EXCLAIMATION = "!"
	const IS_NOT = "is not"
	const BLANK = ""

signal OUTPUT

func output(success: bool, expected: String, result: String = "", notes = "") -> void:
	expected = "Expect:    %s" % expected
	emit_signal("OUTPUT", success, expected, result, notes)

func is_true(condition: bool, expected: String) -> void:
	output(condition, expected, "is false")
	
func is_false(condition: bool, expected: String) -> void:
	output(not condition, expected, "is true")

func is_equal(a, b, expected: String) -> void:
	var success: bool = (a == b)
	var operator: String = OP.EQUAL if success else OP.INEQUAL
	var result: String = "%s    %s    %s" %[_stringify(a), operator, _stringify(b)]
	output(success, expected, result)

func is_not_equal(a, b, expected: String) -> void:
	var success: bool = (a != b)
	var operator: String = OP.INEQUAL if success else OP.EQUAL
	var result: String = "%s    %s    %s" % [_stringify(a), operator, _stringify(b)]
	output((a != b), expected, result)

func is_greater_than(a, b, expected: String) -> void:
	var success: bool
	if a is Dictionary or a is Array:
		success = a.size() > b.size()
	elif a is String:
		success = a.length() > b.length()
	else:
		success = a > b
	var operator: String = OP.GREATER if success else OP.LESS_THAN_OR_EQUAL
	var result: String = "%s    %s    %s" % [_stringify(a), operator, _stringify(b)]
	output(success, expected, result)

func is_less_than(a, b, expected: String) -> void:
	var success: bool
	if a is Dictionary or a is Array:
		success = a.size() < b.size()
	elif a is String:
		success = a.length() < b.length()
	else:
		success = a < b
	var operator: String = OP.LESSER if success else OP.GREATER_THAN_OR_EQUAL
	var result: String = "%s    %s    %s" % [_stringify(a), operator, _stringify(b)]
	output(success, expected, result)
	
func is_equal_or_greater_than(a, b, expected: String) -> void:
	var success: bool
	if a is Dictionary or a is Array:
		success = a.size() >= b.size()
	elif a is String:
		success = a.length() >= b.length()
	else:
		success = a >= b
	var operator: String = OP.GREATER_THAN_OR_EQUAL if success else OP.LESSER
	var result: String = "%s    %s    %s" % [_stringify(a), operator, _stringify(b)]
	output(success, expected, result)
	
func is_equal_or_less_than(a, b, expected: String) -> void:
	var success: bool
	if a is Dictionary or a is Array:
		success = a.size() <= b.size()
	elif a is String:
		success = a.length() <= b.length()
	else:
		success = a <= b
	var operator: String = OP.LESSER_THAN_OR_EQUAL if success else OP.GREATER
	var result: String = "%s    %s    %s" % [_stringify(a), operator, _stringify(b)]
	output(success, expected, result)
	
func is_in_range(value, low, high, expected: String) -> void:
	var success: bool = (value > low and value < high)
	var operator: String = OP.BLANK if success else OP.NOT
	var result: String = "%s is %s in range(%s, %s)" % [value, operator, low, high]
	output(success, expected, result)
	
func is_not_in_range(value, low, high, expected: String) -> void:
	var success: bool = (value < low or value > high)
	var operator: String = OP.NOT if success else OP.BLANK
	var result: String = "%s is %s in range(%s, %s)" % [value, operator, low, high]
	output(success, expected, result)
	
func has(value, container, expected: String) -> void:
	var success: bool = container.has(value)
	var operator: String = OP.IN if success else OP.NOT_IN
	var result: String = "%s is %s %s" % [value, operator, container]
	output(success, expected, result)
	
func does_not_have(value, container, expected: String) -> void:
	var success: bool = not container.has(value)
	var operator: String = OP.NOT_IN if success else OP.IN
	var result: String = "%s %s %s" % [value, operator, container]
	output(success, expected, result)
	
func is_type(instance, type, expected: String) -> void:
	var success: bool = instance is type
	var operator: String = OP.BLANK if success else OP.NOT
	var result: String = "%s is %s instance of %s" % [instance, operator, type]
	output(success, expected, result)
	
func is_not_type(instance, type, expected: String) -> void:
	var success: bool = not instance is type
	var operator: String = OP.NOT if success else ""
	var result: String = "%s is %s instance of %s" % [instance, operator, type]
	
func is_null(value, expected: String) -> void:
	var success: bool = value == null
	var operator: String = OP.IS if success else OP.IS_NOT
	var result: String = "%s %s null" % [value, operator]
	output(success, expected, result)
	
func is_not_null(value, expected: String) -> void:
	var success: bool = value != null
	var operator: String = OP.IS_NOT if success else OP.IS
	var result: String = "%s %s null" % [value, operator]
	output(success, expected, result)
	
func was_called(double, a: String = "", b: String = "", c: String = "") -> void:
	_scene_was_called(double, a, b, c) if double.is_scene else _script_was_called(double, a, b)
	
func _scene_was_called(double: SCENE, nodepath: String, method: String, expected: String) -> void:
	var success = double.call_count(nodepath, method) > 0
	var operator = OP.BLANK if success else OP.NOT
	var result: String = "method: %s was %s called from node: %s" % [method, operator, nodepath]
	output(success, expected, result)
	
func _script_was_called(double: SCRIPT, method: String, expected: String) -> void:
	var success = double.call_count(method) > 0
	var result: String = "method: %s was %s called" % [method, (OP.BLANK if success else OP.NOT)]
	output(success, expected, result)
	
func was_not_called(double, a: String = "", b: String = "", c: String = "") -> void:
	_scene_was_not_called(double, a, b, c) if double.is_scene else _script_was_not_called(double, a, b)
	
func _scene_was_not_called(double: SCENE, nodepath: String, method: String, expected: String) -> void:
	var success = double.call_count(nodepath, method) == 0
	var operator = OP.NOT if success else OP.BLANK
	var result: String = "method: %s was %s called from node: %s" % [method, operator, nodepath]
	output(success, expected, result)
	
func _script_was_not_called(double: SCRIPT, method: String, expected: String) -> void:
	var success = double.call_count(method) == 0
	var result: String = "method %s was %s called" % [method, (OP.NOT if success else OP.BLANK)]
	output(success, expected, result)

func was_called_with_arguments(double, method: String, arguments: Dictionary, expected: String) -> void:
	var success: bool
	if double.call_count(method) == 0:
		var result: String = "method was not called at all"
		output(success, expected, result)
		return
	else:
		for call in double.calls(method):
			if key_value_match(arguments, call):
				var result: String = "method: %s was called with arguments: %s" % [method, arguments]
				output(true, expected, result)
				return
	var result: String = "method: %s was not called with arguments %s" % [method, arguments]
	output(success, expected, result)
	
func key_value_match(a: Dictionary, b: Dictionary) -> bool:
	for key in a:
		if a[key] != b[key]:
			return false
	return true

func signal_was_emitted(_signal, expected: String) -> void:
	var success: bool = self.get_meta("watcher").watching[_signal].emit_count > 0
	var operator: String = OP.BLANK if success else OP.NOT
	var result: String = "Signal: %s was %s emitted" % [_signal, operator]
	output(success, expected, result)
	
func signal_was_not_emitted(_signal: String, expected: String) -> void:
	var success: bool = self.get_meta("watcher").watching[_signal].emit_count == 0
	var operator: String = OP.NOT if success else OP.BLANK
	var result: String = "Signal: %s was %s emitted" % [_signal, operator]
	output(success, expected, result)

func string_contains(value, string: String, expected: String) -> void:
	var success: bool = value in string
	var operator: String = OP.BLANK if success else OP.NOT
	var result: String = "%s is %s in %s" % [value, operator, string]
	output(success, expected, result)
	
func string_does_not_contain(value, string: String, expected: String) -> void:
	var success: bool = not value in string
	var operator: String = OP.NOT if success else OP.BLANK
	var result: String = "%s is %s in %s" % [value, operator, string]
	output(success, expected, result)
	
func string_begins_with(value, string: String, expected: String) -> void:
	var success: bool = string.begins_with(value)
	var operator: String = OP.BLANK if success else OP.NOT
	var result: String = "%s does %s begins with %s" % [string, operator, value]
	output(success, expected, result)
	
func string_does_not_begin_with(value, string: String, expected: String) -> void:
	var success: bool = not string.begins_with(value)
	var operator: String = OP.NOT if success else OP.BLANK
	var result: String = "%s does %s begins with %s" % [string, operator, value]
	output(success, expected, result)
	
func string_ends_with(value, string: String, expected: String) -> void:
	var success: bool = string.ends_with(value)
	var operator: String = OP.BLANK if success else OP.NOT
	var result: String = "%s does %s end with %s" % [string, operator, value]
	output(success, expected, result)
	
func string_does_not_end_with(value, string: String, expected: String) -> void:
	var success: bool = not string.ends_with(value)
	var operator: String = OP.NOT if success else OP.BLANK
	var result: String = "%s does %s ends with %s" % [string, operator, value]
	output(success, expected, result)

func _stringify(variable) -> String:
	return "| %s | %s |" % [WATBuiltins.to_string(variable).to_upper(), str(variable)]