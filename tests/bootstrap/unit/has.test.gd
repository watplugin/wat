extends WAT.Test

# Collections need better assertions
func test_dict_has_key() -> void:
	var d: Dictionary = {0: 10}
	
	asserts.has(0, d, "{0: 10} has key 0");
	
func test_array_has_value() -> void:
	var a: Array = [0, 1, 2]
	
	asserts.has(2, a, "[0, 1, 2] has value 2");

func test_dict_does_not_have_value() -> void:
	var d: Dictionary = {0: 10}
	
	asserts.does_not_have(5, d, "{0: 10} does not have value 5");
	
func test_dict_does_not_have_key() -> void:
	var d: Dictionary = {0: 10}
	
	asserts.does_not_have(10, d, "{1: 10} does not have has key 1");
	
func test_array_does_not_have_value() -> void:
	var a: Array = [0, 1, 2]
	
	asserts.does_not_have(4, a, "[0, 1, 2] does not have value 2");
