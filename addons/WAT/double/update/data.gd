extends Resource

const BLANK = preload("res://addons/WAT/double/objects/blank.gd")
const FILESYSTEM = preload("res://addons/WAT/utils/filesystem.gd")
const STATIC_METHOD: bool = true
export(String) var doubled_path: String
export(Dictionary) var methods: Dictionary = {}

func double() -> Resource:
	return load(doubled_path)

func instance() -> Object:
	var instance = load(doubled_path).new()
	instance.set_meta("double", self)
	return instance

func dummy(method: String, default = null) -> void:
	print("Dummy Method: %s" % method)
	if not methods.has(method):
		assert(false)
	# Write everything, then manage it elsewhere
	_rewrite("\nfunc add(%s):\n\treturn get_meta('double').methods.%s.retval" % [_parameters(methods[method].argcount), method])

func stub(method: String, arguments: Dictionary, retval, is_static_method: bool = false) -> void:
	pass # Stub the method

func _parameters(size: int) -> String:
	var list = "abcdefghij"
	var parameters: String = ""
	for i in size:
		parameters += "%s, " % list[i]
	parameters = parameters.trim_suffix(", ")
	return parameters

func _rewrite(code: String):
	var double = load(doubled_path)
	double.source_code += code
	ResourceSaver.save(doubled_path, double)