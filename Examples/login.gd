extends BaseLogin
class_name Login

var age = 1000

func register(username: String, password: String) -> bool:
	# Return false if passed in censored words as username
	# Returns false if some names passed in
	return true
	
func login(username: String, password: String) -> bool:
	return true
	
func to_override():
	print("This should not appear twice")