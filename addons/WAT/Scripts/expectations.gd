extends Reference
class_name Expectations

signal OUTPUT

func output(success: bool, message: String):
	emit_signal("OUTPUT", success, message)
	
func is_true(condition: bool, message: String):
	# We'll expand on these later but this should be fine now
	output(condition, message)