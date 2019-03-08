extends Reference
class_name Expectations

signal OUTPUT

func output(success: bool, message: String, expected: String, got: String):
	emit_signal("OUTPUT", success, message, expected, got)
	
func is_true(condition: bool, message: String):
	# We'll expand on these later but this should be fine now
	var result: bool = condition
	var expected: String = str(true)
	var got: String = str(result)
	output(result, message, expected, got)