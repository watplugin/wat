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
	var new_method: String = "func %s(%s)%s:\n\t%s" % [method.name, _parameters(method.parameters), _return_value(method.retval), _body(method.name, method.parameters, retval_is_void, method.returns_value)]
	print(new_method)
	return new_method
	
static func _parameters(parameters: Array) -> String:
	var result: String = ""
	for param in parameters:
		result += "%s:%s," % [param.name, param.type] if (param.typed and WATConfig.parameters()) else "%s," % [param.name]
	result = result.rstrip(",")
	return result
	
static func _return_value(retval: Dictionary) -> String:
	if not WATConfig.return_value() or not retval.typed or (retval.type == "void" and WATConfig.void_excluded()):
		# If we don't use retvals or if retval isn't type or retval is an excluded void type
		return ""
	else:
		return " -> %s" % retval.type
		
# if self.get_meta("double").is_doubled("add"):
#	return .add(a, b) / .add(a, b)

static func _body(title, parameters, is_void: bool, returns_value: bool) -> String:
	var p_list: Array = []
	for p in parameters:
		p_list.append(p.name)
	var double_check: String = "if not self.get_meta('double').is_doubled('%s'):\n\t\t%s.%s%s\n\telse:\n\t" % [title, "return " if returns_value else "", title, str(p_list).replace("[", "(").replace("]", ")")]
	var arguments: String = ""
	for param in parameters:
		arguments += '"%s": %s, ' % [param.name, param.name]
	var args = ("\tvar arguments = {%s}" % arguments).replace(", }", "}")
	# ADD ABILITY TO DO A SUPER CALL HERE IF PARTIAL ENABLED
	var retexpr: String = "" if is_void and not WATConfig.void_excluded() else "\n\t\treturn retval"
	var retval: String = '\n\t\tvar retval = self.get_meta("double").get_retval("%s", arguments)%s\n\n' % [title, retexpr]
	return double_check + args + retval