extends Reference


func write(double):
	var source: String = ""
	if double.inner != "":
		source = 'extends "%s".%s\n' % [double.base_script, double.inner]
		source += "\nconst BASE = preload('%s').%s\n\n" % [double.base_script, double.inner]
	else:
		source = 'extends "%s"\n' % double.base_script
		source += "\nconst BASE = preload('%s')\n\n" % double.base_script
	var constructor_params =  "a,b,c,d,e,f,g,h,i,j,".substr(0, double.dependecies.size() * 2 - 1)
	source += "\nfunc _init(%s).(%s):\n\tpass\n" % [constructor_params, constructor_params]

	for name in double.methods:
		var m = double.methods[name]
		source += _method_to_string(double.resource_path, m.keyword, m.name, m.args, m.supers.size(), m.spying, m.stubbed)
	for klass in double.klasses:
		source += _inner_class(klass)
	return source

func _method_to_string(doubler, keyword, name, args, super, spying, stubbed):
	var text: String
	text += "%sfunc %s(%s):" % [keyword, name, args]
	text += "\n\tvar args = [%s]" % args
	text += "\n\tvar method = load('%s').methods['%s']" % [doubler, name]
	if super > 0:
		text += "\n\tvar call_super: bool = method.supers.size() > 0"
		text += "\n\tif method.executes(args):"
		text += "\n\t\treturn .%s(%s)" % [name, args]
		text += "\n\tprint('Ello')"
	if spying:
		text += "\n\tmethod.add_call(args)"
	if stubbed:
		text += "\n\tvar retval = method.get_stub(args)"
		text += "\n\treturn retval"
	return text

func _inner_class(klass):
	return "\nclass %s extends 'S%s.gd':\n\tconst PLACEHOLDER = 0" % [klass.name, klass.doubler.index]