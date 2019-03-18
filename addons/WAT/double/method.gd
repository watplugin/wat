extends Reference

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