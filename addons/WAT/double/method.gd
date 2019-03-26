extends Reference

const DOUBLE = "double"
var _methods: Dictionary = {}
var instance: Object

func _init(methods: Array, instance) -> void:
	self.instance = instance
	instance.set_meta(DOUBLE, self)
	for method in methods:
		_add_method(method.name)
	
func _add_method(_name: String) -> void:
	var method: Method = Method.new(_name)
	_methods[_name] = method

func get_retval(id: String, arguments: Dictionary):
	return _methods[id].get_retval(arguments)

func stub(id: String, arguments: Dictionary, retval) -> void:
	_methods[id].stub(arguments, retval)

func call_count(method: String) -> int:
	return _methods[method].call_count
	
func calls(method) -> Array:
	return _methods[method].calls
		
class Method extends Reference:
	var name: String
	var calls: Array = []
	var stubs: Array = []
	var call_count: int = 0
	
	func _init(_name: String) -> void:
		self.name = _name
	 
	func stub(arguments: Dictionary, retval):
		stubs.append({"arguments": arguments, "retval": retval})
		
	func get_retval(arguments: Dictionary):
		_add_call(arguments)
		for stub in stubs:
			if _key_value_match(arguments, stub.arguments):
				return stub.retval
		return null
	
	func _add_call(arguments) -> void:
		self.call_count += 1
		calls.append(arguments)
	
	func _key_value_match(a: Dictionary, b: Dictionary) -> bool:
		for key in a:
			if a[key] != b[key]:
				return false
		return true