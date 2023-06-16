extends WAT.Test

func add(a = 2, b = 2) -> int:
	return a + b

static func divide(a = 10, b: int = 2) -> int:
	return a / b
	
func test_keywords_and_defaults_are_automatically_doubled() -> void:
	var director = direct.script(get_script().resource_path)
	var double = director.double()
	asserts.is_equal(double.divide(), 5, "Keywords & Defaults arguments doubled automatically")
	director = null
	
func test_stubbing_defaults() -> void:
	var director = direct.script(get_script().resource_path)
	director.method("add").stub(100, [0, 2])
	var double = director.double()
	asserts.is_equal(double.add(0, 2), 100, "Keywords & Defaults arguments doubled automatically")
	director = null
	
func test_stubbing_defaults_with_partials() -> void:
	var director = direct.script(get_script().resource_path)
	director.method("add").stub(1000, [2, 2])
	var double = director.double()
	asserts.is_equal(double.add(), 1000, "Keywords & Defaults arguments doubled automatically")
	director = null
	
