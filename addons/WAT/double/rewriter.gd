extends Reference
tool

static func start(source: Object) -> String:
	var rewrite: String
	rewrite += "%s" % source.extend
	for method in source.methods:
		rewrite += _rewrite_method(method)
	return rewrite
	
static func _rewrite_method(method: Dictionary) -> String:
	var retval_is_void: bool = method.retval.typed and method.retval.type == "void"
	return "func %s(%s)%s:\n\t%s" % [method.name, _parameters(method.parameters), _return_value(method.retval), _body(method.name, method.parameters, retval_is_void)]
	
static func _parameters(parameters: Array) -> String:
	var result: String = ""
	for param in parameters:
		result += "%s:%s," % [param.name, param.type] if (param.typed and WATConfig.parameters()) else "%s," % [param.name]
	result = result.rstrip(",")
	return result
	
static func _return_value(retval: Dictionary) -> String:
	if retval.typed and WATConfig.return_value() and not WATConfig.void_excluded():
		return " -> %s" % retval.type
	elif retval.type == "void" and WATConfig.return_value() and WATConfig.void_excluded():
		return ""
	else:
		return ""
	
static func _body(title, parameters, is_void: bool) -> String:
	var arguments: String = ""
	for param in parameters:
		arguments += '"%s": %s, ' % [param.name, param.name]
	var args = ("var arguments = {%s}" % arguments).replace(", }", "}")
	# ADD ABILITY TO DO A SUPER CALL HERE IF PARTIAL ENABLED
	var retexpr: String = "" if is_void and not WATConfig.void_excluded() else "\n\treturn retval"
	var retval: String = '\n\tvar retval = self.get_meta("double").get_retval("%s", arguments)%s\n\n' % [title, retexpr]
	return args + retval