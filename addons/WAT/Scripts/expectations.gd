extends Reference
class_name Expectations

class OP:
	const EQUAL = "=="
	const INEQUAL = "!="
	const GREATER = ">"
	const LESSER = "<"
	const GREATER_THAN_OR_EQUAL = "=>"
	const LESS_THAN_OR_EQUAL = "<="
	const IS = "is"

signal OUTPUT

func output(success: bool, message: String, got: String = "", notes = "") -> void:
	message = "Expect:    %s" % message
	emit_signal("OUTPUT", success, message, got, notes)
	
func is_true(condition: bool, message: String) -> void:
	# We'll expand on these later but this should be fine now
	output(condition, message)
	
func is_equal(a, b, message: String) -> void:
	# May need to add a typeof check here
	var success: bool = (a == b)
	var operator: String = OP.EQUAL if success else OP.INEQUAL
	var result: String = "%s %s %s" %[_stringify(a), operator, _stringify(b)]
	output(success, message, result)
	
func is_not_equal(a, b, message: String) -> void:
	var success: bool = (a != b)
	var operator: String = OP.INEQUAL if success else OP.EQUAL
	var result: String = "%s %s %s" % [_stringify(a), operator, _stringify(b)]
	output((a != b), message, result)
	
func is_greater_than(a, b, message: String) -> void:
	var success: bool
	if a is Dictionary or a is Array:
		success = a.size() > b.size()
	else:
		success = a > b
	var operator: String = OP.GREATER if success else OP.LESS_THAN_OR_EQUAL
	var result: String = "%s %s %s" %[_stringify(a), operator, _stringify(b)]
	output(success, message, result)
	
func _stringify(variable) -> String:
	return "< %s | %s >" % [BuiltIn.to_string(variable).to_upper(), str(variable)]