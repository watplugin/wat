extends Reference

const DOUBLE: String = "double"
var _methods: Dictionary = {}
var instance: Object
const is_scene: bool = false
signal DOUBLE_EXECUTE_METHOD

func _init(methods: Array, instance) -> void:
	self.instance = instance
	instance.set_meta(DOUBLE, self)
	for method in methods:
		_add_method(method.name)

func execute(method: String, count: int = 0, a = null, b = null, c = null, d = null, e = null, f = null, g = null, h = null, i = null):
	var args: Array = [a, b, c, d, e,f, g, h, i]
	args.resize(count)
	return self.instance.callv(method, args)

func _add_method(_name) -> void:
	_methods[_name] = Method.new(_name)
	
func stub(title: String, arguments: Dictionary, retval) -> void:
	_methods[title].stub(arguments, retval)
	
func call_count(title: String) -> int:
	return _methods[title].call_count
	
func get_retval(title: String, arguments: Dictionary):
	return _methods[title].get_retval(arguments)
	
class Method extends Reference:
	var title: String
	var calls: Array = []
	var stubs: Array = []
	var call_count: int = 0
	
	func _init(title: String) -> void:
		self.title = title
		
	func stub(arguments: Dictionary, retval) -> void:
		stubs.append({"arguments": arguments, "retval": retval})
		
	func get_retval(arguments: Dictionary):
		_add_call(arguments)
		for stub in stubs:
			if _key_value_match(arguments, stub.arguments):
				return stub.retval
		return null

	func _add_call(arguments: Dictionary) -> void:
		self.call_count += 1
		calls.append(arguments)
		
	func _key_value_match(a: Dictionary, b: Dictionary) -> bool:
		for key in a:
			if a[key] != b[key]:
				return false
		return true