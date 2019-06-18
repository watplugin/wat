extends Reference
tool

class Template:
	var title: String
	var parameters: String
	var return_type: String
	var kwargs: String
	var return_value: String
	var content = \
"""func %s(%s)%s:
	var kwargs = %s
	self.get_meta('double').add_call('%s', kwargs)
	if not self.get_meta('double').is_doubled('%s'):
		%s.%s(%s)
	else:
		return self.get_meta('double').get_retval('%s', kwargs)
""" setget ,_get_content

	func _get_content() -> String:
		return content % [self.title, self.parameters, self.return_type, self.kwargs, self.title, self.title, self.return_value, self.title, self.parameters, self.title]
	

static func start(source: Object) -> String:
	var rewrite: String
	rewrite += "%s" % source.extend
	for method in source.methods:
		rewrite += _rewrite_method(method)
	return rewrite
	
static func _rewrite_method(method):
	var temp = Template.new()
	temp.title = method.name
	temp.parameters = _parameters(method.parameters)
	temp.return_type = _return_type(method.retval)
	temp.kwargs = _kwargs(method.parameters)
	temp.return_value = "return " if method.returns_value else ""
	return temp.content

static func _kwargs(parameters: Array) -> String:
	var args: Dictionary = {}
	for p in parameters:
		args["'%s'" % p.name] = p.name
	var kwargs = str(args)
	return kwargs
	
static func _parameters(parameters: Array) -> String:
	var result: String = ""
	for param in parameters:
		result += "%s:%s," % [param.name, param.type] if (param.typed and WATConfig.parameters()) else "%s," % [param.name]
	result = result.rstrip(",")
	return result
	
static func _return_type(retval: Dictionary) -> String:
	if not WATConfig.return_value() or not retval.typed or (retval.type == "void" and WATConfig.void_excluded()):
		# If we don't use retvals or if retval isn't type or retval is an excluded void type
		return ""
	else:
		return " -> %s" % retval.type