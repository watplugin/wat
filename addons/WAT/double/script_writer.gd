extends Reference


func write(double) -> String:
	var source: String = ""
	source += _extension_to_string(double)
	source += "\nconst WATRegistry = []\n"
	if double.base_methods.has("_init"):
		source += _constructor_to_string(double.base_methods["_init"].args) #, double.base_methods["_init"])

	for name in double.methods:
		var m = double.methods[name]
		source += _method_to_string(double.get_instance_id(), m)
	for klass in double.klasses:
		source += _inner_class(klass)
	source = source.replace(",)", ")")
	return source
	
func _extension_to_string(double) -> String:
	if double.is_built_in:
		return 'extends %s' % double.klass
	if double.inner_klass != "":
		return 'extends "%s".%s\n' % [double.klass, double.inner_klass]
	return 'extends "%s"\n' % double.klass
	
func _constructor_to_string(parameters: String) -> String:
	var constructor: String = ""
	constructor += "\nfunc _init(%s).(%s):" % [parameters, _params_without_types(parameters)]
	constructor += "\n\tpass\n"
	return constructor
	
func _params_without_types(parameters: String) -> String:
	var _param_names: String = ""
	for param in parameters.split(","):
		if ":" in param:
			_param_names += "%s, " % param.substr(0, param.find(":")).strip_edges()
		elif "=" in param:
			_param_names += "%s, " % param.substr(0, param.find("=")).strip_edges()
		else:
			_param_names += "%s, " % param
	return _param_names.rstrip(", ")

func _method_to_string(id: int, method: Object) -> String:
	var text: String
	text += "{keyword}func {name}({args}){retval}:"
	text += "\n\tvar args = [{argNames}]"
	text += "\n\tvar method = WATRegistry[0].method({id}, '{name}')"
	text += "\n\tmethod.add_call(args)"
	text += "\n\tif method.executes(args):"
	text += "\n\t\treturn .{name}({argNames})"  # We may want to add a retval check here
	text += "\n\treturn method.primary(args)\n\n"
	text = text.format({"id": id, "keyword": method.keyword, "name": method.name, 
						"argNames": method.argNames, "args": method.args, "retval": method.retval})
	return text

func _inner_class(klass: Dictionary) -> String:
	return "\nclass %s extends '%s'.%s:\n\tconst PLACEHOLDER = 0" % [klass.name, klass.director.klass, klass.name]
