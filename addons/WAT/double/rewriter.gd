extends Reference

static func start(source: Object) -> String:
	var rewrite: String
	rewrite += "%s" % source.extend
	for method in source.methods:
		rewrite += _rewrite_method(method)
	return rewrite
	
static func _rewrite_method(method: Dictionary) -> String:
	return "func %s(%s)%s:\n\t%s" % [method.name, _parameters(method.parameters), _return_value(method.retval), _body(method.name, method.parameters)]
	
static func _parameters(parameters: Array) -> String:
	var result: String = ""
	for param in parameters:
		result += "%s:%s," % [param.name, param.type] if (param.typed and WATConfig.check_enforced_type_parameters()) else "%s," % [param.name]
	result = result.rstrip(",")
	return result
	
static func _return_value(retval: Dictionary) -> String:
	return " -> %s" % retval.type if retval.typed else ""
	
static func _body(title, parameters) -> String:
	var arguments: String = ""
	for param in parameters:
		arguments += '"%s": %s, ' % [param.name, param.name]
	var args = ("var arguments = {%s}" % arguments).replace(", }", "}")
	# ADD ABILITY TO DO A SUPER CALL HERE IF PARTIAL ENABLED
	var retval: String = '\n\treturn self.get_meta("double").get_retval("%s", arguments)\n\n' % title
	return args + retval