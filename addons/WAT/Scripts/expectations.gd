extends Reference
class_name Expectations

### TO ADD ###
# =>
# <=
# has(value)
# !has(value)
# in range
# not in range
# in collection
# not in collection
# dict keys are equal
# dicts values are equal
# dict k/v are equal
# hash is equal
# Others for doubles (call, call count, called by signal, object emitted signal, called with parameters, signal w parameters)


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

signal OUTPUT

func output(success: bool, expected: String, result: String = "", notes = "") -> void:
	expected = "Expect:    %s" % expected
	emit_signal("OUTPUT", success, expected, result, notes)

func is_true(condition: bool, expected: String) -> void:
	# We'll expand on these later but this should be fine now
	output(condition, expected)

func is_equal(a, b, expected: String) -> void:
	# May need to add a typeof check here
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

func _stringify(variable) -> String:
	return "| %s | %s |" % [BuiltIn.to_string(variable).to_upper(), str(variable)]