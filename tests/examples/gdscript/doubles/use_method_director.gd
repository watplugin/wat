extends WAT.Test

# Developers can create a Method Director to instruct.. 
# ..how a particular method of a test double should act. 
# If a Method Director is not created for a method..
# ..it retains the default implementation. If a Method
# If a Method Director is created but not manipulated.., 
# ..it returns null by default.
func test_doubled_methods_return_null_by_default() -> void:
	var director = direct.script(MyCalculator)
	var _method = director.method("get_approx_pi")
	var double = director.double()
	asserts.is_null(double.get_approx_pi())
	
# Developers can instruct a method to return a different value..
# ..when called by using the .stub(return_value) method below.
func test_stub_methods_with_return_value() -> void:
	var director = direct.script(MyCalculator)
	var get_approx_pi = director.method("get_approx_pi")
	get_approx_pi.stub(100)
	var double = director.double()
	asserts.is_equal(double.get_approx_pi(), 100)
	
# Developers can instruct a method to return different values based on 
# which arguments are passed otherwise the method returns its default value.
func test_stub_methods_with_return_value_based_on_param_values() -> void:
	var director = direct.script(MyCalculator)
	var add = director.method("add")
	add.stub(1, [2, 2])
	var double = director.double()
	asserts.is_equal(double.add(2, 2), 1)

# Developers can instruct a method to return different values based on..
# ..which arguments are passed otherwise the method returns its default..
# ..value but in this example any() is being used to say "this argument can..
# ..match any value" whereas the second argument must match 0 
func test_stub_methods_with_return_value_based_on_partial_param_values() -> void:
	var director = direct.script(MyCalculator)
	var add = director.method("divide")
	add.stub(1, [any(), 0])
	var double = director.double()
	asserts.is_equal(double.divide(52, 0), 1)
	
# Developers can use asserts.was_called(director, method_name)..
# ..to check if a method was called on a test double.
func test_doubled_methods_was_called() -> void:
	var director = direct.script(MyCalculator)
	var _get_approx_pi = director.method("get_approx_pi")
	var double = director.double()
	double.get_approx_pi()
	asserts.was_called(director, "get_approx_pi")
	
# Developers can use asserts.was_not_called(director, method_name)..
# ..to check if a method was not called on a test doubled.
func test_doubled_method_was_not_called() -> void:
	var director = direct.script(MyCalculator)
	var _get_approx_pi = director.method("get_approx_pi")
	var _double = director.double()
	asserts.was_not_called(director, "get_approx_pi")
	
# Developers can use asserts.was_called_with_arguments(director, method, args)..
# ..to check if a method was called on a test double with a certain set of..
# ..args (which will fail if it was not called or called with the wrong args).
func test_doubled_methods_was_called_with_arguments() -> void:
	var director = direct.script(MyCalculator)
	var _add = director.method("add")
	var double = director.double()
	double.add(2, 8)
	asserts.was_called_with_arguments(director, "add", [2, 8])
	
# Developers can use asserts.was_called_with_arguments(director, method, args)..
# ..to check if a method was called on a test double with a certain set of..
# ..args (which will fail if it was not called or called with the wrong args)..
# ..but in this example any() is being used to say that any argument will match
# ..that value but the second argument must always be 8.
func test_doubled_methods_was_called_with_partial_argument() -> void:
	var director = direct.script(MyCalculator)
	var _add = director.method("add")
	var double = director.double()
	double.add(2, 8)
	asserts.was_called_with_arguments(director, "add", [any(), 8])
	
# Developers can use .call_super() to call the base implementation of a Method..
# ..that is currently being directed as the default call instead of returning..
# ..null. (Note: Test Doubles are actually classes that *inherit* the script..
# ..being doubled, therefore call_super() refers to implementation within that..
# ..base script, not the implementation in that base script's parent).
func test_doubled_methods_call_implementation_instead_of_null() -> void:
	var director = direct.script(Enemy)
	director.method("get_type").call_super()
	var double = director.double()
	asserts.is_equal(double.get_type(), "[Enemy]")
	
# Developers can pass in a function (via funcref) that takes an Object and an..
# ..array of arguments. The test doubled method will then call that function..
# ..passing in itself, and the set of arguments passed to the calling function.
func test_subcall_via_funcref() -> void:
	var director = direct.script(MyCalculator)
	director.method("add").subcall(funcref(self, "double_add"))
	var double = director.double()
	asserts.is_equal(double.add(2, 2), 8)
	
# Developers can pass an object that has a call_func method that takes an.. 
# ..Object and an array of arguments. The test doubled method will then call.. 
# ..that function passing in itself, and the set of arguments passed to the.. 
# ..calling function. This is useful if you need to store some resulting state.
func test_subcall_via_object() -> void:
	var myCallable = MyCallable.new()
	var director = direct.script(MyCalculator)
	director.method("add").subcall(myCallable)
	var double = director.double()
	var return_value = double.add(2, 2)
	asserts.is_equal(myCallable.arguments[0], 2)
	asserts.is_equal(myCallable.arguments[1], 2)
	asserts.is_equal(return_value, 4)
	
class MyCallable:
	var arguments = []
	
	func call_func(_obj: Object, args: Array):
		arguments = args
		return args[0] + args[1]
		
func double_add(_obj: Object, args: Array):
	return (args[0] + args[1]) * 2
