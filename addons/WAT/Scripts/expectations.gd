extends Reference
class_name Expectations

signal OUTPUT

func output(success: bool, message: String) -> void:
	emit_signal("OUTPUT", success, message)
	
func is_true(condition: bool, message: String) -> void:
	# We'll expand on these later but this should be fine now
	output(condition, message)
	
func is_equal(a, b, message: String) -> void:
	# May need to add a typeof check here
	output((a == b), message)