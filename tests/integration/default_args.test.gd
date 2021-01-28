extends WAT.Test

### BEGIN ###
# Testing that we take default args into account when doubling scripts
###  END  ###

func test_default_arguments_of_interpolate_property():

	var tween_director = direct.script("Tween")
	var _interpolate_method = tween_director.method("interpolate_property")
	var _double = tween_director.double()
	asserts.is_true(true, 
	 "If this method can be reached then we have doubled a script with default argument(s) properly!")

