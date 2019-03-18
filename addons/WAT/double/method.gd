extends Reference

var identifier: String
var calls: Array = []
var stubs: Array = []
var call_count: int = 0

func _init(method_id, call: int, arguments: Dictionary = {}) -> void:
	self.identifier = method_id
	call_count += call
	if call_count != 0:
		calls.append(arguments)
		
func stub(arguments: Dictionary, retval):
	stubs.append({"arguments": arguments, "retval": retval})

func get_retval(arguments: Dictionary):
	call_count += 1
	calls.append(arguments)
	var retval
	for stub in stubs:
		retval = stub.retval
		var correct: bool = true
		for key in arguments:
			if arguments[key] != stub.arguments[key]:
				correct = false
				break # set flag here?
		if correct:
			break
	return retval