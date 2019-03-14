extends Node
# If we're prefixing everything with WAT, might be better
# to have a WAT accessor script (maybe the config?)
class_name WATDouble

####	# Add self as metadata to script (we could do a property object but using metadata is more inconspicoius)
#### Config for type checking (do we keep as is, remove param/return types or mod elsewhere?)
#### Add a Method Class, a Call class (or data structure?)

const _WRITER = preload("res://addons/WAT/TestDoubling/Writer.gd")
var instance
var _methods: Dictionary = {}

func _init(script: Script) -> void:
	self.instance = _WRITER.new().rewrite(script)
	instance.set_meta("double", self)


func get_retval(id: String, arguments: Dictionary):
	if not _methods.has(id):
		_methods[id] = Method.new(id, 1, arguments)
		return null
	else:
		var retval = _methods[id].get_retval(arguments)
		print(retval)
		return retval
#		return _methods[id].get_retval(arguments)

func stub(id: String, arguments: Dictionary, retval) -> void:
	if not _methods.has(id):
		_methods[id] = Method.new(id, 0)
	_methods[id].stub(arguments, retval)

class Method:
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
		var retval
		for stub in stubs:
			retval = stub.retval
			print("retval: ", stub.retval)
			var correct: bool = true
			for key in arguments:
				if arguments[key] != stub.arguments[key]:
					correct = false
					break # set flag here?
			if correct:
				break
		print(retval)
		return retval