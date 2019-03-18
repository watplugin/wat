extends Node
class_name WATDouble

####	# Add self as metadata to script (we could do a property object but using metadata is more inconspicoius)
#### Config for type checking (do we keep as is, remove param/return types or mod elsewhere?)
#### Add a Method Class, a Call class (or data structure?)

const METHOD = preload("method.gd")
const _WRITER = preload("writer.gd")
var instance
var _methods: Dictionary = {}

func _init(script: Script) -> void:
	self.instance = _WRITER.new().rewrite(script)
	instance.set_meta("double", self)
	
#	func _instance(source: Source) -> Script:
#	return load("%s%s.gd" % [_USERDIR, source.title]).new()

func get_retval(id: String, arguments: Dictionary):
	if not _methods.has(id):
		_methods[id] = METHOD.new(id, 1, arguments)
		return null
	else:
		return _methods[id].get_retval(arguments)

func stub(id: String, arguments: Dictionary, retval) -> void:
	if not _methods.has(id):
		_methods[id] = METHOD.new(id, 0)
	_methods[id].stub(arguments, retval)

func call_count(method: String) -> int:
	return _methods[method].call_count

