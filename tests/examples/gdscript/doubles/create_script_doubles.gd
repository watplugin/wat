extends WAT.Test

# Developers can create a Test Double by calling .double() on a..
# ..Script Director. Developers can only call double() once..
# ..succesive calls will fail
func test_doubled_object_is_instance_of_base_class() -> void:
	var director = direct.script(MyClass)
	var double = director.double()
	asserts.is_class_instance(double, MyClass)
 
# Tests Doubles use their base implementation unless Developers instruct..
# ..them to do otherwise via Method Directors.
func test_stubbed_method_returns_stubbed_value() -> void:
	var director = direct.script(MyClass)
	var method_director = director.method("get_title")
	method_director.stub("Stubbed Return")
	var double = director.double()
	asserts.is_equal(double.get_title(), "Stubbed Return")
