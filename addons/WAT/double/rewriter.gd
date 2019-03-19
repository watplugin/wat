extends Reference

const _TEMP: String = "user://WATemp/"

static func start(source: Object) -> Script:
	var rewrite: String
	rewrite += "%s" % source.extend
	for method in source.methods:
		rewrite += _rewrite_method(method)
	_save(source.title, rewrite)
	var x = load(_TEMP + source.title + ".gd").new()
	return x
#	return load(_TEMP + source.title + ".gd")
	
static func _rewrite_method(method: Dictionary) -> String:
	var rewritten_method: String = "func %s(%s)%s%s"
	var title: String = method.name
	var parameters: String = _rewrite_parameters(method.parameters)
	var retval: String = _rewrite_retval(method.retval)
	var body: String = _rewrite_body(title, method.parameters)
	var rewrite = rewritten_method % [title, parameters, retval, body]
	return rewrite
	
static func _rewrite_parameters(parameters: Array) -> String:
	var result: String = ""
	for param in parameters:
		if param.typed:
			result += "%s:%s, " % [param.name, param.type]
		else:
			result += "%s," % [param.name]
	result = result.rstrip(", ")
	return result
	
static func _rewrite_retval(retval: Dictionary) -> String:
	if retval.typed:
		return " -> %s:" % retval.type
	return ":"
	
static func _rewrite_body(title, parameters) -> String:
	var args: String = "\n\tvar arguments = {"
	for param in parameters:
		args += ' "%s": %s,' % [param.name, param.name]
	args = args.rstrip(",").replace("{ ", "{") + "}".dedent()
	args = args.replace('{"": }', "{}") # In case its empty
	var retval: String = '\n\treturn self.get_meta("double").get_retval("%s", arguments)\n\n' % title
	return args + retval

static func _save(title: String, rewrite: String) -> void:
	_create_directory()
	var file: File = File.new()
	file.open("%s%s.gd" % [_TEMP, title], file.WRITE)
	file.store_string(rewrite)
	file.close()
	
static func _create_directory() -> void:
	var dir = Directory.new()
	if not dir.dir_exists(_TEMP):
		dir.make_dir(_TEMP)
# write
# save
#func _instance(source: Source) -> Script:
#	return load("%s%s.gd" % [_TEMP, source.title]).new()
#

#
#func _create_directory() -> void: # Maybe change this to a bool?

#
#
#func _retval_delegate(identifier: String) -> String:
#	return "\n\treturn self.get_meta('double').get_retval('%s', parameters)\n" % identifier