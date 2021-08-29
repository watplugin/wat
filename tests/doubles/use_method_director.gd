extends WAT.Test

func test_doubled_methods_return_null_by_default() -> void:
	var director = direct.script(MyCalculator)
	var _method = director.method("get_approx_pi")
	var double = director.double()
	asserts.is_null(double.get_approx_pi())
	
func test_stub_methods_with_return_value() -> void:
	var director = direct.script(MyCalculator)
	var get_approx_pi = director.method("get_approx_pi")
	get_approx_pi.stub(100)
	var double = director.double()
	asserts.is_equal(double.get_approx_pi(), 100)
	
func test_stub_methods_with_return_value_based_on_param_values() -> void:
	var director = direct.script(MyCalculator)
	var add = director.method("add")
	add.stub(1, [2, 2])
	var double = director.double()
	asserts.is_equal(double.add(2, 2), 1)

func test_stub_methods_with_return_value_based_on_partial_param_values() -> void:
	var director = direct.script(MyCalculator)
	var add = director.method("divide")
	add.stub(1, [any(), 0])
	var double = director.double()
	asserts.is_equal(double.divide(52, 0), 1)
	
func test_doubled_methods_was_called() -> void:
	var director = direct.script(MyCalculator)
	var _get_approx_pi = director.method("get_approx_pi")
	var double = director.double()
	double.get_approx_pi()
	asserts.was_called(director, "get_approx_pi")
	
func test_doubled_method_was_not_called() -> void:
	var director = direct.script(MyCalculator)
	var _get_approx_pi = director.method("get_approx_pi")
	var _double = director.double()
	asserts.was_not_called(director, "get_approx_pi")
	
func test_doubled_methods_was_called_with_arguments() -> void:
	var director = direct.script(MyCalculator)
	var _add = director.method("add")
	var double = director.double()
	double.add(2, 8)
	asserts.was_called_with_arguments(director, "add", [2, 8])
	
func test_doubled_methods_was_called_with_partial_argument() -> void:
	var director = direct.script(MyCalculator)
	var _add = director.method("add")
	var double = director.double()
	double.add(2, 8)
	asserts.was_called_with_arguments(director, "add", [any(), 8])
	
func test_doubled_methods_call_implementation_instead_of_null() -> void:
	var director = direct.script(Enemy)
	director.method("get_type").call_super()
	var double = director.double()
	asserts.is_equal(double.get_type(), "[Enemy]")
	
func test_subcall_via_funcref() -> void:
	var director = direct.script(MyCalculator)
	director.method("add").subcall(funcref(self, "double_add"))
	var double = director.double()
	asserts.is_equal(double.add(2, 2), 8)
	
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
