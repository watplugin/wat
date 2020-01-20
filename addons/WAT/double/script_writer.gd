extends Reference


func write(double) -> String:
	var source: String = ""
	if double.inner != "":
		source = 'extends "%s".%s\n' % [double.base_script, double.inner]
		source += "\nconst BASE = preload('%s').%s\n\n" % [double.base_script, double.inner]
	else:
		source = 'extends "%s"\n' % double.base_script
		source += "\nconst BASE = preload('%s')\n\n" % double.base_script
	
	if double.base_methods.has("_init"):
		source += _constructor_to_string(double.base_methods["_init"])

	for name in double.methods:
		var m = double.methods[name]
		source += _method_to_string(double.instance_id, m.keyword, m.name, m.args, m.calls_super, m.spying, m.stubbed)
	for klass in double.klasses:
		source += _inner_class(klass)
	source = source.replace(",)", ")")
	return source
	
func _constructor_to_string(parameters: String) -> String:
	var constructor: String = ""
	if parameters.length() > 0:
		constructor += "\nfunc _init(%s).(%s):" % [parameters, parameters]
	else:
		constructor += "\nfunc _init():"
	constructor += "\n\tpass\n"
	return constructor

func _method_to_string(id: int, keyword: String, name: String, args: String, calls_super: bool, spying: bool, stubbed: bool) -> String:
	var text: String
	text += "%sfunc %s(%s):" % [keyword, name, args]
	text += "\n\tvar args = [%s]" % args
#	ProjectSettings.get_setting("WAT/TestDouble").method(%s, '%s')
	text += "\n\tvar method = ProjectSettings.get_setting('WAT/TestDouble').method(%s, '%s')" % [id, name]
#	text += "\n\tvar method = _double_data_struct[0].methods['%s']" % name
	if spying:
		text += "\n\tmethod.add_call(args)"
	if calls_super:
		text += "\n\tif method.executes(args):"
		text += "\n\t\treturn .%s(%s)" % [name, args]
	if stubbed:
		text += "\n\tvar retval = method.get_stub(args)"
		text += "\n\treturn retval"
	return text

func _inner_class(klass: Dictionary) -> String:
	return "\nclass %s extends '%s'.%s:\n\tconst PLACEHOLDER = 0" % [klass.name, klass.director.base_script, klass.name]
