extends Reference


func write(double):
	var source: String = ""

	## Basic
	if double.inner != "":
		source = 'extends "%s".%s\n' % [double.base_script, double.inner]
		source += "\nconst BASE = preload('%s').%s\n\n" % [double.base_script, double.inner]
	else:
		source = 'extends "%s"\n' % double.base_script
		source += "\nconst BASE = preload('%s')\n\n" % double.base_script
	var constructor_params =  "a,b,c,d,e,f,g,h,i,j,".substr(0, double.dependecies.size() * 2 - 1)
	source += "\nfunc _init(%s).(%s):\n\tpass\n" % [constructor_params, constructor_params]

	### Methods
	for name in double.methods:
		source += double.methods[name].to_string(double.resource_path)
	return source

#	add_method_source_code()