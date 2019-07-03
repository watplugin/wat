extends BaseLogin
class_name Login

signal LOGGED_IN

func register(username: String, password: String) -> bool:
	# Return false if passed in censored words as username
	# Returns false if some names passed in
	return true
	
func login(username: String, password: String) -> bool:
	emit_signal("LOGGED_IN", username, password)
	return true
	
func to_override() -> void:
	print("This should not appear twice")