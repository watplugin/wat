extends Reference
class_name Expectations

signal OUTPUT

func output(success: bool, message: String, got: String = "") -> void:
	message = "Expect:    %s" % message
	emit_signal("OUTPUT", success, message, got)
	
func is_true(condition: bool, message: String) -> void:
	# We'll expand on these later but this should be fine now
	output(condition, message)
	
func is_equal(a, b, message: String) -> void:
	# May need to add a typeof check here
	var result: String = "%s == %s" %[_stringify(a), _stringify(b)]
	output((a == b), message, result)
	
func _stringify(variable) -> String:
	return "< %s | %s >" % [BuiltIn.to_string(variable).to_upper(), str(variable)]